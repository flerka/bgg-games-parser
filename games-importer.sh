#!/bin/bash

if [[ -z "${MONGO_HOST}" ]]; then
    MONGO_HOST="localhost:27017"
fi

if [[ -z "${MONGO_USER}" ]]; then
    MONGO_USER=""
fi

if [[ -z "${MONGO_PWD}" ]]; then
    MONGO_PWD=""
fi

file_name= # used for function return value
fill_file_name () {
    current_day="$(date +%d)"
    while [[ "$current_day" != "0" ]]
    do
        day=$(printf %02d $current_day)
        file_name="$(date +%Y)-$(date +%m)-${day}.csv"
        current_day=$((current_day-1))

        if [[ -f "$file_name" ]]; then
            echo "$file_name exist."
            file_name=$file_name
            return;
        else
            echo "$file_name not exist."
        fi 
   done
   
   echo "there is no file with games"  
}

main () {
    cd /repo

    if [! "$(ls -A)" ]; then
        # clone in current directory
        git clone https://github.com/flerka/bgg-ranking-historicals .
    else
        git fetch
        commits_count="$(git rev-list HEAD...origin/master --count)" 

        if [ $commits_count == 0 ]; then
            echo "Repository is up to date."
            return;
        
        git pull
    fi

    # get name of the file that contains latest changes
    fill_file_name 

    # import data from to the file to mongodb
    mongoimport -d BgGames -c games --type csv --host $MONGO_HOST --username MONGO_USER --password MONGO_PWD --file $file_name --headerline
    fi
}

main

exit 1