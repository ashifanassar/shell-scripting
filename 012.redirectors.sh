#!/bin/bash

# Redirectors

# To take the input,to handle the output and to handle the errors

# Redirectors 2 types
# 1.Input redirector (<)  (EX: sudo mysql<)
# 2.output redirector (>> or >)

# Outputs are handled as below
# 1. standard output 1> or >>(Append) >(add output to the file)
# 2. Standard error  2> or 2>>(append) >(add error to the file)
# 3. Standard output and error  &> or &>> 

# ls -ltr > output.txt #redirect output to output.txt
# ls -ltr >> output.txt #redirects and appends to output.txt
# ls -ltr 2> output.txt #redirects error to output.txt
# ls -ltr 2>> output.txt #redirects error and append to exiting output.txt
# ls -ltr &> output.txt #redirects error and information to output.txt
# ls -ltr &>> output.txt #redirects and appends the info and error to output.txt