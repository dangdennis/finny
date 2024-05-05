package main

import (
	"context"
	"fmt"
	"net/http"

	"github.com/financialplanner/prisma/db"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humaecho"
	_ "github.com/danielgtaylor/huma/v2/formats/cbor"
	"github.com/danielgtaylor/huma/v2/humacli"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// Options for the CLI. Pass `--port` or set the `SERVICE_PORT` env var.
type Options struct {
	Port int `help:"Port to listen on" short:"p" default:"8080"`
}

// GreetingOutput represents the greeting operation response.
type GreetingOutput struct {
	Body struct {
		Message string `json:"message" example:"Hello, world!" doc:"Greeting message"`
	}
}

func main() {
	prisma := db.NewClient()
	if err := prisma.Prisma.Connect(); err != nil {
		panic(err)
	}

	defer func() {
		if err := prisma.Prisma.Disconnect(); err != nil {
			panic(err)
		}
	}()

	cli := humacli.New(func(hooks humacli.Hooks, options *Options) {
		e := echo.New()
		e.Use(middleware.Logger())
		api := humaecho.New(e, huma.DefaultConfig("My API", "1.0.0"))

		huma.Register(api, huma.Operation{
			OperationID: "get-greeting",
			Method:      http.MethodGet,
			Path:        "/greeting/{name}",
			Summary:     "Get a greeting",
			Description: "Get a greeting for a person by name.",
			Tags:        []string{"Greetings"},
		}, func(ctx context.Context, input *struct {
			Name string `path:"name" maxLength:"30" example:"world" doc:"Name to greet"`
		}) (*GreetingOutput, error) {
			resp := &GreetingOutput{}
			resp.Body.Message = fmt.Sprintf("Hello, %s!", input.Name)

			// create a post
			users, err := prisma.Users.FindMany().Exec(ctx)
			if err != nil {
				return nil, err
			}

			fmt.Println(users)

			return resp, nil
		})

		fmt.Printf("Server listening on port http://localhost:%d", options.Port)
		e.Logger.Fatal(e.Start(fmt.Sprintf("0.0.0.0:%d", options.Port)))
	})

	cli.Run()

}
