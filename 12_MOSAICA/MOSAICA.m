(* ::Package:: *)

BeginPackage["MOSAICA`"]

SetMOSAICADirectory::usage "SetMOSAICADirectory["DirectoryPath "] Defines path where MOSAICS and MOSAICA.m are installed";
SetSequencePDBFile::usage "Defines path of genomic sequence to be simulated";
SetSimulationParametersFile::usage "Defines path of file with simulation parameters. This file can be modified by used used funcionts of comfiguration";

(*
SETTING PARAMETERS OF SIMULATION
----------------------------------
*)







(*MOSAICA Path is the the master path where MOSAICA operares*)
SetMOSAICADirectory[MOSAICAPath_] := MyMOSAICAPath = MOSAICAPath;

(*1. simulation*)
(*Here is where the coordinates or referencial model (.pdb) on which
simulations will be run. Here is also the input file with simulation parameters*)
SetSimulationPath[simulationPath_] := MySimulatioPath = simulationPath;
SetSequencePDBFile[seqPDBFilePath_] := MySeqPDBFilePath = seqPDBFilePath;
SetSimulationParametersFile[simulationParamsFile_String] := MySimulationParamsFile = simulationParamsFile;



ShowSimulationParamValues:= Module[{},
SetDirectory[MySimulatioPath];
SetSimulationParametersFile[MySimulationParamsFile];
params={"simulation_typ","minimize_type","prop_tors_sig","prop_rot_sig","prop_trans_sig","prop_clos_sig","total_step_mc","statistics_freq","write_energy_unit","stsamc_type","stsamc_period","stsamc_ampl","stsamc_shift","random_seed","cgres_model","mol_parm_file","inter_database_file","cryo_em_database_file","pos_init_file","pos_out_file","atom_pos_file","epot_file","einter_file","energy_term","energy_term"};
valores=FindList[MySimulationParamsFile,#]&/@params;
valores1=StringReplace[#," "~~___~~"\\"->""]&/@valores// TableForm;
Return[valores1];
]

ReplaceSimulationParameter[paramName_String, newValue_String]:= Module[
{},
SetDirectory[MySimulatioPath];
myFile=Import[MySimulationParamsFile,"List"];
wantedLine=FindList[MySimulationParamsFile,paramName];
newLine=ToString[StringReplace[wantedLine,paramName~~"{"~~__~~"}" -> paramName<>"{"<>newValue<>"}"]];
newLine=StringReplace[newLine,"{"~~" "->" "];
newLine=StringReplace[newLine," "~~"}"->""];
newFile=StringReplace[myFile, wantedLine -> newLine];
Export["salida.nuevo", newFile, "Table"];
]


RunMOSAICSSimulation:= Module[{},
SetDirectory[MySimulatioPath];
SetSimulationParametersFile[MySimulationParamsFile];
commandLine="!bash RUNMOSAICS.sh"<>" "<>MySimulationParamsFile;
mosaicsOutput=Import[commandLine,"String"];
]

SetMOSAICAMasterPath[MOSAICAMasterPath_]:=MyMOSAICAMasterPath=MOSAICAMasterPath;
SetMOSAICSTestsDirectory[mosaicsTestsDirectory_]:=MyMosaicsTestsDirectory=mosaicsTestsDirectory;
SetReorderingTestsDirectory[reorderingTestsDirectory_]:=MyReorderingTestsDirectory=reorderingTestsDirectory;


RunPymolReordering:=Module[{},
SetMOSAICAMasterPath[MyMOSAICAMasterPath];
SetMOSAICSTestsDirectory[MyMosaicsTestsDirectory];
SetReorderingTestsDirectory[MyReorderingTestsDirectory];
SetDirectory[MyMosaicsTestsDirectory];
subfolders=Select[FileNames["*","",Infinity],DirectoryQ];
noSubfolders=Length[subfolders];
(*Create subrirectories for reordering*)
For[i=1,i<=noSubfolders,i++,
tarjetDir=MyReorderingTestsDirectory<>"/"<>Part[subfolders, i];
CreateDirectory[tarjetDir]];

(*resutsFile = "/home/alberto/09_DNAMath/results.txt"
str = OpenWrite[]*)
For[i = 1, i <= noSubfolders, i++,
 MOSAICSFilePartialPath=MyMosaicsTestsDirectory<>"/"<>Part[subfolders, i];
 prefix=Part[subfolders,i];
 reorderPath=MyReorderingTestsDirectory;
 SetDirectory[MOSAICSFilePartialPath];
 pdbOriginFileNames=FileNames["*.pdb"];
 noPDBFiles=Length[pdbOriginFileNames];
 (*
 WriteString[resutsFile, "MOSAICSFilePartialPath: ", 
  MOSAICSFilePartialPath, "\n"];
 WriteString[resutsFile, "prefix: ", prefix, "\n"];
 WriteString[resutsFile, "reorderPath: ", reorderPath, "\n"];
 WriteString[resutsFile, "pdbPriginFileNames: ", pdbOriginFileNames, 
  "\n"];
 WriteString[resutsFile, "+++++++++++++++++++", "\n"];
 *)
 For[j=1,j<=noPDBFiles,j++,
  MOSAICAFileName=Part[pdbOriginFileNames, j];
  commandLine="!python2 "<>MyMOSAICAMasterPath<>"/pymolReordering.py"<>" "<>MOSAICSFilePartialPath<>" "<>MOSAICAFileName<>" "<>prefix<>" "<>reorderPath;
  (*WriteString[resutsFile,"++++",commandLine,"\n"];*)
  pythonOutput=Import[commandLine,"String"];
  ]
 ]
(*Close[resutsFile]*)
]


SetX3DNADirectory[x3dnaDirectory_]:=Module[{},
MyX3dnaDirectory=x3dnaDirectory;
MyX3dnaBinDirectory=MyX3dnaDirectory<>"/bin";
]

RunX3DNAAnalisys:= Module[{},
SetMOSAICAMasterPath[MyMOSAICAMasterPath];
SetReorderingTestsDirectory[MyReorderingTestsDirectory];
SetX3DNADirectory[MyX3dnaDirectory];
SetDirectory[MyMOSAICAMasterPath];
commandLine="!bash RUNX3DNA.sh"<>" "<>MyReorderingTestsDirectory<>" "<>MyX3dnaDirectory<>" "<>MyX3dnaBinDirectory;
mosaicsOutput=Import[commandLine,"String"];
]

SetCurvesPath[curvesPath_]:=MyCurvesPath =curvesPath;

RunCurvesAnalysys:=Module[{},
SetReorderingTestsDirectory[MyReorderingTestsDirectory];
SetMOSAICAMasterPath[MyMOSAICAMasterPath]
SetCurvesPath[MyCurvesPath];
SetX3DNADirectory[MyX3dnaDirectory];

SetDirectory[MyMOSAICAMasterPath];
commandLine="!bash RUNCURVES.sh"<>" "<>MyCurvesPath<>" "<>MyReorderingTestsDirectory<>" "<>MyX3dnaDirectory<>" "<>MyX3dnaBinDirectory;
mosaicsOutput=Import[commandLine,"String"];
]




EndPackage[]






