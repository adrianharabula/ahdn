# Debian container browser accessible through noVNC

- Debian container with Xtightvnc, noVNC and openbox
- Can be accessed in a browser
- If built from scratch nonroot user has the same UID and GID as host's user, otherwise it's 1000:1000

## Run Locally

Clone the project
```bash
  git clone https://github.com/adrianharabula/ahdn.git && cd ahdn
```

Build the Docker image with nonroot UID and GID set to default 1000
```bash
docker build -t ahdn .
```
OR build the Docker image with nonroot user having same UID and GID as host
```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t ahdn .
```

Run the Docker container
```bash
docker run --name ahdn --rm -d -p 127.0.0.1:6080:6080 ahdn
```

## Usage/Examples

Access http://127.0.0.1:6080/vnc.html?resize=remote&quality=0&compression=0&autoconnect=true and start using the container:

![image](https://github.com/adrianharabula/debian-novnc/assets/2271038/dcb63567-fcc8-4403-8a95-e015338d9fdc)

## Customization

- see the full list of parameters accepted by noVNC [here](https://github.com/novnc/noVNC/blob/master/docs/EMBEDDING.md#parameters)

## License

[MIT](https://choosealicense.com/licenses/mit/)
