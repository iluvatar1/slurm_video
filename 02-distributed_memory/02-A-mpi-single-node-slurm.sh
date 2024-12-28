#!/bin/bash
#SBATCH --job-name=mpi_sum_single    # Name of the job
#SBATCH --partition=normal           # Partition (queue) name
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=8                   # Number of MPI processes
#SBATCH --cpus-per-task=1           # CPU cores per process
#SBATCH --mem=4G                     # Memory per node
#SBATCH --time=00:10:00             # Time limit
#SBATCH --output=%j_mpi_single.out   # Standard output file
#SBATCH --error=%j_mpi_single.err    # Standard error file

# Load required modules (modify according to your system)
module load openmpi
module load gcc

# Compile the program
mpicxx -O3 vector_sum_mpi.cpp -o vector_sum_mpi

# Print job information
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Number of MPI processes: $SLURM_NTASKS"

# Run the MPI program
srun ./vector_sum_mpi

# Print job end time
echo "Job finished at: $(date)"
