#!/bin/bash

#Parameters
#-----------------------------
# 1. Reordering path
# 2. x3dna Path
# 3. x3dna/bin path


#all parameters to obtain
my_params="shift slide tilt roll rise twist propeller buckle opening shear stagger stretch major_gw_refined major_gw_pp minor_gw_refined minor_gw_pp"

#redevelopment files direcory
reorderPath=$1


echo "=========================="
#--------------   setting environment variables------------
#----------------------------------------------------------
export X3DNA=$2
export PATH=$3:$PATH



for FILE in ls -d $1/*
do
    if test -d $FILE
    then
      echo "ESTOY ADENTRO----"$FILE	
      $3/find_pair $FILE/init_pymol.pdb $FILE/my_bps_pymol.inp
      ruby $3/x3dna_ensemble analyze -b $FILE/my_bps_pymol.inp -e $FILE/sampled.pos_pymol.pdb

      for param in $my_params
      do
	if [ ! -d $FILE/"PARAMETERS" ] 
	then
	    mkdir -p $FILE/PARAMETERS
	fi
         ruby $3/x3dna_ensemble extract -p $param -o $FILE/PARAMETERS/$param".dat"

      done

    fi
done
