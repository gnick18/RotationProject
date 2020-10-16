#!/bin/sh
#
#
tar -xzf FungalPopgenSMGC-master.tar.gz
tar -xzf ncbi-blast-2.8.1+-x64-linux.tar.gz
tar -xzf cufflinks-2.2.1.Linux_x86_64.tar.gz
tar -xzf pythonNEW.tar.gz
#
#
export PATH=$(pwd)/FungalPopgenSMGC-master/AssemblyScripts:$PATH
export PATH=$(pwd)/ncbi-blast-2.8.1+/bin:$PATH
export PATH=$(pwd)/python/bin:$PATH
export PATH=$(pwd)/cufflinks-2.2.1.Linux_x86_64:$PATH
#
##This should extract 51 or 22 depending on what the sub send in as the ISO file
Name=`ls -lh | grep ISOmFu.fa | awk '{print $9}' | sed 's/ISOmFu\.fa//'`
#
#This script currently assumes that reff is 1TAG
Tag="mFc"
#
Reff="52mFu.gff"
ReffG="52mFu.fa"
#
Iso=$Name"ISOmFu.gff"
IsoG=$Name"ISOmFu.fa"
#
# NOT RUNNING SINCE THEY'RE PASSED IN THROUGH THE sub file
# This is the location of he annotation and sequences
#cp /home/gnickles/Genomes/"$Reff" .
#cp /home/gnickles/Genomes/"$Iso" .
#cp /home/gnickles/Genomes/"$ReffG" .
#cp /home/gnickles/Genomes/"$IsoG" .
#
#
gffread "$Iso" -x CDS_$Name"$Tag".fa -g "$IsoG"
gffread "$Reff" -x CDS_1"$Tag".fa -g "$ReffG"
#
#
translate_nucl_to_prot_fasta.py CDS_1"$Tag".fa > 1"$Tag"_prot_renamed.fa
translate_nucl_to_prot_fasta.py CDS_$Name"$Tag".fa > $Name"$Tag"_prot.fa
#
#
makeblastdb -dbtype prot -in 1"$Tag"_prot_renamed.fa
makeblastdb -dbtype prot -in $Name"$Tag"_prot.fa
#
#
echo "Starting first blast"
date +%R
#
blastp -query 1"$Tag"_prot_renamed.fa -db $Name"$Tag"_prot.fa -outfmt 6 -num_threads 3 -out REFF_vs_ISO_prots.bls
#
#
echo "First blast done"
date +%R
#
#
blastp -query $Name"$Tag"_prot.fa -db 1"$Tag"_prot_renamed.fa -outfmt 6 -num_threads 3 -out ISO_vs_REFF_prots.bls
#
#
echo "Second blast done"
date +%R
#
#
reciprocal_best_blast.py ISO_vs_REFF_prots.bls REFF_vs_ISO_prots.bls 1 2 12 high ISO_reference_rbh.txt
#
#
rename_genes_blast.py $Name"$Tag" CDS_$Name"$Tag".fa "$Iso" ISO_reference_rbh.txt > $NameISO_names
#
#
rename_gff.py $NameISO_names "$Iso" > $Name"$Tag"_genes_renamed.gff
#
#
list_genes_by_scaff.py $Name"$Tag"_genes_renamed.gff > $Name"$Tag"_genes_in_order.txt
#
#
rename_fasta.py $NameISO_names CDS_$Name"$Tag".fa > $Name"$Tag"_cds_renamed.fa
rename_fasta.py $NameISO_names $Name"$Tag"_prot.fa > $Name"$Tag"_prot_renamed.fa
#
#convert_augustus_gff_and_fasta_to_gbk.py "$IsoG" $1"$Tag"_genes_renamed.gff $1"$Tag"_prot_renamed.fa > $Name"$Tag"_genome.gbk
#
cp *renamed.fa /home/gnickles/
cp *renamed.gff /home/gnickles/
#
#rm *.fa *.bls *.gff *.fasta *.fasta.fai
#rm *prot_renamed.fa*
#rm *mCc_prot.fa*
