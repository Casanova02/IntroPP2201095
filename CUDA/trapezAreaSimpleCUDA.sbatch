#!/bin/bash
#SBATCH --job-name=trapecioCUDA
#SBATCH --gres=gpu:1
#SBATCH --output=output_trapecioCUDA.txt
#SBATCH --error=error_trapecioCUDA.txt
module purge
module load devtools/cuda/8.0
hostname
nvcc trapezAreaSimpleCUDA.cu -o trapezAreaSimpleCUDA
time ./trapezAreaSimpleCUDA 10 1 100
time ./trapezAreaSimpleCUDA 100 1 100
time ./trapezAreaSimpleCUDA 200 1 100
time ./trapezAreaSimpleCUDA 300 1 100
time ./trapezAreaSimpleCUDA 400 1 100
time ./trapezAreaSimpleCUDA 500 1 100
time ./trapezAreaSimpleCUDA 600 1 100
time ./trapezAreaSimpleCUDA 700 1 100
time ./trapezAreaSimpleCUDA 800 1 100
time ./trapezAreaSimpleCUDA 1000 1 100
