if [ $# -eq 0 ]
  then
    echo "Please select one or more files!"
    exit 1;
fi

for i in $*
do
  echo "--" $i "--"

  if !(ghdl -s $i) #Syntax -Checking
    then
      exit 1;
  fi
  echo "Syntax-check OK"

  if !(ghdl -a $i) #Analysis-Checking
    then
      exit 1;
  fi
  echo "Analysis OK"

  #Getting all Entities of current File
  result=$(grep 'entity[[:blank:]]*.*is' $i)
  result="${result//entity }"
  result="${result// is}"

  #Iterate each entity
  for val in $result
  do
    echo "-"$val"-"

    if !(ghdl -e $val) #Build-Checking
      then
        exit 1;
    fi
    echo "Build OK"

    if !(ghdl -r $val --vcd=$val".vcd") #VCD-Dump-Checking
      then
        exit 1;
    fi
    echo "VCD-Dump OK"

    echo "Starting GTKWave"
    gtkwave $val".vcd" & #Starting GTKWave-Checking

  done
done

exit 0;
