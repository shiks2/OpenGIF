package main

import (
	"log"
	"net/http"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/meilisearch/meilisearch-go"
)

// Define what a GIF looks like
type GIF struct {
	ID    string   `json:"id"`
	Title string   `json:"title"`
	Tags  []string `json:"tags"`
	URL   string   `json:"url"`
}

func main() {
	// FIX: Use 'New' instead of 'NewClient' for v0.36+
	client := meilisearch.New("http://localhost:7700", meilisearch.WithAPIKey("masterKey123"))

	// Ensure the index exists
	_, err := client.GetIndex("gifs")
	if err != nil {
		_, err = client.CreateIndex(&meilisearch.IndexConfig{
			Uid:        "gifs",
			PrimaryKey: "id",
		})
		if err != nil {
			log.Println("Error creating index:", err)
		}
	}

	// Set up the API Router
	r := gin.Default()

	// Configure CORS
	r.Use(cors.New(cors.Config{
		AllowMethods:     []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Length", "Content-Type"},
		AllowCredentials: true,
		AllowOriginFunc: func(origin string) bool {
			return len(origin) >= 16 && origin[:16] == "http://localhost"
		},
	}))

	// ENDPOINT: Upload a GIF
	r.POST("/upload", func(c *gin.Context) {
		var newGIF GIF
		if err := c.ShouldBindJSON(&newGIF); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		// Save to Search Engine
		// Index("gifs") creates the index if it doesn't exist
		task, err := client.Index("gifs").AddDocuments([]GIF{newGIF}, nil)
		if err != nil {
			log.Println("Error indexing:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save"})
			return
		}

		c.JSON(http.StatusOK, gin.H{"status": "saved", "task_uid": task.TaskUID})
	})
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "Welcome to the OpenGIF API"})
	})

	// ENDPOINT: Home Feed (All GIFs)
	r.GET("/home", func(c *gin.Context) {
		// Search with empty query string returns all documents
		searchRes, err := client.Index("gifs").Search("",
			&meilisearch.SearchRequest{
				Limit: 50,
			})

		if err != nil {
			log.Println("Error fetching home feed:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch feed"})
			return
		}

		c.JSON(http.StatusOK, searchRes.Hits)
	})

	// ENDPOINT: Search GIFs
	r.GET("/search", func(c *gin.Context) {
		query := c.Query("q") // Get query from URL (e.g. ?q=cat)

		// Search in MeiliSearch
		searchRes, err := client.Index("gifs").Search(query,
			&meilisearch.SearchRequest{
				Limit: 20,
			})

		if err != nil {
			log.Println("Error searching:", err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Search failed"})
			return
		}

		c.JSON(http.StatusOK, searchRes.Hits)
	})

	// Run on port 8080
	log.Println("Server starting on http://localhost:8080")
	r.Run(":8080")
}
