#!/bin/bash

#Giving colurs to fore ground and background
#Color	Foreground Code	Background Code
#Black	    30	            40
#Red	    31	            41
#Green	    32	            42
#Yellow	    33	            43
#Blue	    34	            44
#Magenta	35	            45
#Cyan	    36	            46

#syntax for applying the colours

#echo -e "\e[32m this is Green \e[0m"

#comments
echo -e "\e[33m this is yellow foreground \e[0m"
echo -e "\e[32m this is a colour \e[0m"

#()-Paranthesis
#[]-Square brackets
#{}-Flower brackets

#Giving foreground and background colours

echo -e "\e[44;35m this has foreground and background colour \e[0m"
echo -e "\e[42;32m this is another example of background an foregrount \e[0m"