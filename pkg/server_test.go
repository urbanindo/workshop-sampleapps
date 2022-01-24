package server_test

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/matryer/is"
	server "github.com/neemiasjnr/golang-microservice-example/pkg"
)

func Test(t *testing.T) {
	is := is.New(t)

	srv := server.New()
	var body server.VersionAPI
	req, err := http.NewRequest("GET", "/version", nil)
	is.NoErr(err) // http.NewRequest

	w := httptest.NewRecorder()
	srv.ServeHTTP(w, req)
	json.Unmarshal([]byte(w.Body.String()), &body)

	is.Equal(w.Code, http.StatusOK)
	is.Equal(body.ServiceName, "golang-microservice-example")
}
