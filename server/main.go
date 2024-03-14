package main

import (
	"fmt"
	"log"
	"main/config"
	"main/controllers/map_controller"
	"main/controllers/user_controller"
	"net/http"
)

func main() {
	log.SetFlags(log.Ldate | log.Ltime | log.Lshortfile)

	cfg := config.NewConfig()
	user_controller.NewUserController("", cfg)
	map_controller.NewMapController("", cfg)

	log.Printf("Initialization complete, listening on port %s", cfg.ServerPort)
	http.ListenAndServe(fmt.Sprintf(":%s", cfg.ServerPort), nil)
}
