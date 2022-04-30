all: install proto build

install:
	go get google.golang.org/grpc && go get google.golang.org/protobuf

proto:
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative helloworld/helloworld.proto

build:
	go build -o server ./greeter_server && go build -o client ./greeter_client