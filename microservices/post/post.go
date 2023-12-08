package main

import (
	"encoding/json"
	"log"
	"post/config"
	"post/db"
	"post/service"

	"net/http"
)

var postService *service.PostService

func init() {
	conf, err := config.LoadConfig()
	if err != nil {
		log.Fatalln(err)
	}
	db.ConnectDB(&conf)
	postService = service.NewPostService(db.DB)
}

func Posts(rw http.ResponseWriter, req *http.Request) {
	postID := req.URL.Query().Get("id")
	if postID != "" {
		res, err := postService.FindById(postID)
		if err != nil {
			rw.WriteHeader(http.StatusNotFound)
			rw.Write(mustMarshal(map[string]string{"status": "fail", "message": "No post with that title exists"}))
			return
		}
		rw.WriteHeader(http.StatusOK)
		rw.Write(mustMarshal(res))
		return
	}

	res, err := postService.FindByAll()
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
