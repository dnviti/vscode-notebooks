### Python Anaconda + .NET 7 + VSCode Server + SSH

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