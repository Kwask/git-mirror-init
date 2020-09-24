# git-mirror-init

This script will initialize a new git repo, then creates empty repositories on
github and gitlab using the given name, then sets both as the push destination.

## Usage

Create a `config.json` file in the same folder as `git-mirror-init.sh` with the
following format:

``` json
{
    "tokens": {
        "github": "YOUR_GITHUB_API_TOKEN",
        "gitlab": "YOUR_GITLAB_API_TOKEN"
    }
}
```

After that you can use the script:

`git-init-mirror test`

This will create a repo on github and gitlab named "test" and sets up push and
pull configuration so that gitlab is the primary.
