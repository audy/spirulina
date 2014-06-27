#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -q default
#PBS -l pmem=2018mb
#PBS -l walltime=20:00:00
#PBS -l nodes=1:ppn=8

set -e

#
# Preprocessing Pipeline:
#
# raw reads -> split by barcode (fastq) files

# USAGE: qsub -v BARCODES=barcodes.csv,LEFT_READS=foo.fastq.gz,BC_READS=bar.fastq.gz=RIGHT_READS=baz.fastq.gz

cd $PBS_O_WORKDIR

OUTDIR='split-by-barcode'
EXPERIMENT=$(basename `pwd`)

date

mkdir -p $OUTDIR

hp-label-by-barcode \
  --barcodes $BARCODES \
  --reverse-barcode \
  --complement-barcode \
  --left-reads $LEFT_READS \
  --right-reads $RIGHT_READS \
  --bc-seq-proc 'lambda b: b[0:7]' \
  --barcode-reads $BC_READS \
  --output-format fastq \
  --id-format "${EXPERIMENT}_B_%(sample_id)s %(index)s" \
  --output /dev/stdout \
  | hp-split-by-barcode \
     --input /dev/stdin \
     --format 'fastq' \
     --output-directory $OUTDIR

touch 00-split-by-barcode.completed

date
