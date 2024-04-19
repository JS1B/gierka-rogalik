# Rogalik Game Server
=======================================

A simple GoLang server that implements user interaction, meaning user creation and login as well as ability to store game state data.

## Usage 

```
go run .
```

## Files and folders

* **config** - module that ensures that .env files are loaded and exports a Go struct for every module to be able to load it
* **controllers** - modules that create specific endpoints of the server such as /user or /map and implement the logic for database interactions
* **middleware** - endpoint guards that ensure the right calls are made. Could be expanded for more control over the endpoint inputs and outputs
* **Dockerfile** - for containerization purposes
* **main.go** - main entrypoint of the app