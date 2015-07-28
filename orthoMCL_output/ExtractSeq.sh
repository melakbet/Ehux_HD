#!/bin/bash
# This is a bash script that extracts the sequences for all orthologous groups (OG). 
# It takes the a OG ids list as input and saves all sequences belonging to that group 
# from all organism in a file named with OG group in fasta format.
# Note that after the script is executed, there will be 'n' number of files (where 
# n=total number of OG's in the input list

# Arun Seetharam <aseetharam@purdue.edu>

scriptName="${0##*/}"
outdir=$(pwd)
function printUsage() {
    cat <<EOF

Synopsis

    $scriptName [-h | --help] [-o dir_name] input_ids_list database

Description

    Extracts sequences for all ortholog groups supplied as list. For each ID in the list
    a file containing FASTA sequences will be generated, whcih belong to that OG.
    Note: this script requires standalone blast+ software.

    input_ids_list 
        Input list should contain orthologous group IDs one per line
        These IDs should be generated by "orthomclMclToGroups" command

    database
        Absoulute path for the database should be specified. The database is 
        generally named as 'goodProteins.fasta'.

    -o directory_name
        directory name to save the output files. By default all files will be saved in 
        the current directory.

    -h, --help 
        Brings up this help page
 
Author

    Arun Seetharam, Bioinformatics Core, Purdue University.
    aseetharam@purdue.edu




EOF
}

if [ $# -lt 1 ] ; then
    printUsage
    exit 1
fi

while getopts ':o:' option; do
  case "$option" in
       o) outdir=$OPTARG
       shift
       ;;
       h) printUsage
       exit
       ;;
       help) printUsage
       exit
       ;;
  esac
done
#module use /apps/group/bioinformatics/modules # uncomment these 2 lines if running this on clusters
#module load blast
mkdir -p $outdir
shift $(( $# - 2 ))
file=${1}
pathdbname=${2}
sed -i 's/://g' ${file}
while IFS=$' ' read -r -a myArray
do
for i in "${myArray[@]:0}";
do
blastdbcmd -entry "$i" -db ${pathdbname} >> ${outdir}/${myArray[0]}.fa;
done
done <${file}
