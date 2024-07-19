#!/bin/bash

#SBATCH --job-name=wireheadArmina
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --mem=50g
#SBATCH --gres=gpu:A40:1
#SBATCH --output=./log/generate_output_%A_%a.log
#SBATCH --error=./log/generate_error_%A_%a.log
#SBATCH --time=10:00:00
#SBATCH -p qTRDGPU
#SBATCH -A psy53c17

echo "This is a wirehead job on $(hostname)"

conda init bash
conda activate wirehead

python workerManager.py
