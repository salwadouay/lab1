#!/bin/bash

# === CONFIGURATION ===
APP_NAME="myapp"
DOCKER_IMAGE="myapp_image"
DOCKER_TAG="latest"
WATCH_DIR="./"  # directory to monitor (e.g., your app folder)
PORT=8080        # exposed container port

# === FUNCTION TO DEPLOY ===
deploy_container() {
    echo "🚀 Rebuilding Docker image..."
    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

    echo "🧹 Stopping and removing old container (if exists)..."
    docker stop ${APP_NAME} >/dev/null 2>&1
    docker rm ${APP_NAME} >/dev/null 2>&1

    echo "🆕 Starting new container..."
    docker run -d --name ${APP_NAME} -p ${PORT}:${PORT} ${DOCKER_IMAGE}:${DOCKER_TAG}

    echo "✅ Deployment complete! Container '${APP_NAME}' is running on port ${PORT}."
}

# === MONITOR FILE CHANGES ===
echo "👀 Watching for changes in '${WATCH_DIR}'..."
echo "Press [CTRL+C] to stop."

# Make sure inotifywait is installed
if ! command -v inotifywait &> /dev/null; then
    echo "❌ Error: inotify-tools is not installed."
    echo "Install it with: sudo apt install inotify-tools"
    exit 1
fi

# Initial build
deploy_container

# Watch for file changes
while true; do
    inotifywait -r -e modify,create,delete,move ${WATCH_DIR}
    echo "🔄 Change detected! Redeploying..."
    deploy_container
done
