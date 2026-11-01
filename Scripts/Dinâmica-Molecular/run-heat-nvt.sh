%configurações para rodar nas GPUs do HPC disponível na faculdade Ilum(CNPEM)
#!/bin/bash
#SBATCH --job-name=heat_2
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -p gpu
#SBATCH --cpus-per-task=8
#SBATCH --time=05:00:00
#SBATCH --gres=gpu:4090:1
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out

module load gromacs/2026.0

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

prefix=$1

% pré-processamento: gerar arquivo de entrada, com a restrição (região de ancoragem)
gmx_mpi grompp -c min.gro -r min.gro -f ../mdp_files/grompp_heat.mdp -p top.top -o heat.$prefix -maxwarn 

% linha de execução da produção da simulação
str='mdrun -s heat.'"$prefix"'.tpr -v -deffnm heat.'"$prefix"' -pin on -nstlist 150 -nb gpu -bonded gpu -pme gpu -ntomp 8'

% execução a partir do checkpoint (se necessário)
if [ -e "eq.$prefix.cpt" ]; then
    str="$str"' -cpi '"$prefix"'.cpt -append'
    if [ -e "eq.$prefix"_pullf.xvg ]; then
        str="$str"' -px '"$prefix"'_pullx.xvg -pf '"$prefix"'_pullf.xvg'
    fi
fi
% execução
gmx_mpi $str


