prom2jsond
==

A HTTP daemon for [prom2json](https://github.com/prometheus/prom2json)

Usage
--

### Options

```
  -accept-invalid-cert
        Accept any certificate during TLS handshake. Insecure, use only for testing.
  -cert string
        certificate file
  -key string
        key file
  -path string
        path to expose (default "/")
  -port int
        port number to expose (default 80)
  -prom2jsoncmd string
        [MANDATORY] executable prom2json command
```

### Execute binary

```
$ prom2jsond --prom2jsoncmd=/path/to/prom2json --path=/stats --port=8080 https://app.example.com/target/stats
$ curl localhost:8080/stats # => output
```

### Execute with Docker
--

```
$ docker run -it -p 8080:8080 prom2jsond:latest --path=/stats --port=8080 http://app.example.com/target/stats
$ curl localhost:8080/stats # => output
```

How to build the binary
--

```
$ make build # bin/ has built binary
```

How to build the Docker container
--

```
$ make build-docker
```

Note
--

### Why execute the prom2json binary as external command?

In case of using prom2json as a library, that uses `log.Fatal` so it cannot control and recovery when occurs some errors (i.e. error occurs then daemon exits immediately). Thus this daemon executes the prom2json binary to make it be recoverable any errors.

License
--

Apache License 2.0

