package user_controller

import (
	"encoding/json"
	"fmt"
	"log"
	"main/config"
	"main/middleware"
	"net/http"

	"github.com/google/uuid"
)

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

	err = db.AutoMigrate(&User{})
	if err != nil {
		log.Fatalf("Error auto-migrating User table: %v", err)
	}

	add_user_endpoint := fmt.Sprintf("%s/%s", uc.this_endpoint, "add_user")
	login_endpoint := fmt.Sprintf("%s/%s", uc.this_endpoint, "login")
	get_user_ids := fmt.Sprintf("%s/%s", uc.this_endpoint, "get_user_ids")
	get_user_by_id := fmt.Sprintf("%s/%s", uc.this_endpoint, "get_user_by_id")
	delete_user_by_id := fmt.Sprintf("%s/%s", uc.this_endpoint, "delete_user_by_id")

	http.HandleFunc(add_user_endpoint, middleware.AllowedMethods(uc.AddUser, http.MethodPost))
	http.HandleFunc(login_endpoint, middleware.AllowedMethods(uc.Login, http.MethodPost))
	http.HandleFunc(get_user_ids, middleware.AllowedMethods(uc.GetUserIDs, http.MethodGet))
	http.HandleFunc(get_user_by_id, middleware.AllowedMethods(uc.GetUserByID, http.MethodGet))
	http.HandleFunc(delete_user_by_id, middleware.AllowedMethods(uc.DeleteUserByID, http.MethodDelete))

	log.Printf("User controller initialized with endpoints: \n\t%s (POST)\n\t%s (POST)\n\t%s (GET)\n\t%s (GET)\n\t%s (DELETE)",
		add_user_endpoint,
		login_endpoint,
		get_user_ids,
		get_user_by_id,
		delete_user_by_id,
	)

	return &uc
}

func (uc *UserController) AddUser(w http.ResponseWriter, r *http.Request) {
	var user User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	var count int64
	uc.client.Model(&User{}).Where("email = ?", user.Email).Count(&count)
	if count > 0 {
		http.Error(w, "User with this email already exists", http.StatusConflict)
		return
	}

	user.UserID = uuid.NewString()
	user.Password, _ = HashPassword(user.Password)

	result := uc.client.Create(&user)
	if result.Error != nil {
		http.Error(w, result.Error.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(map[string]string{"status": "User added successfully", "user_id": user.UserID})
}

func (uc *UserController) Login(w http.ResponseWriter, r *http.Request) {
	var user LoginRequest
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	var dbUser User
	result := uc.client.Where("email = ?", user.Email).First(&dbUser)
	if result.Error != nil {
		http.Error(w, "User with this email does not exist", http.StatusNotFound)
		return
	}

	if !CheckPasswordHash(user.Password, dbUser.Password) {
		http.Error(w, "Invalid password", http.StatusUnauthorized)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"user_id": dbUser.UserID})
}

func (uc *UserController) GetUserIDs(w http.ResponseWriter, r *http.Request) {
	var users []User
	var result map[string][]string = make(map[string][]string)
	result["user_ids"] = make([]string, 0)

	uc.client.Find(&users)
	for _, user := range users {
		result["user_ids"] = append(result["user_ids"], user.UserID)
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(result)
}

func (uc *UserController) GetUserByID(w http.ResponseWriter, r *http.Request) {
	var payload map[string]interface{}

	err := json.NewDecoder(r.Body).Decode(&payload)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	userID, ok := payload["user_id"].(string)
	if !ok {
		http.Error(w, "user_id is missing or not a string", http.StatusBadRequest)
		return
	}

	var user User
	result := uc.client.Where("user_id = ?", userID).First(&user)
	if result.Error != nil {
		http.Error(w, "User with this user_id does not exist", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(user)
}

func (uc *UserController) DeleteUserByID(w http.ResponseWriter, r *http.Request) {
	var payload map[string]interface{}

	err := json.NewDecoder(r.Body).Decode(&payload)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	userID, ok := payload["user_id"].(string)
	if !ok {
		http.Error(w, "user_id is missing or not a string", http.StatusBadRequest)
		return
	}

	var user User
	result := uc.client.Where("user_id = ?", userID).First(&user)
	if result.Error != nil {
		http.Error(w, "User with this user_id does not exist", http.StatusNotFound)
		return
	}

	result = uc.client.Delete(&user)
	if result.Error != nil {
		http.Error(w, result.Error.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"status": "User deleted successfully", "user_id": user.UserID})
}
