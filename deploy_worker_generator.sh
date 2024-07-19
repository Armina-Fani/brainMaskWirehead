#!/bin/bash
#SBATCH --job-name=wireheadArmina
#SBATCH --nodes=1
#SBATCH -c 16
#SBATCH --mem=200g
#SBATCH --gres=gpu:A40:1
#SBATCH --output=./log/generate_output_%A_%a.log
#SBATCH --error=./log/generate_error_%A_%a.log
#SBATCH --time=10:00:00
#SBATCH -p qTRDGPU
#SBATCH -A psy53c17
#SBATCH --array=0-3%4

#the array example above starts 4 jobs simultaneously [0 to 3] with a maximum of 4 running jobs
#change based on project requirements

#Time to run each job (in seconds)
JOB_DURATION=900

#Total number of jobs to run
TOTAL_JOBS=20  # Adjust this number as needed

echo "This is a wirehead job ${SLURM_ARRAY_TASK_ID} on $(hostname)"

conda init bash
conda activate wirehead

# Function to run a single job
run_job() {
    python workerGenerator.py &
    PYTHON_PID=$!
    sleep $JOB_DURATION
    kill $PYTHON_PID
    wait $PYTHON_PID 2>/dev/null
}

# Run the current job
run_job

# If there are more jobs in the queue, submit the next one
NEXT_JOB=$((SLURM_ARRAY_TASK_ID + 4))
if [ $NEXT_JOB -lt $TOTAL_JOBS ]; then
    sbatch --array=$NEXT_JOB ${BASH_SOURCE[0]}
fi
