##################################################################
####    cool script to add ligands to a given NP structure    ####
####    weird but works! (or not...)                          ####
####    felippe                                               ####
##################################################################
#!/bin/bash                                                      #
##################################################################

# how to add ligands to the NP structure?

# 1. load gromacs module

# 2. get your pdb files for both the NP and the ligand molecule and convert to .gro files

gmx_mpi editconf -f Cu_2nm_S_94.pdb -o Cu_2nm_S_94.gro

gmx_mpi editconf -f D-cysteine.pdb -o D-cysteine.gro

# 3. indentify which atoms will be replaced (here, all sulfur atoms labeled as S):

### 3.1. count them...

n=$( grep -c "S" Cu_2nm_S_94.gro )

### 3.2. ...and save their xyz coordinates

grep "S" Cu_2nm_S_94.gro | cut -c21-44 | awk '{printf "%9.6f\t%9.6f\t%9.6f\n", $1, $2, $3}' > positions.dat

# 4. use gromacs insert-molecules tool to place the S atoms of the ligand (ones at 0,0,0) at the S positions
#    (this step generates a file with the ligands only)

gmx_mpi insert-molecules \
  -f Cu_2nm_S_94.gro \
  -ci D-cysteine.gro \
  -dr 0 \
  -nmol ${n} \
  -selrpos atom \
  -ip positions.dat \
  -box 6 6 6 \
  -replace "name S" \
  -try 50000 \
  -radius 0.05 \
  -o final_ligands.gro
  
# 5. generate final file:

### 5.1. generate a coordinate file for the NP without the atoms to be replaced, without headers and footers

n_atoms_np=$( head -n 2 Cu_2nm_S_94.gro | tail -n 1 )

printf "Original NP has %i atoms\n" ${n_atoms_np}

head -n -1 Cu_2nm_S_94.gro | tail -n ${n_atoms_np} | grep -v S > tmp

n_atoms_np_new=$( echo "${n_atoms_np} - ${n}" | bc )

printf "%i atoms will be replaced by the ligands\n" ${n}
printf "soooo, we have %i atoms left\n" ${n_atoms_np_new}


### 5.2. generate a coordinate file for the ligands, without headers and footers

n_atoms_ligands=$( head -n 2 final_ligands.gro | tail -n 1 )

head -n -1 final_ligands.gro | tail -n ${n_atoms_ligands} > tmp2


### 5.3. generate the full coordinate file

total_atoms=$( echo "${n_atoms_np_new} + ${n_atoms_ligands}" | bc )

printf "%s\n" "Functionalized structure"   > final_structure.gro
printf "%i\n" ${total_atoms}              >> final_structure.gro
cat tmp                                   >> final_structure.gro
cat tmp2                                  >> final_structure.gro
printf "%10.5f%10.5f%10.5f\n" 6.0 6.0 6.0 >> final_structure.gro

rm tmp tmp2



