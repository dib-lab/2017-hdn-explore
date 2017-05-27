#PBS -l nodes=1:ppn=1
#PBS -l walltime=24:00:00
#PBS -l mem=8GB
#PBS -N hdn
#PBS -A ged
# Send an email when a job is aborted, begins or ends
#PBS -m abe

#set -x
#set -e

env | grep PBS            # Print out values of the current jobs PBS environment variables

cd /mnt/research/ged/ctb/2017-hdn-explore
pwd

###

. ~ctb/py3/load.sh

###

for i in data/?.fa data/??.fa
do
	READS=${i}.pe.mapped.fa.gz
	trim-low-abund.py ${READS} -M 1e9 -k 31 --gzip -o ${READS}.trim.gz
	load-graph.py ${i}.ng ${READS}.trim.gz -M 1e9 -k 31 --no-build-tagset && \
	./measure-reads.py ${i}.ng ${READS}.trim.gz && rm ${i}.ng
done

###

qstat -f ${PBS_JOBID}     # Print out final statistics about resource uses before job exits
