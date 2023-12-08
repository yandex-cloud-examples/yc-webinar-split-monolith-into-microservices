package service

import (
	"gorm.io/gorm"

	"monolith-2-microservices/model"
)

type UserService struct {
	DB *gorm.DB
}

func NewUserService(DB *gorm.DB) *UserService {
	return &UserService{DB}
}

func (s *UserService) FindById(id string) (*model.User, error) {
	var user model.User
	if result := s.DB.First(&user, "id = ?", id); result != nil {
		return nil, result.Error
	}
	return &user, nil
}
