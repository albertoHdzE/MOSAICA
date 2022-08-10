#! /usr/bin/python

#argument[1] name of original MOSAICA file
#argument[2] full directory of MOSAICA file
#argument[3] prefix or new reordered file
#argument[4] new directory for reordered file
# note: new file name (reordered) ) prefix+nameOriginalMOSAICAFile
#       supposing that folder of origina file is descriptive enough


import __main__
__main__.pymol_argv = ['pymol','-qc']

import sys,time,os
import pymol
pymol.finish_launching()

# MOSAICA file name
spath = os.path.abspath(sys.argv[1])

print "**"
print 'Estoy adentro de python script'
print "Argumento[1]: "+ sys.argv[1] #path of mosaic file (no file name)
print "Argumento[2]: "+ sys.argv[2] #only file name, no path
print "Argumento[3]: "+ sys.argv[3] #prefix or sulfolder name
print "Argumento[4]: "+ sys.argv[4] #relative path of new reordered file
print "spath: " + spath 




# MOSAICA file origin path
sys.path.append(sys.argv[1])

# take extention out of MOSAICA file name
my_file = sys.argv[2]
end = my_file.find(".pdb")
file_name = my_file[0:end]

print "path append: "+ sys.argv[1]
print "my_file: "+ my_file
print "file_name: "+ file_name

# load in pymol
pymol.cmd.load(spath+"/"+my_file,file_name)
#pymol.cmd.load(spath,file_name)

# building new directory 
newDir=str(sys.argv[4])+"/"+str(sys.argv[3])
print "newDir: "+ newDir


if not os.path.exists(newDir):
	os.makedirs(newDir)

#building new reordered file
newFullFileName = str(sys.argv[4])+"/"+str(sys.argv[3])+"/"+file_name+"_pymol.pdb"
#newFullFileName = str(sys.argv[4])+"/"+file_name+"_pymol.pdb"
print "NewFullFileName: "+newFullFileName
print "****************"
print "========================= end"
#last "0" is for saving all states
pymol.cmd.save(newFullFileName,file_name,0)

pymol.cmd.quit()
