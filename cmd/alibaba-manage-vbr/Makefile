
BINARY =alibaba-manage-vbr
GOCMD  =go
TEST   ?=$$(go list ./... |grep -v 'vendor')

default: clean build test

all: default

test:
	echo $(TEST) | \
		xargs -t ${GOCMD} test -v -timeout=10m

clean:
	${GOCMD} clean
	rm -f ../../bin/win/${BINARY}
	rm -f ../../bin/darwin/${BINARY}
	rm -f ../../bin/linux/${BINARY}

build:
	env GOOS=windows GOARCH=amd64 ${GOCMD} build -o ../../bin/win/${BINARY}
	env GOOS=darwin GOARCH=amd64 ${GOCMD} build -o ../../bin/darwin/${BINARY}
	env GOOS=linux GOARCH=amd64 ${GOCMD} build -o ../../bin/linux/${BINARY}

.PHONY: build clean release
