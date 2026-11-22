#!/bin/bash
#SBATCH --job-name=rg
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH -p cpu            # troque pela partição de CPU, se houver
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out

# "Flags" para controlar quais análises serão executadas
trj=1
rmsd=1
rmsf=1
sasa=1
rg=1
hb=1



n=1 #ajustar valor para a réplica
d='abpbp2_Dcys'  #ajustar nome 

# ---------- RG ----------
        if [ $rg -eq 1 ]; then
            echo 'Proteina' | gmx_mpi gyrate -f md_npt."$n".xtc -s md_npt."$n".tpr -n index_anal.ndx -o ../analises_Dcys/"$d"_rg."$n".xvg -xvg none
        fi

