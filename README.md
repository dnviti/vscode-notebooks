### Python Anaconda + .NET 8 + VSCode Server + SSH

Prebuilt Docker Image: [anaconda-vscode](https://hub.docker.com/r/dnviti/anaconda-vscode)

Create a .key file with your SSH Public Key inside

Create a .env file
```conf
SSH_USERNAME=changeme # ssh username
SSH_PASSWORD=changeme # ssh password
SSH_KEY_CONTENT=$(cat .key)
PASSWORD=changeme # vscode web gui password
```

Run docker build
```bash
docker compose build
```
