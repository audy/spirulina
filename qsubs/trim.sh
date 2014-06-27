#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -l pmem=512mb
#PBS -l walltime=00:05:00
#PBS -l nodes=1:ppn=1
#PBS -j oe

# USAGE:

# qsub -v QUAL_TYPE=sanger,INPUT=foo.fastq trim.sh

cd $PBS_O_WORKDIR

echo "input: $INPUT"
echo "qual_type: $QUAL_TYPE"

# Usage: sickle pe -c <combined input file> -t <quality type> -m <combined trimmed output> -s <trimmed singles file>
# 
#  Options:
# -t, --qual-type, Type of quality values (solexa (CASAVA < 1.3), illumina (CASAVA 1.3 to 1.7), sanger (which is CASAVA >= 1.8)) (required)
# -f, --pe-file1, Input paired-end fastq file 1 (optional, must have same number of records as pe2)
# -r, --pe-file2, Input paired-end fastq file 2 (optional, must have same number of records as pe1)
# -c, --pe-combo, Combined input paired-end fastq (optional)
# -o, --output-pe1, Output trimmed fastq file 1 (optional)
# -p, --output-pe2, Output trimmed fastq file 2 (optional)
# -m, --output-combo, Output combined paired-end fastq file (optional)
# -s, --output-single, Output trimmed singles fastq file (required)
# -q, --qual-threshold, Threshold for trimming based on average quality in a window. Default 20.
# -l, --length-threshold, Threshold to keep a read based on length after trimming. Default 20.
# -x, --no-fiveprime, Don't do five prime trimming.
# -n, --discard-n, Discard sequences with any Ns in them.
# --quiet, do not output trimming info
# --help, display this help and exit
# --version, output version information and exit

sickle pe \
  --quiet \
  -c $INPUT \
  -t $QUAL_TYPE \
  -s /dev/null \
  -m /dev/stdout \
  -l 70 \
  -x \
  -n \
  | fastq-to-fasta \
  | rc-right-read \
  | hp-length-filter \
    --min-length 90 \
  > $INPUT.trimmed.fasta
