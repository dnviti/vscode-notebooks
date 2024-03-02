### Python + .NET 8 + VSCode Server + SSH

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
