#!/bin/bash
fftz=`ps -Al | grep 'matrix' | wc -l`
total=0
let total=$fftz
max_runs=6

if [ "$total" -ge "$max_runs" ]
then
  echo "$total SniperSim instances already running.. Please try again in a couple of minutes"
else
  echo "Running SniperSim... Please hold a bit..."
  USERID=$(logname)
  export SNIPER_ROOT=/home/$USERID/sniper-6.1
  export BENCHMARKS_ROOT=/home/$USERID/benchmarks

  # Change here the name of the executable !!!!
  SCRIPT=checker
  
  # your utils
  ENERGY_VIZ=$SNIPER_ROOT/tools/mcpat.py
  CURRENT_DIR=$(pwd)
  
  # Output location
  OUTPUT_NAME=sim_results_${SCRIPT}
  OUTPUT_DIR=$(pwd)/${OUTPUT_NAME}
  rm -r ${OUTPUT_DIR}
  OUTPUT_FILE=${OUTPUT_DIR}/sim.out
  
  $SNIPER_ROOT/run-sniper -c $(pwd)/sniper-config/gainestown.cfg -d $OUTPUT_DIR -- $(pwd)/${SCRIPT} --power
  
  cd ${OUTPUT_DIR}
  $SNIPER_ROOT/tools/mcpat.py
  cd $CURRENT_DIR

fi

