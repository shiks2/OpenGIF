package main

import (
	"fmt"
	"log"
	"time"

	"github.com/meilisearch/meilisearch-go"
)

// The Data Shape
type GIF struct {
	ID    string   `json:"id"`
	Title string   `json:"title"`
	Tags  []string `json:"tags"`
	URL   string   `json:"url"`
}

func main() {
	fmt.Println("🚀 Starting Data Seeder...")

	// 1. Connect to MeiliSearch
	client := meilisearch.New("http://localhost:7700", meilisearch.WithAPIKey("masterKey123"))

	// 2. Define the Dummy Data (The "Gas" for your Engine)
	gifs := []GIF{
		{
			ID:    "1",
			Title: "Vibing Cat",
			Tags:  []string{"cat", "vibe", "music", "meme", "funny"},
			URL:   "https://media.giphy.com/media/GeimqsH0TLDt4tScGw/giphy.gif",
		},
		{
			ID:    "2",
			Title: "Success Kid",
			Tags:  []string{"success", "win", "baby", "yes", "meme"},
			URL:   "https://media.giphy.com/media/nXxOjZrbnbRxS/giphy.gif",
		},
		{
			ID:    "3",
			Title: "Confused Math Lady",
			Tags:  []string{"confused", "math", "thinking", "meme", "calculating"},
			URL:   "https://media.giphy.com/media/WRQBXSCnEFJIvxlmgy/giphy.gif",
		},
		{
			ID:    "4",
			Title: "This is Fine Dog",
			Tags:  []string{"fire", "dog", "fine", "okay", "disaster"},
			URL:   "https://media.giphy.com/media/NTur7XlVDUdqM/giphy.gif",
		},
		{
			ID:    "5",
			Title: "Office No God No",
			Tags:  []string{"office", "michael", "scott", "no", "scream"},
			URL:   "https://media.giphy.com/media/8vUEXZA2uZ7d2/giphy.gif",
		},
		{
			ID:    "6",
			Title: "Leonardo DiCaprio Toast",
			Tags:  []string{"cheers", "gatsby", "drink", "congrats", "leonardo"},
			URL:   "https://media.giphy.com/media/BPJmthQ3YRwD6QqcVD/giphy.gif",
		},
		{
			ID:    "7",
			Title: "Sad Pablo Escobar",
			Tags:  []string{"waiting", "sad", "alone", "narcos", "meme"},
			URL:   "https://media.giphy.com/media/jUwpNzg9IcyrK/giphy.gif",
		},
		{
			ID:    "8",
			Title: "Homer Simpson Bush",
			Tags:  []string{"hiding", "simpsons", "bush", "bye", "awkward"},
			URL:   "https://media.giphy.com/media/COYGe9rZvfiaQ/giphy.gif",
		},
		{
			ID:    "9",
			Title: "Futurama Take My Money",
			Tags:  []string{"money", "fry", "futurama", "buy", "want"},
			URL:   "https://media.giphy.com/media/sDcfxFDozb3bO/giphy.gif",
		},
		{
			ID:    "10",
			Title: "Coding Hackerman",
			Tags:  []string{"code", "hack", "computer", "typing", "fast"},
			URL:   "https://media.giphy.com/media/13HgwGsXF0aiGY/giphy.gif",
		},
		{
			ID:    "11",
			Title: "Minions Cheering",
			Tags:  []string{"happy", "minion", "yay", "celebrate"},
			URL:   "https://media.giphy.com/media/11sBLVxNs7v6WA/giphy.gif",
		},
		{
			ID:    "12",
			Title: "Elmo Fire",
			Tags:  []string{"chaos", "fire", "elmo", "burn", "hell"},
			URL:   "https://media.giphy.com/media/P7JmDW7IkB7TW/giphy.gif",
		},
		{
			ID:    "13",
			Title: "Spongebob Mocking",
			Tags:  []string{"mocking", "spongebob", "chicken", "sarcasm", "meme"},
			URL:   "https://media.giphy.com/media/QUXYcgCxuqCmI/giphy.gif",
		},
		{
			ID:    "14",
			Title: "Drake Hotline Bling No",
			Tags:  []string{"drake", "no", "reject", "nah", "meme"},
			URL:   "https://media.giphy.com/media/26tP3M3iA3mMB40MHq/giphy.gif",
		},
		{
			ID:    "15",
			Title: "Drake Hotline Bling Yes",
			Tags:  []string{"drake", "yes", "approve", "point", "meme"},
			URL:   "https://media.giphy.com/media/3o7TKMeCOV3oXSb5bq/giphy.gif",
		},
	}

	// 3. Batch Upload to MeiliSearch
	// MeiliSearch handles batches very well. We send all 15 at once.
	task, err := client.Index("gifs").AddDocuments(gifs, nil)
	if err != nil {
		log.Fatal("❌ Failed to seed data: ", err)
	}

	fmt.Printf("✅ Sent %d GIFs to the engine.\n", len(gifs))
	fmt.Printf("⏳ Task ID: %d (Processing...)\n", task.TaskUID)

	// 4. Wait a moment for indexing to finish
	time.Sleep(2 * time.Second)
	fmt.Println("🎉 Database Seeded! You can now search for 'cat', 'office', or 'drake'.")
}