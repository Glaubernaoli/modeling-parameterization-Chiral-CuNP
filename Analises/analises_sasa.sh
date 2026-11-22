#!/bin/bash
#SBATCH --job-name=sasa
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


n=1  #variar o valor de acordo com a réplica
t='abpbp2'
d='abpbp2_Dcys'
p='Dcys'


#echo -e "Proteina\nSystem" | gmx_mpi trjconv -f md_npt.$n.xtc -s md_npt.$n.tpr -n index_anal.ndx \
 #  -o md_npt.$n.noPBC.xtc -pbc mol -center -ur compact


if [ $sasa -eq 1 ]; then
	    gmx_mpi sasa -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx -o ../analises_Dcys/"$t"_sasa."$n".xvg -or ../analises_Dcys/"$t"_sasa_res."$n".xvg -tv ../analises_Dcys/"$t"_sasa_vol."$n".xvg -surface Proteina -output Proteina -xvg none
            
	    gmx_mpi sasa -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx -o ../analises_Dcys/"$p"_sasa."$n".xvg -or ../analises_Dcys/"$p"_sasa_res."$n".xvg -tv ../analises_Dcys/"$p"_sasa_vol."$n".xvg -surface NP -output NP -xvg none

            gmx_mpi sasa -f md_npt."$n".noPBC.xtc -s md_npt."$n".tpr -n index_anal.ndx \
    -o  ../analises_Dcys/"$d"_sasa_prot_NP."$n".xvg \
        -surface Proteina_NP -output Proteina_NP -xvg none

fi
