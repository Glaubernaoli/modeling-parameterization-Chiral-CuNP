#!/bin/bash
#SBATCH --job-name=rmsd
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
hb=



n=1
d='abpbp2_dcys'

echo '22 22' | gmx_mpi rms -f md_npt."$n".xtc -s md_npt."$n".tpr -n index_anal.ndx -o ../analises_Dcys/"$d"_rmsd_ca-ca."$n".xvg -xvg none

#echo 'C-alpha C-alpha' | gmx_mpi rms -f md_npt."$n".xtc -s md_npt."$n".tpr -o ../analises_Lcys/"$d"_rmsd_ca-ca."$n".xvg -xvg none
