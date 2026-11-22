#!/bin/bash
#SBATCH --job-name=rmsf
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --hint=multithread
#SBATCH --time=05:00:00
#SBATCH -p gpu
#SBATCH -e log/slurm-%x-%u-%j.err
#SBATCH -o log/slurm-%x-%u-%j.out
 
 
# "Flags" para controlar quais análises serão executadas
trj=1
rmsd=1
rmsf=1
sasa=1
rg=1
hb=1
 
 
 
n=1
d='abpbp2_Dcys'

 

# ---------- RMSF ---------- (Root Mean Square Fluctuation, medida de flexibilidade estrutural)
if [ $rmsf -eq 1 ]; then

    # 1) Estrutura média só dos C-alpha da PROTEÍNA (avg_ca.$n.pdb, 553 átomos)
    #    Sistema completo -> usa index_anal.ndx e o grupo Proteina-Calpha
    echo 'Proteina-Calpha' | gmx_mpi rmsf -f md_npt."$n".xtc -s md_npt."$n".tpr \
        -n index_anal.ndx -o tmp.xvg -xvg none -res -ox avg_ca."$n".pdb
    rm tmp.xvg

    # 2) Trajetória só com C-alpha da proteína, ajustada (rot+trans) nesses mesmos C-alpha
    #    1º grupo = ajuste, 2º grupo = saída. Ainda sistema completo -> index_anal.ndx
    echo 'Proteina-Calpha Proteina-Calpha' | gmx_mpi trjconv -f md_npt."$n".xtc -s md_npt."$n".tpr \
        -n index_anal.ndx -o ca."$n".xtc -fit rot+trans

    # 3) PDB dos C-alpha. Sistema já reduzido (553 átomos) -> sem -n, grupo 0 = System
    echo 0 | gmx_mpi trjconv -f ca."$n".xtc -s avg_ca."$n".pdb \
        -o ../analises_Dcys/"$d"_ca."$n".pdb

    # 4) RMSF em relação à estrutura média. Sem -n, grupo 0 = System
    echo 0 | gmx_mpi rmsf -f ca."$n".xtc -s avg_ca."$n".pdb \
        -o ../analises_Dcys/"$d"_rmsf_avg-ca."$n".xvg -xvg none -res -nofit
fi
