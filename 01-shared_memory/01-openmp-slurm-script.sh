#!/bin/bash
#SBATCH --job-name=openmp_sum       # Name of the job
#SBATCH --partition=normal          # Partition (queue) name
#SBATCH --nodes=1                   # Number of nodes
#SBATCH --ntasks=1                  # Number of tasks (processes)
#SBATCH --cpus-per-task=8          # Number of CPU cores per task (this will be number of OpenMP threads)
#SBATCH --mem=4G                    # Memory required per node
#SBATCH --time=00:10:00            # Time limit (HH:MM:SS)
#SBATCH --output=%j_openmp_sum.out  # Standard output file
#SBATCH --error=%j_openmp_sum.err   # Standard error file

# Load required modules (modify according to your system)
module load gcc

# Set OpenMP environment variable to specify number of threads
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Compile the program
g++ -fopenmp -O3 vector_sum.cpp -o vector_sum

# Print some information about the job
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Number of OpenMP threads: $OMP_NUM_THREADS"

# Run the program
./vector_sum

# Print job end time
echo "Job finished at: $(date)"
