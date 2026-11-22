###########################################
#    L-cys			          #
###########################################

gmx_mpi editconf -f CuNPQLcys.pdb -box 16.11701  11.56174  10.96681 -o complexo.gro     # coordenadas da caixa utilizada para a proteína sozinha

gmx_mpi editconf -f complexo.gro -translate 5 2 -1 -o complexo_trans.gro  #ajustar a posição para cada réplica

gmx_mpi solvate -cp box.gro -cs spc216.gro -maxsol 63893 -o box_solvate.gro

gmx_mpi make_ndx -f box_solvate.gro -o index.ndx

# ajustar top; copiar .ipt

gmx_mpi grompp -f ../mdp_files/grompp_min2.mdp -c box_solvate.gro -p top.top -n index.ndx -r box_solvate.gro -o ion.tpr -maxwarn 2

echo 21| gmx_mpi genion -s ion.tpr -n index.ndx -o conf.gro -conc 0.15 -pname "NA" -nname "CL" -neutral

grep -c "NA " conf.gro

# ajustar topologia para os íons e rodar minimização

