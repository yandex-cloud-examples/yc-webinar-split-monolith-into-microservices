package controller

import (
	"net/http"

	"monolith-2-microservices/service"
)

type UserController struct {
	userService *service.UserService
}

func NewUserController(userService *service.UserService) UserController {
	return UserController{userService}
}

func (c *UserController) Users(rw http.ResponseWriter, req *http.Request) {
	userID := req.URL.Query().Get("id")
	if userID == "" {
		rw.WriteHeader(http.StatusBadRequest)
		rw.Write(mustMarshal(map[string]string{"status": "fail", "message": "Users id required"}))
		return
	}

	res, err := c.userService.FindById(userID)
	if err != nil {
		rw.WriteHeader(http.StatusNotFound)
		rw.Write(mustMarshal(map[string]string{"status": "fail", "message": "No post with that title exists"}))
		return
	}
	rw.WriteHeader(http.StatusOK)
	rw.Write(mustMarshal(res))
	return
}
