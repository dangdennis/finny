package supabaseclient

import (
	"fmt"

	"github.com/supabase-community/supabase-go"
)

func NewSupabase(apiURL string, apiKey string) (*supabase.Client, error) {
	client, err := supabase.NewClient(apiURL, apiKey, &supabase.ClientOptions{})
	if err != nil {
		fmt.Println("cannot initalize client", err)
	}

	return client, err
}

func NewTestSupabase() (*supabase.Client, error) {
	return NewSupabase("http://127.0.0.1:54321", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU")
}
