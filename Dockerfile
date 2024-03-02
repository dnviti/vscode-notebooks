# Use the latest Ubuntu image as the base
FROM ubuntu:latest

USER root

# Update the system and install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl bzip2 openssh-server python3-pip python3-venv python-is-python3 git sudo

# Configure SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# Install dotnet-sdk for polyglot notebook
RUN wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y dotnet-sdk-8.0

# Install the latest version of Anaconda
RUN latest=$(wget -qO- https://repo.anaconda.com/archive/ | grep -Eo "(href=\")(Anaconda3-.*-Linux-x86_64.sh)*\"" | sed 's/href=//g' | sed 's/\"//g' | head -n 1); wget "https://repo.anaconda.com/archive/$latest" -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    /opt/conda/bin/conda clean --all

# Set environment variables for Anaconda
ENV PATH /opt/conda/bin:$PATH

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create the /work directory and set permissions
RUN mkdir /work
RUN chmod 777 /work -R

COPY start.sh /usr/sbin/start.sh
RUN chmod +x /usr/sbin/start.sh

# Set environment variables for SSH user and password
ENV SSH_USERNAME vscode
ENV SSH_PASSWORD changeme
ENV PASSWORD changeme

# Expose code-server and SSH ports
EXPOSE 8080 22

# Start code-server and SSH server
CMD sh -c '/usr/sbin/start.sh ${PASSWORD}'
