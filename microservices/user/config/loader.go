package config

import (
	"github.com/caarlos0/env/v10"
)

type Config struct {
	DBHost         string `env:"POSTGRES_HOST"`
	DBUserName     string `env:"POSTGRES_USER"`
	DBUserPassword string `env:"POSTGRES_PASSWORD"`
	DBName         string `env:"POSTGRES_DB"`
	DBPort         string `env:"POSTGRES_PORT"`
	ServerPort     string `env:"PORT" envDefault:"3000"`
	LoadTestData   bool   `env:"LOAD_TEST_DATA" envDefault:"false"`
}

func LoadConfig() (config Config, err error) {
	err = env.Parse(&config)
	return
}
