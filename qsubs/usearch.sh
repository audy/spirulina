#PBS -q default
#PBS -M triplettlab@gmail.com
#PBS -m abe
#PBS -l pmem=8Gb
#PBS -l walltime=02:00:00
#PBS -l nodes=1:ppn=4
#PBS -N usearch
#PBS -j oe

# USAGE: qsub -v QUERY=foo,DATABASE=bar

# usually takes between 20-40 minutes and
# uses between 2-6 Gb of memory


module load usearch

cd $PBS_O_WORKDIR

date

usearch \
  --usearch_local $QUERY \
  --id 0.97 \
  --uc $QUERY.uc \
  --strand plus \
  --threads 4 \
  --query_cov 0.95 \
  --db $DATABASE

date

touch $QUERY.completed
