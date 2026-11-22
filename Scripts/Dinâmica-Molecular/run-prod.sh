#!/bin/bash
#SBATCH --job-name=producao1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -p gpu
#SBATCH --cpus-per-task=8
#SBATCH --time=5-00:00:00
#SBATCH --gres=gpu:4090:1
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out

module load gromacs/2026.0

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
export CUDA_VISIBLE_DEVICES=0

prefix=$1

gmx_mpi grompp -c npt_eq.$prefix.gro -r npt_eq.$prefix.gro -f ../mdp_files/grompp_npt_run.mdp -t npt_eq.$prefix.cpt -p top.top -o md_npt.$prefix.tpr -maxwarn 1

str='mdrun -s md_npt.'"$prefix"'.tpr -v -deffnm md_npt.'"$prefix"' -pin on -nstlist 150 -nb gpu -bonded gpu -pme gpu -ntomp 8'

if [ -e "md_npt.$prefix.cpt" ]; then
    str="$str"' -cpi md_npt.'"$prefix"'.cpt -append'
    if [ -e "md_npt.$prefix"_pullf.xvg ]; then
        str="$str"' -px '"$prefix"'_pullx.xvg -pf '"$prefix"'_pullf.xvg'
    fi
fi

gmx_mpi $str

#gmx_mpi convert-tpr -s nvt_prod.tpr -o nvt_prod.tpr -until 400000
#gmx_mpi mdrun -s nvt_prod.tpr -deffnm nvt_prod -v -ntomp 8 -bonded gpu


