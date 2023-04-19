#!/bin/bash

# exit when any command fails
set -e

new_ver=$1

echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.23.3 ghcr.io/jingood2/nginx:$new_ver

# push new version to ghcr.io
docker push ghcr.io/jingood2/nginx:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

# Clone Github repo
git clone https://github.com/jingood2/lesson-158.git $tmp_dir

# Update image tag
sed -i '' -e "s/jingood2\/nginx:.*/jingood2\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yml

# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push origin main

# Optionally on build agents - remove folder
rm -rf $tmp_dir