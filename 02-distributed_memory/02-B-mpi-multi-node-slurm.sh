#!/bin/bash
#SBATCH --job-name=mpi_sum_multi     # Name of the job
#SBATCH --partition=normal           # Partition (queue) name
#SBATCH --nodes=2                    # Number of nodes
#SBATCH --ntasks-per-node=4         # MPI processes per node
#SBATCH --cpus-per-task=1           # CPU cores per process
#SBATCH --mem-per-cpu=1G            # Memory per CPU
#SBATCH --time=00:10:00             # Time limit
#SBATCH --output=%j_mpi_multi.out    # Standard output file
#SBATCH --error=%j_mpi_multi.err     # Standard error file

# Load required modules (modify according to your system)
module load openmpi
module load gcc

# Compile the program
mpicxx -O3 vector_sum_mpi.cpp -o vector_sum_mpi

# Print job information
echo "Job started at: $(date)"
echo "Running on nodes:"
scontrol show hostname $SLURM_JOB_NODELIST
echo "Total number of MPI processes: $SLURM_NTASKS"

# Run the MPI program
srun ./vector_sum_mpi

# Print job end time
echo "Job finished at: $(date)"
