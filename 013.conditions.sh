#!\bin\bash

# Conditions to be executed with case

# Syntax:
# case $var in
# opt 1 commands x;;
# opt 2 commands y;;
# esac

ACTION=$1

case $ACTION in start)
echo "Starting the service"
exit 0
;;
stop)
echo "stopping the service"
exit 1
;;
restart)
echo "resstarting the service"
exit 2
;;
*)
echo "None of the options"
exit 3
;;
esac
