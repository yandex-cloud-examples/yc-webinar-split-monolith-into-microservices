package service

import (
	"gorm.io/gorm"
	"post/model"
)

type PostService struct {
	DB *gorm.DB
}

func NewPostService(DB *gorm.DB) *PostService {
	return &PostService{DB}
}

func (s *PostService) FindById(id string) (*model.Post, error) {
	var post model.Post
	if result := s.DB.First(&post, "id = ?", id); result != nil {
		return nil, result.Error
	}
	return &post, nil
}

func (s *PostService) FindByAll() ([]model.Post, error) {
	var posts []model.Post
	if res := s.DB.Find(&posts); res.Error != nil {
		return nil, res.Error
	}
	return posts, nil
}
