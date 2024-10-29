## using this approach instead of normal "git clone" as the GitLab Pipeline might put cached files inside the destination dir
function gitClone {
  local REPO="$1"
  local DEST="$2"
  local BRANCH="$3"
  echo "cloning $REPO ($BRANCH) into $DEST"

  mkdir "./$DEST" || true
  cd "./$DEST" || return 1

  # https://stackoverflow.com/a/29078055
  git init --quiet
  git remote add origin "$REPO"
  git pull --depth=1 origin $BRANCH
  git branch --set-upstream-to=origin/$BRANCH $BRANCH
  git reset --hard HEAD

  cd ..
}
