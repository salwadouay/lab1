#!/bin/bash

# === CONFIGURATION ===
APP_NAME="myapp"
DOCKER_IMAGE="myapp_image"
DOCKER_TAG="latest"
PORT=8080
GIT_REPO_DIR="/path/to/your/local/repo"  # full path to your project folder
BRANCH="main"                            # branch to watch
CHECK_INTERVAL=30                        # seconds between checks

cd "$GIT_REPO_DIR" || { echo "❌ Repo not found: $GIT_REPO_DIR"; exit 1; }

# === FUNCTION TO DEPLOY ===
deploy_container() {
    echo "🚀 New commit detected! Deploying..."
    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

    echo "🧹 Stopping and removing old container..."
    docker stop ${APP_NAME} >/dev/null 2>&1
    docker rm ${APP_NAME} >/dev/null 2>&1

    echo "🆕 Starting new container..."
    docker run -d --name ${APP_NAME} -p ${PORT}:${PORT} ${DOCKER_IMAGE}:${DOCKER_TAG}
    echo "✅ Deployment complete!"
}

# === MAIN LOOP ===
echo "👀 Monitoring branch '$BRANCH' for new commits..."
LAST_COMMIT=$(git rev-parse $BRANCH)

while true; do
    git fetch origin $BRANCH >/dev/null 2>&1
    NEW_COMMIT=$(git rev-parse origin/$BRANCH)

    if [ "$NEW_COMMIT" != "$LAST_COMMIT" ]; then
        echo "🔄 New commit detected: $NEW_COMMIT"
        git pull origin $BRANCH
        deploy_container
        LAST_COMMIT=$NEW_COMMIT
    fi

    sleep $CHECK_INTERVAL
done

