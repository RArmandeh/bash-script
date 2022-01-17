#!/bin/bash

#try -i INTERVAL -n NUMBER COMMAND
#try -i 15 -n 10 flask app test

interval=5
number=12
command=NULL

# Read Arguments From Environment Variable
function args_EnvVar {
    if [[ -v TRY_INTERVAL ]]; then
        interval="${TRY_INTERVAL}"
    fi
    if [[ -v TRY_NUMBER ]]; then
        number="${TRY_NUMBER}";
    fi
    if [[ -v TRY_COMMAND ]]; then
      command="${TRY_COMMAND}"
    fi
}

# Read Arguments From Command Line
function args_CLI {
  if [[ $* == *"-n"* || $* == *"-i"* ]]; then
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
        esac
    done
  fi
  command=$*
}

# Read Argument
function arguments {
  # Read From ENV
  args_EnvVar

  # Read From CLI
  args_CLI $*

  if [[ -z $command || $command == NULL ]]; then
    echo "Command is null!" >&2
    exit 2
  fi
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