#!/bin/bash

export GMXLIB=/home/lorena24014/TCC/teste

pdb='abpbp2_zinco.pdb'

gmx_mpi pdb2gmx -f $pdb -p top.top -ignh -ff charmm36-feb2026_cgenff-5.0 -water tip3p -o solute.pdb -heavyh

#index da restrição
printf 'q\n' | gmx_mpi make_ndx -f solute.pdb -o default.ndx
n0=$(grep -c '^\[' default.ndx)      # nº de grupos padrão

printf 'r 1-12 | r 160-187\na H*\n! %s\n%s & %s\nq\n' $((n0+1)) $n0 $((n0+2)) | gmx_mpi make_ndx -f solute.pdb -o index.ndx

grp=$(( $(grep -c '^\[' index.ndx) - 1 ))     # o grupo final é o último
echo "grupo da região: $grp"

echo $grp | gmx_mpi genrestr -f solute.pdb -n index.ndx -o posre_restr.itp -fc 1000 1000 1000

# inclui no top.top, logo depois do bloco "#ifdef POSRES" do pdb2gmx
awk '{print}
/#include "posre.itp"/ {f=1; next}
f && /#endif/ {print "#ifdef POSRE_RESTR\n#include \"posre_restr.itp\"\n#endif"; f=0}' top_Protein_chain_A.itp > tmp.itp && mv tmp.itp top_Protein_chain_A.itp

#montagem da caixa
echo 'Protein' | gmx_mpi editconf -f solute.pdb -o box.gro -d 3 -princ -c -bt triclinic

gmx_mpi solvate -cp box.gro   -o shell.gro -p top.top -cs spc216.gro -shell 0.5
gmx_mpi solvate -cp shell.gro -o water.gro -p top.top -cs spc216.gro


n_line_first_wat=$(cat water.gro | grep SOL -n | head -n 1 | awk -F ':' '{print $1}')
n_wat_atm_to_remove=$(cat top.top | grep ^'SOL   ' | head -n 1 | awk '{print $2*3'})

echo $n_line_first_wat
echo $n_wat_atm_to_remove

let n_last_line_pt1=$n_line_first_wat-1
let n_first_line_pt2=$n_line_first_wat+$n_wat_atm_to_remove

cat water.gro | head -n  $n_last_line_pt1   > tmp.gro
cat water.gro | tail -n +$n_first_line_pt2 >> tmp.gro

n_atm=$(wc -l tmp.gro | awk '{print $1}')
let n_atm=$n_atm-3

head -n 1 tmp.gro > water_ok.gro
echo $n_atm >> water_ok.gro
tail -n +3 tmp.gro >> water_ok.gro

rm tmp.gro

head -n -2 top.top > tmp.top
tail -n 1 top.top >> tmp.top
mv tmp.top top.top





gmx_mpi grompp -f ../mdp_files/grompp_min2.mdp -c water_ok.gro -p top.top -o ion_neutral.tpr -maxwarn 1





valence=1
is=0.150
z_pos=1
z_neg=1
pos='NA'
neg='CL'
z_pos_counter=1
z_neg_counter=1
pos_counter='NA'
neg_counter='CL'

echo 'SOL' | gmx_mpi genion -s ion_neutral.tpr -o ion_neutral.gro -p top.top -pname $pos_counter -nname $neg_counter -pq $z_pos_counter -nq "-"$z_neg_counter  -neutral -conc 0.00

n_wat=$(cat ion_neutral.gro | grep 'SOL ' | grep 'OW' | wc -l | awk '{print $1}')

c_pos=$(echo '' | awk -v is=$is -v z_pos=$z_pos -v z_neg=$z_neg -v v=$valence '{a=(2*is)/((z_pos^2)+(v*(z_neg^2))) ; print a}')
c_neg=$(echo '' | awk -v c_pos=$c_pos -v v=$valence '{c_neg=v*c_pos ; print c_neg}')

n_pos=$(echo '' | awk -v c_pos=$c_pos -v n_wat=$n_wat '{n_pos=c_pos*(n_wat/55.55); printf "%.0f\n", n_pos}')
n_neg=$(echo '' | awk -v n_pos=$n_pos -v v=$valence '{n_neg=v*n_pos ; print n_neg}')


gmx_mpi grompp -f ../mdp_files/grompp_min2.mdp -c ion_neutral.gro -o ion_is.tpr -p top.top -maxwarn 1
echo 'SOL' | gmx_mpi genion -s ion_is.tpr -o ion_is.gro -p top.top -pname $pos -nname $neg -np $n_pos -nn $n_neg
#echo 'System' | gmx_mpi trjconv -f ion_is.gro -s min.tpr -o ion_is.pdb -pbc mol -ur compact

#gmx_mpi grompp -f ../mdp_files/grompp_min2.mdp -c ion_is.gro -r ion_is.gro -p top.top -maxwarn 1 -o min_none.tpr
#gmx_mpi mdrun -s min_none.tpr -v -deffnm min_none

#gmx_mpi grompp -f ../mdp_files/grompp_min1.mdp -c min_none.gro -r min_none.gro -p top.top -maxwarn 1 -o min.tpr
#gmx_mpi mdrun -s min.tpr -v -deffnm min

#echo 0 | gmx_mpi trjconv -f min.gro -s min.tpr -o min.pdb -pbc mol -ur compact
