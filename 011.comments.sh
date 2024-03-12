#!\bin\bash

#this is the single line comment

#Multi line comments should be denoted as below

echo "Printing the multiline comment"

<<COMMENT

a=10
b=24

echo "The value" $a
COMMENT

echo value of b is $b