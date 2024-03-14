package map_controller

import (
	"context"
	"fmt"
	"log"
	"main/config"
	"main/middleware"
	"net/http"
	"time"

	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type MapController struct {
	parent_endpoint string
	this_endpoint   string
	config          config.Config
	client          *mongo.Client
}

func NewMapController(parent_endpoint string, config config.Config) *MapController {
	mp := MapController{
		parent_endpoint: parent_endpoint,
		this_endpoint:   fmt.Sprintf("%s/%s", parent_endpoint, "map"),
		config:          config,
	}

	client, err := connectToMongoDB(config)
	if err != nil {
		log.Fatal(err)
	}
	mp.client = client

	write_map_state := fmt.Sprintf("%s/%s", mp.this_endpoint, "write_map_state")
	get_map_state := fmt.Sprintf("%s/%s", mp.this_endpoint, "get_map_state")

	http.HandleFunc(write_map_state, middleware.AllowedMethods(mp.WriteMapState, http.MethodPost))
	http.HandleFunc(get_map_state, middleware.AllowedMethods(mp.GetMapState, http.MethodGet))

	log.Printf("Map controller initialized with endpoints: \n\t%s (POST)\n\t%s (GET)\n", write_map_state, get_map_state)

	return &mp
}

func connectToMongoDB(cfg config.Config) (*mongo.Client, error) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()

	mongoURI := fmt.Sprintf("mongodb://%s:%s", cfg.MongoHost, cfg.MongoPort)
	clientOptions := options.Client().ApplyURI(mongoURI)
	client, err := mongo.Connect(ctx, clientOptions)
	if err != nil {
		return nil, fmt.Errorf("error connecting to MongoDB: %w", err)
	}

	err = client.Ping(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("error pinging MongoDB: %w", err)
	}

	log.Printf("Connected to MongoDB on %s", mongoURI)
	return client, nil
}

func (mp *MapController) WriteMapState(w http.ResponseWriter, r *http.Request) {
	_ = r
	fmt.Fprintf(w, "Write map state successfully")
}

func (mp *MapController) GetMapState(w http.ResponseWriter, r *http.Request) {
	_ = r
	fmt.Fprintf(w, "Got map state successfully")
}
