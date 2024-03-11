#!\bin\bash

#Special variables has predefined powers we cannot create new special variables

# $0 -Print script we are running
# $# -Prints the arguments that are used in the script
# $? Prints the exit code of the previous command
# $* Prints all the arguments of user
# $@ Prints the arguments user
# we can supply upto 9 arguments

a=1000
TEAM=$1
echo "the value of $a"
echo "the value of $0"
