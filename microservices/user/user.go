package controller

import (
	"net/http"
)

func Users(rw http.ResponseWriter, _ *http.Request) {
	rw.WriteHeader(http.StatusBadGateway)
	rw.Write([]byte("Returns 502 for demonstration purposes"))
}
