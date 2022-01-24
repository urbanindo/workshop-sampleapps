package greeter_test

import (
	"testing"

	"github.com/matryer/is"
	"github.com/neemiasjnr/golang-microservice-example/pkg/greeter"
)

func Test(t *testing.T) {
	is := is.New(t)

	data := greeter.SayHello("Mary")
	is.Equal(data, "Hello Mary!")
}
