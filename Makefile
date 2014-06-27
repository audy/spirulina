#
# LOCATION OF RAW DATA
#
LEFT_READS='raw-reads/Undetermined_S0_L001_R1_001.fastq'
BC_READS='raw-reads/Undetermined_S0_L001_I1_001.fastq'
RIGHT_READS='raw-reads/Undetermined_S0_L001_R2_001.fastq'

READ_FORMAT='fastq' # older data is qseq

make default: 00-split-by-barcode.completed

00-split-by-barcode.completed:
	qsub \
		-v LEFT_READS=${LEFT_READS},RIGHT_READS=${RIGHT_READS},BC_READS=${BC_READS}
		qsubs/split-by-barcode.sh

trimmed/%.fasta: split-by-barcode/%.fastq
	qsub \
		-v INPUT=$<,OUTPUT=$@ \
		qsubs/trim.sh

classified/%.uc: trimmed/%.fasta
	qsub \
		-v INPUT=$<,OUTPUT=$@
