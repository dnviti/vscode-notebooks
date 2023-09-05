### Python Anaconda + .NET 7 + VSCode Server + SSH

Example Prebuilt Docker Image: [anaconda-vscode](https://hub.docker.com/r/dnviti/anaconda-vscode)

Create a .key file with your SSH Key inside

Create a .env file
```conf
SSH_KEY_CONTENT=$(cat .key)
SSH_USER=vscode # change
SSH_PASSWORD=vscode # change
```

Run docker build
```bash
docker compose build
```