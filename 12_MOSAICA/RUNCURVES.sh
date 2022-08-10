#!/bin/bash

#         PARAMETERS
#--------------------------------
# 1. Curves+ directory (out of curves+ original folder)
# 2. REORDERATION path
# 3. x3dna path
# 4. x3dna/bin path

echo "=========================================="
echo "=========================================="
echo "=========================================="
echo "=========================================="
echo "=========================================="
export X3DNA=$3
export PATH=$4:$PATH
export CURVES_PLUS_STDLIB=$1

echo $X3DNA
echo $PATH
echo $CURVES_PLUS_STDLIB

for FILE in `ls -d $2/*`
do
	# for all reorderedfiles in all subfolders
	for REORDEREDFILE  in `ls -f $FILE/*.pdb`
	do
		echo "====> FILE NAME  ======>"$REORDEREDFILE
		nameFile=${REORDEREDFILE##*/}
		folder=${REORDEREDFILE%/*}
		nameFileNoExt=${nameFile%.*}
		NEWCurvesFileName=$folder"/"$nameFileNoExt"-c+.inp"

		#------------------------- DEBUGGING
		echo "++++++++++++++++++++++++++++++++++++++++++"
		echo "REORDERED FILE NAME: "$REORDEREDFILE
		echo "FILE NAME: "$nameFile
		echo "DIRECTORI: "$folder
		echo "NO EXTENTION FILE NAME: "$nameFileNoExt
		echo "NEW COMPLETE CURVES FILE NAME :"$NEWCurvesFileName
		echo "++++++++++++++++++++++++++++++++++++++++++"
		#-----------------------------------
		
		$4/find_pair -c+ $REORDEREDFILE $NEWCurvesFileName
	done

done



for FILE in `ls -d $2/*`
do
	

	# for all reorderedfiles in all subfolders
	for CURVESINPUTFILE  in `ls -f $FILE/*.inp`
	do

		fileName=${CURVESINPUTFILE##*/}
		fileNameNoExt=${fileName%.*}

		linea1=""
		linea2=""
		linea1=`cat $CURVESINPUTFILE | sed -n '1 p'`
		linea2=`cat $CURVESINPUTFILE | sed -n '2 p'`

		
		#de ini to end, give all after de "="
		linea1=${linea1#*=}
		# from init to end, five all before "/"
		linea1=${linea1%/*}
		#linea1="lis="$linea1"/"$nameFileNoExt","

		#sed '2s/.*/'$linea1'/gi' $CURVESINPUTFILE
		sed -i '2s|.*|     lis='$linea1'/'$fileNameNoExt'|g' $CURVESINPUTFILE
		

		export CURVES_PLUS_STDLIB=$1

		$1/Cur+ < $CURVESINPUTFILE
	done

done
