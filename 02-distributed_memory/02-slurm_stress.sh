#!/bin/bash
#SBATCH --job-name=mpi_sum_single    # Name of the job
#SBATCH --clusters=fisica            # Partition (queue) name
#SBATCH --partition=cpu.cecc         # Partition (queue) name
#SBATCH --nodes=1                    # Number of nodes
#SBATCH --ntasks=4                   # Number of MPI processes
#SBATCH --cpus-per-task=2            # CPU cores per process
#SBATCH --mem=14G                    # Memory per node
#SBATCH --time=00:10:00              # Time limit
#SBATCH --output=%j_%x.out           # Standard output file
#SBATCH --error=%j_%x.err            # Standard error file

# Load required modules (modify according to your system)
#module load openmpi
#module load gcc

# Print job information
echo "Job started at: $(date)"
echo "Running on node: $(hostname)"
echo "Number of MPI processes: $SLURM_NTASKS"

# Run the MPI program
srun --mpi=pmix_v4 ./cpu_stress.sh $SLURM_CPUS_PER_TASK 10

# Print job end time
echo "Job finished at: $(date)"
