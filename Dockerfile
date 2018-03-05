FROM golang:1.9-alpine3.7 AS development

ENV PROJECT_PATH=/go/src/github.com/moznion/prom2json-daemon
ENV PATH=$PATH:$PROJECT_PATH/bin

RUN apk add --no-cache ca-certificates tzdata make git bash
RUN go get -u github.com/golang/dep/cmd/dep

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH

RUN make build build-prom2json-cmd

FROM alpine:latest AS production

WORKDIR /root/
RUN apk --no-cache add ca-certificates tzdata
COPY --from=development /go/src/github.com/moznion/prom2json-daemon/bin/prom2json .
COPY --from=development /go/src/github.com/moznion/prom2json-daemon/bin/prom2jsond .

ENTRYPOINT ["./prom2jsond", "--prom2jsoncmd", "./prom2json"]

