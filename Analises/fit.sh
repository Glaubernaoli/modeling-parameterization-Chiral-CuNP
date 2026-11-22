#!/bin/bash
#SBATCH --job-name=fit
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=4G
#SBATCH -p cpu            # troque pela partição de CPU, se houver
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out


n=1

# 1) Moléculas inteiras
echo System | gmx_mpi trjconv -f md_npt."$n".xtc -s md_npt."$n".tpr \
 -pbc whole -o whole."$n".xtc

# 2) Proteína + NP num único aglomerado, frame a frame
echo 'Proteina Protein System' | gmx_mpi trjconv -f whole."$n".xtc -s md_npt."$n".tpr \
   -n index_anal.ndx -pbc cluster -center -o cluster."$n".xtc

# 3) Centraliza na proteína e põe tudo na caixa compacta
echo 'Proteina System' | gmx_mpi trjconv -f cluster."$n".xtc -s md_npt."$n".tpr \
    -n index_anal.ndx -center -pbc mol -ur compact -o md_npt."$n".noPBC.xtc
