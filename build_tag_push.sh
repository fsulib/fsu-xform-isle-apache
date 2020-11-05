#!/usr/bin/env bash

# Pushing to ECR. Would rather do this as individual commands.

image_target=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | cut -d / -f 3)

[[ $image_target ]] || image_target=test

echo "image_target is $image_target"

fsu_version="$(git tag | egrep '[^a-zA-Z]')"
echo "Building image..."
cd isle-apache
isle_release="$(git tag --points-at HEAD | cut -d - -f 2)"
IMAGE_TAG="${image_target}-${isle_release}.${fsu_version}"
docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
echo "Tagging image..."
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
echo "Pushing image..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
echo "Creating alternate tag..."
alt_tag="${image_target}-latest"
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:${alt_tag}
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:${alt_tag}
