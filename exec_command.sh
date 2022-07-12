#!/bin/bash

#try -i INTERVAL -n NUMBER COMMAND
#try -i 15 -n 10 flask app test

#Read Arguments
function arguments {
  for i in {1..2} ; do
       case $1 in
                -i)
                        shift
                        interval=$1
                        shift
                        ;;
                -n)
                        shift
                        number=$1
                        shift
                        ;;
                *)
                        echo "The command format is incurrent"
                        exit 1
                        ;;
       esac
  done
command=$*
}

# Seccess Execute
function execCommand {
  
  $* 2> /dev/null
  if [[ $? -eq 0 ]]; then
    exit 0
  fi
}

#Execute Command After Many times Then exit with 1
function tryExecuteCommand {
  for i in $(seq 1 $number) ; do
     echo "Command Not Found. try again it after ${interval} sec for ${number} times."
     sleep $interval
     execCommand $*
  done
}

#Main function to execute
function main {
  arguments $*
  execCommand ${command[*]}
  # exit 0
  tryExecuteCommand ${command[*]}
  # exit 1
  echo "executed Command Fail!" >&2
  exit 1
}

main $*
echo $?
