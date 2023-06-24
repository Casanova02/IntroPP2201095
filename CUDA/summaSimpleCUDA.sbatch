#!/bin/bash

##Directivas

#SBATCH --gres=gpu:1
#SBATCH --job-name=suma
#SBATCH --output=output_summaSimple.txt
#SBATCH --error=output_summaSimple.err


## Modulos de ambiente

module load devtools/cuda/8.0 

## Ejecucion

nvcc cu_summaSimple.cu -o summac
./summac 10
./summac 100
./summac 200
./summac 300
./summac 400
./summac 500
./summac 600
./summac 700
./summac 800
./summac 900
./summac 1000

