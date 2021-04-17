#gitScript.sh
echo "-------- STARTING COMMIT --------"
CURRENTDIR=${pwd}
USERNAME="<user-name>"

### Enter the name of the repo - ALLOWED: single word or hyphenated word
echo "NAME of the remote repository?" | sed 's/^/  /'
read REPO_NAME
### Absolute path to the local project folder path
echo "Absolute path to the local project directory?" | sed 's/^/  /'
read PROJECT_PATH
cd "$PROJECT_PATH"

git remote set-url origin https://github.com/${USERNAME}/${REPO_NAME}.git

### Initialise the repo locally, Create README, Add and Commit
git init
git rev-list --all --count
count=$(git rev-list --count HEAD)
touch README.MD
git add .
if [ "$count" -ne 0 ];
then
	git commit -m "Commit # ${count}"
else
	git commit -m "initial commit -setup with .sh script"
fi

### /user/repos endpoint
curl -H "Authorization: token <personal-access-token>" -u ${USERNAME} https://api.github.com/user/repos -d "{\"name\": \"${REPO_NAME}\", \"description\": \"${REPO_NAME}\"}"

### Add remote repo to local repo and push
#git remote rm origin
#git remote rm upstream
git remote add origin https://github.com/${USERNAME}/${REPO_NAME}.git
git push --set-upstream origin master
git pull
git merge

cd "$PROJECT_PATH"
echo "Synched Repo. Verify https://github.com/$USERNAME/$REPO_NAME " 
