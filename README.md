# OpenGIF: Distributed Search Engine Architecture

OpenGIF is a high-performance, open-source search engine designed for the efficient indexing and retrieval of animated media. It utilizes a decoupled client-server architecture to ensure scalability, utilizing Go for high-concurrency backend processing and MeiliSearch for typo-tolerant, sub-50ms search queries.

This repository contains the complete source code for both the server-side infrastructure and the client-side mobile application.

## System Architecture

The system follows a three-tier architecture pattern:

1.  **Presentation Layer (Client):** A reactive mobile application built with Flutter, utilizing Riverpod for state management and Dio for optimized network requests.
2.  **Application Layer (Server):** A RESTful API built with Go (Gin framework), responsible for request routing, validation, file processing, and business logic.
3.  **Data Layer (Storage & Search):** A Dockerized MeiliSearch instance for inverted-index search capabilities, coupled with local or cloud-based object storage for media assets.

## Technology Stack

### Backend
* **Language:** Go (Golang) 1.21+
* **Framework:** Gin (HTTP Web Framework)
* **Search Engine:** MeiliSearch
* **Containerization:** Docker & Docker Compose
* **Utilities:** Google UUID (Identity generation)

### Frontend
* **Framework:** Flutter (Dart)
* **State Management:** Riverpod
* **Networking:** Dio
* **Routing:** GoRouter
* **Form Handling:** Flutter Form Builder

## Prerequisites

Ensure the following tools are installed on your local development environment:

* **Go:** Version 1.21 or higher
* **Flutter SDK:** Latest Stable Channel
* **Docker Desktop:** Running and configured for Linux containers
* **Make** (Optional, for build automation)

## Installation and Execution Guide

### 1. Infrastructure Setup
The database infrastructure is containerized to ensure consistency across environments. Navigate to the backend directory and initialize the services.

```bash
cd backend
docker compose up -d

```
### 2. Backend Initialization
```
# Install dependencies
go mod tidy

# Seed the database with initial data (Optional)
go run seed.go

# Start the server
go run main.go
```
# The API will be accessible at http://localhost:8080

### 3. Client Application Launch
The client application is located in the frontend directory. Ensure your Android Emulator or iOS Simulator is running before executing the application.

Note for Android Emulators: The application is configured to communicate with 10.0.2.2 to access the host machine's localhost.
```
cd frontend

# Install dependencies
flutter pub get

# Run the application with the base URL configuration
flutter run --dart-define=BASE_URL=[http://10.0.2.2:8080](http://10.0.2.2:8080)
```
### API Reference
Health Check
GET /

Returns a status message confirming the API is operational.

Search
GET /search?q={query}

Description: Retrieves a list of GIFs matching the search query.

Parameters: q (string) - The keyword to search for.

Response: JSON array of GIF objects.

Upload Media
POST /upload

Description: Uploads a new media file and indexes its metadata.

Body (Multipart/Form-Data):

file: The binary image data.

title: The display title of the image.

tags: Comma-separated strings for search indexing.

### Project Structure
The repository is organized as a monorepo:

/backend: Contains the Go source code, Docker configuration, and data seeding scripts.

/frontend: Contains the complete Flutter project source code.

###  License
This project is open-source and available under the MIT License.
