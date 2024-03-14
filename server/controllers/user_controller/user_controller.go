package user_controller

import (
	"fmt"
	"log"
	"main/config"
	"main/middleware"
	"net/http"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type UserController struct {
	parent_endpoint string
	this_endpoint   string
	config          config.Config
	client          *gorm.DB
}

type User struct {
	Name     string
	Surname  string
	Email    string
	Password string
	UserID   string
}

func NewUserController(parent_endpoint string, config config.Config) *UserController {
	uc := UserController{
		parent_endpoint: parent_endpoint,
		this_endpoint:   fmt.Sprintf("%s/%s", parent_endpoint, "user"),
		config:          config,
	}

	db, err := connectToPostgres(config)
	if err != nil {
		log.Fatalf("Error connecting to PostgreSQL database: %v", err)
	}
	uc.client = db

	add_user_endpoint := fmt.Sprintf("%s/%s", uc.this_endpoint, "add_user")
	login_endpoint := fmt.Sprintf("%s/%s", uc.this_endpoint, "login")

	http.HandleFunc(add_user_endpoint, middleware.AllowedMethods(uc.AddUser, http.MethodPost))
	http.HandleFunc(login_endpoint, middleware.AllowedMethods(uc.Login, http.MethodPost))

	log.Printf("User controller initialized with endpoints: \n\t%s (POST)\n\t%s (POST)\n", add_user_endpoint, login_endpoint)

	return &uc
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

func (uc *UserController) AddUser(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "User added successfully")
}

func (uc *UserController) Login(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Login successful")
}
