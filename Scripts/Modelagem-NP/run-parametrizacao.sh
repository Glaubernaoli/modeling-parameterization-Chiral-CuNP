#!/bin/bash
#SBATCH --job-name=sTDA
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=192G
#SBATCH --time=8-00:00:00
#SBATCH -e log/slurm-%x-%u-%j.err 
#SBATCH -o log/slurm-%x-%u-%j.out

export XTB4STDAHOME=/home/lorena24014/TCC/parametrizacao/xtb4stda
export OMP_NUM_THREADS=8 MKL_NUM_THREADS=8
ulimit -s unlimited
export OMP_STACKSIZE=16G

exec=/home/lorena24014/TCC/parametrizacao/stda_1.6.3/xtb4stda
$exec ../relaxacao/xtbopt.xyz > xtb.out

exec=/home/lorena24014/TCC/parametrizacao/stda_1.6.3/stda_v1.6.3
$exec -xtb wfn.xtb -e 5 > stda.out


