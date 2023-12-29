# debian-novnc

- Debian container with Xtightvnc, noVNC and openbox
- Can be accessed in a browser
- If built from scratch nonroot user has the same UID and GID as host's user, otherwise it's 1000:1000

## Run Locally

Clone the project

```bash
  git clone https://github.com/adrianharabula/debian-novnc.git
  cd debian-novnc
```

Build and run the Docker image

```bash
# Get your host's UID and GID
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)

# Build the Docker image
docker build --build-arg UID=$HOST_UID --build-arg GID=$HOST_GID -t ahdn .

# Run the Docker container
docker run --name ahdn --rm -d -p 127.0.0.1:6080:6080 ahdn
```

## Usage/Examples

Access http://127.0.0.1:6080/vnc.html?resize=remote&quality=0&compression=0&autoconnect=true and start using the container:

![image](https://github.com/adrianharabula/debian-novnc/assets/2271038/dcb63567-fcc8-4403-8a95-e015338d9fdc)

## License

[MIT](https://choosealicense.com/licenses/mit/)
