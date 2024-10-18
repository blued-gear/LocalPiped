#!/bin/bash

source env.sh

if [ "$FILE_NAME" == "" ]; then
  FILE_NAME=$(basename "$1")
fi
if [ "$PKG_TYPE" == "" ]; then
  PKG_TYPE="AppImage"
fi

URL="$GITLAB_HOST/api/v4/projects/$GITLAB_PROJECT_ID/packages/generic/$PKG_TYPE/1.0/$FILE_NAME"

echo uploading to "$URL"
curl --progress-bar -X PUT --user "$GITLAB_PUBLISH_USERNAME:$GITLAB_PUBLISH_PASSWORD" --upload-file "$1" "$URL" | cat
