# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Update the system and install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl bzip2 openssh-server python3-venv python-is-python3 git

# Install dotnet-sdk for polyglot notebook
RUN wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-7.0

# Install the latest version of Anaconda
RUN latest=$(wget -qO- https://repo.anaconda.com/archive/ | grep -Eo "(href=\")(Anaconda3-.*-Linux-x86_64.sh)*\"" | sed 's/href=//g' | sed 's/\"//g' | head -n 1); wget "https://repo.anaconda.com/archive/$latest" -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    /opt/conda/bin/conda clean --all

# Set environment variables for Anaconda
ENV PATH /opt/conda/bin:$PATH

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Configure SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# Set environment variables for SSH user and password
ENV SSH_USER vscode
ENV SSH_PASSWORD vscode
RUN useradd -m -s /bin/bash ${SSH_USER} && \
    echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd

# Set environment variable for SSH key
ENV SSH_KEY -
RUN mkdir -p /home/${SSH_USER}/.ssh && \
    echo "${SSH_KEY}" > /home/${SSH_USER}/.ssh/id_rsa && \
    chown ${SSH_USER}:${SSH_USER} /home/${SSH_USER}/.ssh/id_rsa && \
    chmod 600 /home/${SSH_USER}/.ssh/id_rsa

# Create the /work directory and set permissions
RUN mkdir /work
RUN chmod 777 /work

# Expose code-server and SSH ports
EXPOSE 8080 22

# Start code-server and SSH server
CMD sh -c '/usr/sbin/sshd -D & /usr/bin/code-server --bind-addr 0.0.0.0:8080 --auth none /work & wait'

