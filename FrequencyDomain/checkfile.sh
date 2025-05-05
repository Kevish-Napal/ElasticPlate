#!/bin/bash
EmitterBegin=0;
EmitterEnd=7;

function WriteRunMain {

  # Write Main file
  MFILE="TempMain$1.edp"
  /bin/cat <<EOM >$MFILE
load "MUMPS"

string[int] SourceType = ["XDisplacementSource","YDisplacementSource"];
int ChooseSourceType = $2; // Choose between 0,1,2.
int EmitterBegin = $3;
int EmitterEnd = $4;
// Show Plots?
int PlotFlag = 0;
// List Of Meshes of Convergence Analysis

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
    FOLDER=Data_XDisplacementSource
  fi

  if [ $Source = 1 ]; then
    StrSource="Y"
    FOLDER=Data_YDisplacementSource
  fi

  if [ $Source = 2 ]; then
    StrSource="F"
    FOLDER=Data_FluidSource
  fi


  Job=0;
  l=0;
  while [ $Job -lt  $[$EmitterEnd +1] ]; do

    MissingFiles=0
    for x in UXR UXI UYR UYI; do

        FILE=${FOLDER}/${x}_${Job}-${Job}.dat
        if [ ! -f "$FILE" ]; then
            let MissingFiles+=1
        fi
    done

    if [ $MissingFiles -gt 0 ]; then
        let l+=1
        echo "$l - $Job $MissingFiles files missing"
        b=$Job
        e=$Job
        JobName="${StrSource}Em_${b}-${e}"
        WriteRunMain $JobName $Source $b $e
    fi
    let Job+=1
  done
done
