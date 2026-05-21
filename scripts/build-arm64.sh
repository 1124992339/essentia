#!/bin/bash
# Build and push ARM64 Essentia image + update multi-arch manifest
# Run this on your Apple Silicon Mac

set -e

IMAGE="ghcr.io/1124992339/essentia"

echo "==> Building ARM64 image natively..."
docker build --platform linux/arm64 -t ${IMAGE}:latest-arm64 .

echo "==> Pushing ARM64 image..."
docker push ${IMAGE}:latest-arm64

echo "==> Creating multi-arch manifest..."
docker buildx imagetools create -t ${IMAGE}:latest \
  ${IMAGE}:latest-amd64 \
  ${IMAGE}:latest-arm64

echo "==> Done! Pull with: docker pull ${IMAGE}:latest"
