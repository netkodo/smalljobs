GIT_BRANCH = `git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`
GIT_COMMIT = `git log --pretty=format:'%h' -n 1`
