## Build image

```bash
docker build -t valheim-server .
```

## Run server

```bash
docker run -d --name valheim -p 2456-2457:2456-2457/tcp -p 2456-2457:2456-2457/udp -e SERVER_NAME="My Server" -e SERVER_PASSWORD="secret" -e WORLD="Dedicated" -e PORT=2456 -e PUBLIC=0 -v valheim-data:/data valheim-server
```

## Stop server

```bash
docker stop -t 30 valheim
```

## Backup volume

```bash
docker run --rm -v valheim-data:/data -v ${PWD}:/backup alpine tar czf /backup/valheim-data.tar.gz -C /data .
```

## Restore backup

```bash
docker run --rm -v valheim-data:/data -v ${PWD}:/backup alpine sh -c "rm -rf /data/* && tar xzf /backup/valheim-data.tar.gz -C /data"
```
