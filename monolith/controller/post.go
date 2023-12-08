package controller

import (
	"encoding/json"
	"net/http"

	"monolith-2-microservices/service"
)

type PostController struct {
	postService *service.PostService
}

func NewPostController(postService *service.PostService) *PostController {
	return &PostController{postService}
}

func (pc *PostController) Posts(rw http.ResponseWriter, req *http.Request) {
	postID := req.URL.Query().Get("id")
	if postID != "" {
		res, err := pc.postService.FindById(postID)
		if err != nil {
			rw.WriteHeader(http.StatusNotFound)
			rw.Write(mustMarshal(map[string]string{"status": "fail", "message": "No post with that title exists"}))
			return
		}
		rw.WriteHeader(http.StatusOK)
		rw.Write(mustMarshal(res))
		return
	}

	res, err := pc.postService.FindByAll()
	if err != nil {
		rw.WriteHeader(http.StatusBadGateway)
		rw.Write(mustMarshal(map[string]interface{}{"status": "error", "message": err}))
		return
	}
	rw.WriteHeader(http.StatusOK)
	rw.Write(mustMarshal(res))
}

func mustMarshal(any interface{}) []byte {
	res, err := json.Marshal(any)
	if err != nil {
		panic(err)
	}
	return res
}
