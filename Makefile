BUILD_TARGET = github.com/ShibataTakao/daily-report/cmd/dailyreport
FMT_TARGET = $(shell find . -type f -name "*.go")
LINT_TARGET = $(shell go list ./...)
TEST_TARGET = ./...
VERSION = $(shell git describe --tags)
GOX_OSARCH="darwin/amd64 linux/amd64 windows/amd64"
GOX_OUTPUT="./release/{{.Dir}}_$(VERSION)_{{.OS}}_{{.Arch}}"

default: build

setup:
	go get golang.org/x/lint/golint
	go get golang.org/x/tools/cmd/goimports
	go get github.com/mitchellh/gox

fmt:
	goimports -w $(FMT_TARGET)

checkfmt:
	test ! -n "$(shell goimports -l $(FMT_TARGET))"

lint:
	go vet $(LINT_TARGET)
	golint $(LINT_TARGET)

test:
	go test $(TEST_TARGET)

build:
	go build $(BUILD_TARGET)

install:
	go install $(BUILD_TARGET)

release:
	gox -osarch $(GOX_OSARCH) -output=$(GOX_OUTPUT) $(BUILD_TARGET)

ci: checkfmt lint test build

.PHONY: default setup fmt checkfmt lint test build install release ci
