package controller

import (
	"monolith-2-microservices/service"
	"net/http"
)

type HealthCheckController struct {
	postService *service.PostService
}

func NewHealthCheckController() *HealthCheckController {
	return &HealthCheckController{}
}

func (pc *HealthCheckController) Check(rw http.ResponseWriter, _ *http.Request) {
	rw.WriteHeader(http.StatusOK)
	rw.Write([]byte("Still alive"))
}
