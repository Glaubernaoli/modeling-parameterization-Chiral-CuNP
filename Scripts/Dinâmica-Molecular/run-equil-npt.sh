%configurações para rodar nas GPUs do HPC disponível na faculdade Ilum(CNPEM)
#!/bin/bash
#SBATCH --job-name=eq1
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -p gpu
#SBATCH --cpus-per-task=8
#SBATCH --time=20:00:00
#SBATCH --gres=gpu:4090:1
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out

module load gromacs/2026.0

export OMP_NUM_THREADS="${SLURM_CPUS_PER_TASK}"
export CUDA_VISIBLE_DEVICES=0

prefix=$1

% pré-processamento: gerar arquivo de entrada, com a restrição (região de ancoragem)
gmx_mpi grompp -c heat.$prefix.gro -r heat.$prefix.gro -f ../mdp_files/grompp_npt_eq.mdp -t heat.$prefix.cpt -p top.top -o npt_eq.$prefix.tpr -maxwarn 1

% linha de execução da produção da simulação
str='mdrun -s npt_eq.'"$prefix"'.tpr -v -deffnm npt_eq.'"$prefix"' -pin on -nstlist 150 -nb gpu -bonded gpu -pme gpu -ntomp 8'

% execução a partir do checkpoint (se necessário)
if [ -e "eq.$prefix.cpt" ]; then
    str="$str"' -cpi '"$prefix"'.cpt -append'
    if [ -e "eq.$prefix"_pullf.xvg ]; then
        str="$str"' -px '"$prefix"'_pullx.xvg -pf '"$prefix"'_pullf.xvg'
    fi
fi

% execução
gmx_mpi $str
