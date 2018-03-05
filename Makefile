.PHONY: build build-prom2json-cmd build-docker installdeps clean check lint vet fmt-check

build: installdeps check
	go build -o bin/prom2jsond cmd/prom2jsond/main.go

build-prom2json-cmd: installdeps
	./devtools/build_prom2json_cmd.sh

build-docker:
	docker build --no-cache=true -t prom2jsond .

installdeps:
	dep ensure

clean:
	rm bin/*

check: fmt-check lint vet

lint:
	golint ./... | grep -v ^vendor/; \
		EXIT_CODE=$$?; \
		if [ $$EXIT_CODE -eq 0 ]; then exit 1; fi

vet:
	go vet ./...

fmt-check:
	gofmt -l . | grep -v ^vendor/; \
		EXIT_CODE=$$?; \
		if [ $$EXIT_CODE -eq 0 ]; then exit 1; fi

