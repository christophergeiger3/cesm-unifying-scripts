#!/bin/bash

##### Do not edit this line:
( set -o posix ; set ) >/tmp/variables.before
#######################

# Example configuration

cesm_root=$(cd ../.. && pwd)
gen_mapping_files=${cesm_root}/tools/mapping/gen_mapping_files

nx=320                       # number of i ocn gridpoints (longitudes)
ny=394                       # number of j ocn gridpoints (latitudes)

scripdir=/gpfs/fs1/p/cgd/ccr/people/ranfeng/plio_bnd/PlioMIP_enh/cpl_mapping/scrip1.4/


# -----------------------------------------------------------------
# Input files -----------------------------------------------------
# -----------------------------------------------------------------

popgridfile=${gen_mapping_files}/horiz_grid_plioenh_070820.ieeer8
kmtgridfile=${gen_mapping_files}/topography_plio_enh_gx1v6_190619.CESM2_modMed.ieeei4

# -----------------------------------------------------------------
# Output labels -----------------------------------------------------
# -----------------------------------------------------------------
ocngridname='plio_enh'

# -----------------------------------------------------------------
# Output filenames ------------------------------------------------
# -----------------------------------------------------------------
DATE=$(date +%y%m%d)
ocnres='gx1v6plioenh'
ocngridfile=${ocnres}_${DATE}.nc

#TODO
#HERESTRING=$(cat << EOF
#          &input_nml
#           gridtype     = 'rtm'
#           file_roff    = '/glade/p/cesm/cseg/inputdata/lnd/clm2/rtmdata/rdirc.05.061026'
#           file_ocn     = '../gx1v6plioenh_${DATE}.nc'
#           file_nn      = 'map_r05_to_gx1v6plioenh_nn_${DATE}.nc '
#           file_smooth  = 'map_gx1v6_to_gx1v6plioenh_sm_e1000r300_${DATE}.nc '
#           file_new     = 'map_r05_to_gx1v6plioenh_nnsm_e1000r300_${DATE}.nc'
#           title        = 'runoff map: r05 -> gx1v6, nearest neighbor and smoothed '
#           eFold        = 1000000.0
#           rMax         =  300000.0
#           step1 = .true.
#           step2 = .true.
#           step3 = .true.
#          /
#        EOF
#)

##### Do not edit after this line:
( set -o posix ; set ) >/tmp/variables.after

>Variables.env
for var in $(diff -e /tmp/variables.before /tmp/variables.after | sort)
do
	if [[ $var == *"="* ]]; then
		printf "$var\n" >> Variables.env
	fi
done
