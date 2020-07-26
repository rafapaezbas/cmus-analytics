#!/bin/sh
# convert args into an array with every argument used when called this script. The goal is to check every argument together with the previous.
# We look for key arguments that indicates that next argument is what we are looking for. For example: if previous argument was == 'artist' we know that
# current argument is the artist name. This way there are no problems with files that misses information.
# In case that previous argument matches any of the key words, append the given information to the entry. Finally append the entry to the logger file.
args=("$@")
iterator=0
is_playing=false
is_logging=false
separator=":"
quotes="\""
entry="{"
for i in "$@"; do

    previous=$((iterator - 1))

    # cmus will notify any status change, but we are only interested on status Playing. is_playing is the flag for creating a new entry or not.
    if [[ ${args[$previous]} = "status" ]] && [[ ${args[$iterator]} = "playing" ]]
    then
        is_playing=true
    fi

    if [ ${args[$previous]} = "artist" ]
    then
        entry=$entry$quotes"artist"$quotes":"$quotes${args[$iterator]}$quotes","
        is_logging=true
    fi

    if [ ${args[$previous]} = "album" ]
    then
        entry=$entry$quotes"album"$quotes":"$quotes${args[$iterator]}$quotes","
        is_logging=true
    fi

    if [ ${args[$previous]} = "title" ]
    then
        entry=$entry$quotes"title"$quotes":"$quotes${args[$iterator]}$quotes","
        is_logging=true
    fi

    if [ ${args[$previous]} = "date" ]
    then
        entry=$entry$quotes"year"$quotes":"$quotes${args[$iterator]}$quotes","
        is_logging=true
    fi

    iterator=$((iterator + 1))
done

#add timestamp
timestamp=$(date)
entry=$entry$quotes"date"$quotes":"$quotes$timestamp$quotes","

# remove last char from entry (it is ",")
entry=${entry::-1}
# add closing bracket
entry=$entry"}"

if [[ "$is_playing" = true ]] && [[ "$is_logging" = true ]]
then
    echo $entry >> /home/cmus-logger/cmus.log
fi
