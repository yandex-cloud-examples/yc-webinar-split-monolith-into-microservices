package main

import (
	"fmt"
	"log"
	"monolith-2-microservices/config"
	"net/http"

	"monolith-2-microservices/controller"
	"monolith-2-microservices/db"
	"monolith-2-microservices/model"
	"monolith-2-microservices/service"
)

func main() {
	config, err := config.LoadConfig(".")
	if err != nil {
		log.Fatal("Could not load environment variables", err)
	}
	db.ConnectDB(&config)
	migrate(&config)

	healthController := controller.NewHealthCheckController()
	postService := service.NewPostService(db.DB)
	postController := controller.NewPostController(postService)
	userService := service.NewUserService(db.DB)
	userController := controller.NewUserController(userService)

	mux := http.NewServeMux()
	mux.HandleFunc("/api/healthcheck", healthController.Check)
	mux.HandleFunc("/api/posts", postController.Posts)
	mux.HandleFunc("/api/users", userController.Users)

	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", config.ServerPort), mux))
}

func migrate(config *config.Config) {
	db.DB.Exec("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\"")
	if err := db.DB.AutoMigrate(&model.User{}, &model.Post{}); err != nil {
		fmt.Printf("Failed to migrate: %v\n", err)
	}
	fmt.Println("Migration complete")
	if config.LoadTestData && db.Load() != nil {
		fmt.Println("Failed to insert test data")
	}
}
