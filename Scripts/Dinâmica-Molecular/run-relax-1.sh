#!/bin/bash
#SBATCH --job-name=xTB
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --time=03:00:00
#SBATCH -e log/slurm-%x-%u-%j.err 
#SBATCH -o log/slurm-%x-%u-%j.out

ulimit -v unlimited
ulimit -s unlimited
 
export OMP_STACKSIZE=8G
export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
echo "CPUs alocadas: $SLURM_CPUS_PER_TASK"
echo "OMP_NUM_THREADS: $OMP_NUM_THREADS"

../xtb-dist/bin/xtb final_np.xyz --gfnff --opt --chrg 0 --alpb water > out.log


