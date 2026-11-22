#!/bin/bash
#SBATCH --job-name=min
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --hint=multithread
#SBATCH --time=05:00:00
#SBATCH -p gpu
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out

module load gromacs/2026

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
files="../mdp_files"


#Minimização 1 sem restrição
gmx_mpi grompp -f ../mdp_files/grompp_min2.mdp -c conf.gro -p top.top -maxwarn 1 -o min_none.tpr
gmx_mpi mdrun -s min_none.tpr -v -deffnm min_none -ntomp 8

#Minimização 2 com restrição
gmx_mpi grompp -f ../mdp_files/grompp_min1.mdp -n index.ndx -c min_none.gro -r min_none.gro -p top.top -maxwarn 1 -o min.tpr
gmx_mpi mdrun -s min.tpr -v -deffnm min -ntomp 8

