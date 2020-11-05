#!/usr/bin/env bash

# Pushing to ECR. Would rather do this as individual commands.

IMAGE_TAG=$(echo $CODEBUILD_WEBHOOK_HEAD_REF | cut -d / -f 3)

[[ $IMAGE_TAG ]] || IMAGE_TAG=test

echo "IMAGE_TAG is $IMAGE_TAG"

fsu_commit="fsu-commit-$(git log --oneline | head -1 | cut -f 1 -d ' ')"
echo "Building image..."
cd isle-apache
isle_release="$(git tag --points-at HEAD)"
docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
echo "Tagging image..."
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
echo "Pushing image..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
echo "Adding tags..."
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$isle_release
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$isle_release
docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$fsu_commit
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$fsu_commit

