#!/bin/bash

EmitterBegin=0;
EmitterEnd=7;
NbEmitter=1;

function WriteRunMain {

  # Write Main file
  MFILE="TempMain$1.edp"
  /bin/cat <<EOM >$MFILE
load "MUMPS"

string[int] SourceType = ["XDisplacementSource","YDisplacementSource"];
int ChooseSourceType = $2; // Choose between 0,1.
int EmitterBegin = $3;
int EmitterEnd = $4;
// Show Plots?
int PlotFlag = 0;

include "Codes/Parameters.edp"
include "Codes/macro.edp"
include "Codes/Geometry.edp"
include "Codes/Sensors.edp"
include "Codes/DataGen.edp"
EOM

  # Write Script file
  SFILE="TempScript$1.sh"
  /bin/cat <<EOM >$SFILE
#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks-per-node=12
#SBATCH --time=00:05:00
#SBATCH --mem=56gb
#SBATCH --qos=normal
#SBATCH --account=ucb137_summit2
#SBATCH --partition=shas
#SBATCH --job-name=$1
#SBATCH --output=$1.out
module purge
module load singularity/3.6.4
singularity run --bind /scratch/summit freefem.sif FreeFem++ -nw $MFILE
EOM

sbatch $SFILE
}

for Source in 0 1; do

  if [ $Source = 0 ]; then
    StrSource="X"
  fi

  if [ $Source = 1 ]; then
    StrSource="Y"
  fi


  e=EmitterBegin-1
  Job=0;

  while [ $[$e + $NbEmitter] -lt $[$EmitterEnd +1] ]; do

    b=$[$e+1];
    e=$[$b + $NbEmitter - 1]
    Job=$[$Job+1];
    JobName="${StrSource}Em_${b}-${e}"
    WriteRunMain $JobName $Source $b $e
  done

  if [ $e -lt $EmitterEnd ]; then
    b=$[$e+1]
    e=$EmitterEnd
    Job=$[$Job+1];
    JobName="${StrSource}Em_${b}-${e}"
    WriteRunMain $JobName $Source $b $e
  fi
done
