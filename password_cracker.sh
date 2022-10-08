#!/bin/bash

while getopts ":w:h:p:" opt; do
    case $opt in
        w) wordlist=${OPTARG}
        ;;
        h) hash_function=${OPTARG}
        ;;
        p) hashed_password=${OPTARG}
        ;;
    esac 
done

function brut_force {
  echo "Processing..."
  while read word;
  do
    case "$hash_function" in
      md5|MD5) 
        hashed_word=`echo -n "$word" | openssl md5 | cut -d " " -f 2`
      ;;
      sha1|SHA1) 
        hashed_word=`echo -n "$word" | openssl sha1 | cut -d " " -f 2`
      ;;
      sha256|SHA256)
        hashed_word=`echo -n "$word" | openssl sha256 | cut -d " " -f 2`
      ;;
      *) echo "You provided a non supported hash function."
      ;;
    esac
    if [[ "$hashed_word" = "$hashed_password" ]]; then
     echo "Cracked !!! Password is $word" 
     break 2
    fi
  done < $wordlist;
}

rows="%-20s| %-55s\n"

printf "$rows" "Hashed password" "$hashed_password"
printf "$rows" "Hash function" "$hash_function"
printf "$rows" "Wordlist" "$wordlist"
len=`wc -l $wordlist | cut -d " " -f 1`
printf "$rows" "Length" "$len"

echo ""

read -p "Do you want to continue ? [Y|n] " choice
case "$choice" in
  y|Y) brut_force
  ;;
esac

echo "Exiting..."
