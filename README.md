# gRPC Go Hello World

https://grpc.io/docs/languages/go/quickstart/

# Requires the folowing system commands

`protoc`

For Mac:

```
brew install protobuf
```

And the following Go plugins:

```
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```

# Install Dependencies

```
go get google.golang.org/grpc
go get google.golang.org/protobuf
```

# Genrate gRPC Code

```
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld/helloworld.proto
```

# Build Client and Server

```
go build -o server ./greeter_server
go build -o client ./greeter_client
```

# gRPCurl

Install `gRPCurl` on Mac with `brew install grpcurl`

```
// list services
grpcurl --plaintext localhost:50051 list

// describe service
grpcurl --plaintext localhost:50051 describe helloworld.Greeter

// call method on service
grpcurl --plaintext localhost:50051 helloworld.Greeter/SayHello
```

# Extend

Add a new `SayHelloAgain()` method to `helloworld/helloworld.proto`

Insert these two lines:

```
// Sends another greeting
rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
```

So that the `.proto` file now looks like this:

```
// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
  // Sends another greeting
  rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

Regenerate gRPC code

### Update server

Add the following to `greeter_server/main.go`

```
func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
        return &pb.HelloReply{Message: "Hello again " + in.GetName()}, nil
}
```

### Update client

Add the following to `greeter_client/main.go` at the end of `main()` function body:

```
r, err = c.SayHelloAgain(ctx, &pb.HelloRequest{Name: *name})
if err != nil {
        log.Fatalf("could not greet: %v", err)
}
log.Printf("Greeting: %s", r.GetMessage())
```

### Recompile server, or `go run`

### Recompile client, or `go run` with the following arg:

```
client --name=Alice
```

You should see:

```
Greeting: Hello Alice
Greeting: Hello again Alice
```
