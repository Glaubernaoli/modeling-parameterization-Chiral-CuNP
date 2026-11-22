#!/bin/bash
#SBATCH --job-name=hb
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



n=1  #alterar valor de acordo com a réplica
d='abpbp2_Dcys'


# Intra-proteína

gmx_mpi hbond -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx  -r 'group "Proteina"' -t 'group "Proteina"' -num ../analises_Dcys/"$d"_hb_prot."$n".xvg -xvg none

gmx_mpi hbond -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx -r 'group "Proteina"' -t 'group "Proteina"' -dist ../analises_Dcys/"$d"_hb_prot_dist.$n.xvg -hbr 0.35 -ang ../analises_Dcys/"$d"_hb_prot_dist.$n.xvg -hba 30 -dan ../analises_Dcys/"$d"_hb_prot_dan."$n".xvg -xvg none

# Proteína-NP

gmx_mpi hbond -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx -r 'group "Proteina"' -t 'group "NP"' -num ../analises_Dcys/"$d"_hb_prot_NP."$n".xvg -xvg none


gmx_mpi hbond -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx -r 'group "Proteina"' -t 'group "NP"' -dist ../analises_Dcys/"$d"_hb_prot_NP_dist.$n.xvg -hbr 0.35 -hba 30 -ang ../analises_Dcys/"$d"_hb_prot_NP_dist.$n.xvg -dan ../analises_Dcys/"$d"_hb_prot_NP_dan."$n".xvg -xvg none


