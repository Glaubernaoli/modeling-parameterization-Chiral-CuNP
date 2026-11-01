#!/usr/bin/env python3
#SBATCH --time 5

import sys
import random
from ase.io import read, write
from acat.adsorption_sites import ClusterAdsorptionSites
from acat.build import add_adsorbate_to_site, remove_adsorbate_from_site
from acat.adsorption_sites import group_sites_by_facet
from acat.adsorbate_coverage import ClusterAdsorbateCoverage


filename = 'Cu_cluster_2nm.xyz'
atoms = read(filename)
print(atoms)
atoms.pbc = False

cas = ClusterAdsorptionSites(atoms, surrogate_metal='Cu', ignore_sites='ontop')
all_sites = cas.get_sites()

print(f"Total de sítios: {len(all_sites)}")

site_types =  set(s['site'] for s in all_sites)
print(f"Tipos de sítios encontrados: {site_types}")

surfaces = set(s['surface'] for s in all_sites)
print(f"Superficies encontradas: {surfaces}")

for s in all_sites[:3]:
    print(s)

min_distance = 5   # Minimum allowed distance between any two S atoms (in Angstroms)
added_S_indices = []

all_sites = cas.get_sites()
candidate_sites = [s for s in all_sites if s['site'] in ['bridge', 'fcc', 'hcp', '4fold']]

random.shuffle(candidate_sites)

for sx, site in enumerate(candidate_sites):
    print(site)
    add_adsorbate_to_site(atoms, adsorbate='S', site=site)
    new_S_index = len(atoms) - 1  # In ASE, the newly added atom is appended to the very end of the list

    # Measure distance against all previously accepted S atoms
    too_close = False
    for existing_idx in added_S_indices:
        dist = atoms.get_distance(new_S_index, existing_idx)
        if dist < min_distance:
            too_close = True
            break

    if too_close:
        # Revert: Delete the atom we just added because it violated the distance rule
        del atoms[new_S_index:]
    else:
        # Accept: Keep the atom and save its index
        added_S_indices.append(new_S_index)

Cu_S_2_5nm = f"Cu_2nm_S_{len(added_S_indices)}.xyz"
atoms.write(Cu_S_2_5nm, format='xyz')
