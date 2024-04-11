package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	ServerPort       string
	MongoHost        string
	MongoPort        string
	PostgresHost     string
	PostgresPort     string
	PostgresUser     string
	PostgresPassword string
	PostgresDatabase string
}

func NewConfig() Config {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	return Config{
		ServerPort:       getEnv("BACKEND_PORT", "8080"),
		MongoHost:        getEnv("MONGO_HOST", "localhost"),
		MongoPort:        getEnv("MONGO_PORT", "27017"),
		PostgresHost:     getEnv("POSTGRES_HOST", "localhost"),
		PostgresPort:     getEnv("POSTGRES_PORT", "5432"),
		PostgresUser:     getEnv("POSTGRES_USER", "postgres"),
		PostgresPassword: getEnv("POSTGRES_PASSWORD", "postgres"),
		PostgresDatabase: getEnv("POSTGRES_DB", "postgres"),
	}
}

func getEnv(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}
