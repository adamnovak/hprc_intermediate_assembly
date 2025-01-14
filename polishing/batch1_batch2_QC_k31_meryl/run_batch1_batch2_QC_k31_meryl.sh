###############################################################################
##                             create sample table                           ##
###############################################################################

## on personal computer, manually add sample yak column from
# intermAssembl_batch1_sample_table_20231204_WUSTLonly_s3_mira_polishing_batch1_2_yak_count.updated.csv
# to intermAssembl_batch1_sample_table_20231204_WUSTLonly_s3_mira_polishing_batch2.updated.csv
# and add HG01975 from batch 1

###############################################################################
##                             create input jsons                            ##
###############################################################################

## on personal computer...

cd /Users/miramastoras/Desktop/Paten_lab/hprc_intermediate_assembly/polishing/batch1_batch2_QC_k31_meryl/hprc_polishing_QC_input_jsons/

python3 ../../../hpc/launch_from_table.py \
     --data_table ../intAsm_batch1_batch2_polishingQC_sample_table.csv \
     --field_mapping ../hprc_polishing_QC_input_mapping.csv \
     --workflow_name hprc_polishing_QC

## add/commit/push to github (hprc_intermediate_assembly)

###############################################################################
##                             create launch polishing                      ##
###############################################################################

## on HPC...
cd /private/groups/hprc/polishing

## check that github repo is up to date
git -C /private/groups/hprc/polishing/hprc_intermediate_assembly pull

## check that github repo is up to date
git -C /private/groups/hprc/polishing/hpp_production_workflows/ pull

mkdir batch1_batch2_QC_k31_meryl
cd batch1_batch2_QC_k31_meryl

## get files to run hifiasm in sandbox...
cp -r /private/groups/hprc/polishing/hprc_intermediate_assembly/polishing/batch1_batch2_QC_k31_meryl/* ./

mkdir hprc_polishing_QC_submit_logs

## launch with slurm array job
sbatch \
     launch_batch1_batch2_QC_k31_meryl.sh \
     intAsm_batch1_batch2_polishingQC_sample_table.csv

#resubmit HG002 because json had a bug
sbatch \
     launch_batch1_batch2_QC_k31_meryl_HG002.sh \
     intAsm_batch1_batch2_polishingQC_sample_table.csv


#still dealing with bugs, just try HG00597 for now
sbatch \
     launch_batch1_batch2_QC_k31_meryl.HG00597.sh \
     intAsm_batch1_batch2_polishingQC_sample_table.csv
