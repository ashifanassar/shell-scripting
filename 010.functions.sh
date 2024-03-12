#!/bin/bash

# Four types of commands are available

# 1.Binary(/bin,/sbin)
# 2.Aliases(They are shotcuts)
# 3.Shell build in commands(cd,pwd,exit,lias)
# 4.Functions(When we need to execute some common patterns)

# How to declare the function

f()
{
    echo "This is function
}

# How to call the funtion

f   #calling the function

echo "Day 2 of Bash"

f

# How to call the function from another function

sample()
{
    echo "This is second function"
    f
}

sample

stat()
{
    echo "Todays date is $(date +%F)"
    echo "The uptime of the system :$(uptime | awk -F : '{print $NF}' | awk -F ',' '{print $1}')

}
stat

sleep 3
stat
sleep 3
stat

