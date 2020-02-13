#!/bin/bash
#git clone https://github.com/flerka/bgg-ranking-historicals

file_name= # used for function return values
new_file_name='new_file.csv'

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
   exit 1
}

main () {
    git fetch
    commits_count="$(git rev-list HEAD...origin/master --count)" 

    if [ $commits_count == 0 ]; then
        echo "Repository is up to date."
    else
        echo "New files in repository."  

        git pull
        fill_file_name 
        
        # create new csv with additional column
        awk -F"," 'FNR==1{a="bgg_id"} FNR>1{a=$8} {match(a, /\/([[:digit:]]+)\//)} {print $0","substr(a, RSTART+1, RLENGTH-2)}' $file_name > "$new_file_name"
    fi
}

main