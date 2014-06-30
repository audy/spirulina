#
# LOCATION OF RAW DATA
#
LEFT_READS='test/miseq-fastq/miseq-read-1.fastq'
BC_READS='test/miseq-fastq/miseq-read-barcode.fastq'
RIGHT_READS='test/miseq-fastq/miseq-read-2.fastq'
BARCODES='test/barcodes.csv'

READ_FORMAT='fastq' # older data is qseq

make default: 00-split-by-barcode.completed

tests:
	test/run-tests

clean:
	rm -rf *.completed
	rm -rf out
	rm -rf *.sh.o*
	rm -rf *.sh.e*
	rm -rf split-by-barcode/

00-split-by-barcode.completed:
	qsub -V \
		-v BARCODES=${BARCODES},LEFT_READS=${LEFT_READS},RIGHT_READS=${RIGHT_READS},BC_READS=${BC_READS} \
		qsubs/split-by-barcode.sh

trimmed/%.fasta: split-by-barcode/%.fastq
	qsub \
		-v INPUT=$<,OUTPUT=$@ \
		qsubs/trim.sh

classified/%.uc: trimmed/%.fasta
	qsub \
		-v INPUT=$<,OUTPUT=$@
