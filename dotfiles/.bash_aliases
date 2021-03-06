# Directory Aliases
alias dev="cd ~/workspace"
alias lendme="cd ~/workspace/lendme"
alias ps="cd ~/workspace/pluralsight"
alias red="cd ~/workspace/redsquirrel"
alias annie="cd ~/workspace/annie"

# Python related aliases
alias manage="python manage.py"
alias runserve="python manage.py runserver"
alias shell="python manage.py shell"
alias wo="workon"
alias migrate="./manage.py makemigrations && ./manage.py migrate"
alias figrate="python manage.py migrate && python manage.py upgrade"
alias venv3="mkvirtualenv --python=python3"
alias venv2="mkvirtualenv --python=python"

# Git Aliases
alias gnedit="git commit --amend --no-edit"
alias ga="git add"
alias gd="git diff"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias grs="git rebase --skip"
alias gc="git commit"
alias branch="git branch -a"
alias check="git checkout"
alias HEAD+="git push origin +HEAD"
alias HEAD="git push origin HEAD"
alias gforce="ga . && gnedit"
alias gforce+="gforce && HEAD+"
alias gst="git status"

# React-Native aliases
alias rnra="react-native run-android"
alias rnri="react-native run-ios"
alias link="react-native link"
alias rnmagic="watchman watch-del-all && rm -rf node_modules && npm i && react-native link && npm start -- --reset-cache"

# Node aliases
alias ystart="yarn start"
alias ytest="yarn test"
alias ybuild="yarn build"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"

# heroku aliases
alias HEROKU="git push heroku master"
alias HEROKU+="git push -f heroku master"

# Shell aliases
alias del="rm -rf"
alias c8000="lsof -i:8000"
alias c3000="lsof -i:3000"
alias c5000="lsof -i:5000"

# Bash aliases
alias rem="rm -rf"

# docker aliases
alias dc="docker-compose"
alias dcd="docker-compose down"
alias dcu="docker-compose up -d"