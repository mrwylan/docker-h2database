# Docker image for H2

A Docker image for the [H2 Database Engine](https://www.h2database.com/).

## Versions

Currently the latest stable image is built, which according to
[this page](https://www.h2database.com/html/download.html)
You can build another version passing the release date to the build script.

## Build this image

```sh
./build.sh
```
or with a given specific release date, e.g.
```sh
./build.sh "2019-10-14"
```

## How to use this image

```sh
./run.sh
```
or run a specific release, e.g.
```sh
./run.sh "2019-10-14"
```

### Exposed Ports

The default *TCP port* **9092** is exposed, so standard container linking will make it
automatically available to the linked containers.
Port **8082** is exposed for the admin *web* site.
Further *JMX* is enabled and exposed on port **9010**.

Use this JDBC string to connect from another container:

```
jdbc:h2:tcp://my-h2/my-db-name
```
Use the connection with JMX enabled:
```
jdbc:h2:tcp://my-h2/my-db-name;JMX=true
```

## Using the web interface

If you want to connect to the H2 web interface. [Connect to port 8082.](http://localhost:8082)

## Environment Variables

`H2DATA` specifies the location for the db files. If not set, `/h2-data` is used
which is automatically created as an anonymous Docker volume.

### Further variables

| Variable | Value | Description |
| -------- | ----- | ----------- |
| H2DATA | /h2-data | db files location |
| H2_USER  | h2 | username |
| H2_GID | 5000 | gid |
| H2_UID | 5000 | uid |
| JAVA_OPTS | -Xms512m <br/>-Xmx1G | Restricted memory usage by default |
| JAVA_OPTS_JMX | -Dcom.sun.management.jmxremote <br/>-Dcom.sun.management.jmxremote.port=9010 <br/>-Dcom.sun.management.jmxremote.rmi.port=9010 <br/>-Dcom.sun.management.jmxremote.local.only=false <br/>-Dcom.sun.management.jmxremote.authenticate=false <br/>-Dcom.sun.management.jmxremote.ssl=false <br/>-Djava.rmi.server.hostname=host.docker.internal | JMX is enabled by default |