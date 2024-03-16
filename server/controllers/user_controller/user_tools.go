package user_controller

import (
	"fmt"
	"log"
	"main/config"
	"time"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type UserController struct {
	parent_endpoint string
	this_endpoint   string
	config          config.Config
	client          *gorm.DB
}

type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type User struct {
	FirstName      string     `json:"firstname"`
	LastName       string     `json:"lastname"`
	Email          string     `json:"email"`
	Password       string     `json:"password"`
	UserID         string     `json:"-"`
	Phone          *string    `json:"phone,omitempty"`
	LastLogin      *time.Time `json:"last_login,omitempty"`
	DateOfCreation time.Time  `json:"date_of_creation" gorm:"autoCreateTime"`
}

func connectToPostgres(config config.Config) (*gorm.DB, error) {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Europe/Warsaw",
		config.PostgresHost, config.PostgresUser, config.PostgresPassword, config.PostgresDatabase, config.PostgresPort)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		return nil, fmt.Errorf("failed to connect to database: %w", err)
	}
	log.Printf("Connected to PostgreSQL database %s on %s:%s", config.PostgresDatabase, config.PostgresHost, config.PostgresPort)
	return db, nil
}

func HashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
