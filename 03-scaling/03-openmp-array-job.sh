#!/bin/bash
#SBATCH --job-name=openmp_speedup    # Name of the job
#SBATCH --partition=normal           # Partition (queue) name
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=1                   # Number of tasks (processes)
#SBATCH --cpus-per-task=32          # Maximum number of CPU cores (adjust based on your system)
#SBATCH --mem=4G                     # Memory required per node
#SBATCH --time=00:10:00             # Time limit (HH:MM:SS)
#SBATCH --array=1-6                  # Array job for different thread counts: 1,2,4,8,16,32
#SBATCH --output=speedup_%A_%a.out   # Standard output file
#SBATCH --error=speedup_%A_%a.err    # Standard error file

# Load required modules (modify according to your system)
module load gcc

# Calculate number of threads for this array task
# Will run with 1,2,4,8,16,32 threads
THREADS=$((2**($SLURM_ARRAY_TASK_ID-1)))

# Make sure we don't exceed the allocated CPUs
if [ $THREADS -gt $SLURM_CPUS_PER_TASK ]; then
    THREADS=$SLURM_CPUS_PER_TASK
fi

# Set OpenMP environment variable
export OMP_NUM_THREADS=$THREADS

# Compile the program (only needed once, but keeping it here for completeness)
if [ $SLURM_ARRAY_TASK_ID -eq 1 ]; then
    g++ -fopenmp -O3 vector_sum_speedup.cpp -o vector_sum_speedup
fi

# Run the program
./vector_sum_speedup
