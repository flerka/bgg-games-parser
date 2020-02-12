#!/bin/bash
#git clone https://github.com/flerka/bgg-ranking-historicals

get_new_file () {
    current_day="$(date +%d)"
    while [[ "$current_day" != "0" ]]
    do
        file_name="$(date +%Y)-$(date +%m)-${current_day}.csv"
        current_day=$((current_day-1))

        if [[ -f "$file_name" ]]; then
            echo "$file_name exist."
            current_day=0
        else
            echo "$file_name not exist."
        fi

        
   done
}

main () {
    git fetch
    commits_count="$(git rev-list HEAD...origin/master --count)" 

    if [ $commits_count == 0 ]; then
        echo "Repository is up to date."
    else
        echo "New files in repository."   
        git pull
    fi
}