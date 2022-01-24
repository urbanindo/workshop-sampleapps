package greeter

import "fmt"

// SayHello : it will return "Hello ${name}"
func SayHello(name string) string {
	return fmt.Sprintf("Hello %s!", name)
}
