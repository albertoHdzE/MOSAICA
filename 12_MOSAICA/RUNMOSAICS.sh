#!/bin/bash

if [ -f "mosaics.x" ];
then
   ln -s /home/alberto/version.3.8-EM/examples/mosaics.x mosaics.x
fi

if [ -f "libEM2.so" ];
then
   ln -s /home/alberto/version.3.8-EM/EMAN2/lib/linux/x86_64/libEM2.so libEM2.so
fi

export LD_LIBRARY_PATH=/home/alberto/version.3.8-EM/EMAN2/lib/linux/x86_64:$LD_LIBRARY_PATH

echo $LD_LIBRARY_PATH

./mosaics.x $1 > output
