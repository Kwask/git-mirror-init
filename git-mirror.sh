#!/bin/bash

# adapted from diehard https://coderwall.com/p/r7yh6g/create-a-new-gitlab-repo-from-the-command-line
create_gitlab_repo () {
    repo=$1
    token=$2 
    
    response=$(curl -H 'Content-Type:application/json' \
        https://gitlab.com/api/v4/projects?private_token=$token -d \
        "{\"name\":\"$repo\"}")

    echo $response | jq > 'gitlab_resp.json'
    echo $response | jq -r ".ssh_url_to_repo"
}

# adapted from pdemagnet https://coderwall.com/p/mnwcog/create-new-github-repo-from-command-line
create_github_repo () {
    repo=$1
    token=$2
    
    response=$(curl -H "Authorization: token $token" \
        https://api.github.com/user/repos -d \
        "{\"name\":\"$repo\"}")

    echo $response | jq > "github_resp.json"
    echo $response | jq -r ".ssh_url"
}

repo=$1
config="./config.json"

test -z $repo && echo "Repo name required." 1>&2 && exit 1

github_token=$(jq -r ".tokens.github" $config) 
gitlab_token=$(jq -r ".tokens.gitlab" $config) 

url_gl=$(create_gitlab_repo $repo $gitlab_token)
url_gh=$(create_github_repo $repo $github_token) 

if [ -z "$url_gl" ] || [ $url_gl == "null" ]; then
    echo "Could not create gitlab repo"
elif [ -z "$url_gh" ] || [ $url_gh == "null" ]; then
    echo "Could not create github repo"
else
    git init
    git remote add origin $url_gl
    git remote set-url --add --push origin $url_gh
fi

