package db

import (
	"time"

	"monolith-2-microservices/model"
)

func Load() error {
	timestamp := time.Now()
	users := []model.User{
		{
			Name:      "User-1",
			Email:     "user1@email.com",
			Password:  "123",
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
		{
			Name:      "User-2",
			Email:     "user2@email.com",
			Password:  "345",
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
	}
	if res := DB.Create(&users); res.Error != nil {
		return res.Error
	}
	posts := []model.Post{
		{
			Title:     "Title 1",
			Content:   "Post 1 payload",
			User:      users[0].ID,
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
		{
			Title:     "Title 2",
			Content:   "Post 2 payload",
			User:      users[0].ID,
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
		{
			Title:     "Title 3",
			Content:   "Post 3 payload",
			User:      users[1].ID,
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
		{
			Title:     "Title 4",
			Content:   "Post 4 payload",
			User:      users[1].ID,
			CreatedAt: timestamp,
			UpdatedAt: timestamp,
		},
	}
	if res := DB.Create(&posts); res.Error != nil {
		return res.Error
	}
	return nil
}
