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
#
#This script currently assumes that reff is 1TAG
Tag="mFc"
#1 = 51mFu
#2 = 22
Reff="52mFu.gff"
ReffG="52mFu.fa"
#
Iso="$1""mFu.gff"
IsoG="$1""mFu.fa"
#
#
#
#cp /staging/mdrott/"$Reff" .
#cp /staging/mdrott/"$Iso" .
#cp /staging/mdrott/"$ReffG" .
#cp /staging/mdrott/"$IsoG" .
#
#
gffread "$Iso" -x CDS_$1"$Tag".fa -g "$IsoG"
gffread "$Reff" -x CDS_1"$Tag".fa -g "$ReffG"
#
#
translate_nucl_to_prot_fasta.py CDS_1"$Tag".fa > 1"$Tag"_prot_renamed.fa
translate_nucl_to_prot_fasta.py CDS_$1"$Tag".fa > $1"$Tag"_prot.fa
#
#
makeblastdb -dbtype prot -in 1"$Tag"_prot_renamed.fa
makeblastdb -dbtype prot -in $1"$Tag"_prot.fa
#
#
echo "Starting first blast"
date +%R
#
blastp -query 1"$Tag"_prot_renamed.fa -db $1"$Tag"_prot.fa -outfmt 6 -num_threads 3 -out REFF_vs_ISO_prots.bls
#
#
echo "First blast done"
date +%R
#
#
blastp -query $1"$Tag"_prot.fa -db 1"$Tag"_prot_renamed.fa -outfmt 6 -num_threads 3 -out ISO_vs_REFF_prots.bls
#
#
echo "Second blast done"
date +%R
#
#
reciprocal_best_blast.py ISO_vs_REFF_prots.bls REFF_vs_ISO_prots.bls 1 2 12 high ISO_reference_rbh.txt
#
#
rename_genes_blast.py $1"$Tag" CDS_$1"$Tag".fa "$Iso" ISO_reference_rbh.txt > $1ISO_names
#
#
rename_gff.py $1ISO_names "$Iso" > $1"$Tag"_genes_renamed.gff
#
#
list_genes_by_scaff.py $1"$Tag"_genes_renamed.gff > $1"$Tag"_genes_in_order.txt
#
#
rename_fasta.py $1ISO_names CDS_$1"$Tag".fa > $1"$Tag"_cds_renamed.fa
rename_fasta.py $1ISO_names $1"$Tag"_prot.fa > $1"$Tag"_prot_renamed.fa
#
#convert_augustus_gff_and_fasta_to_gbk.py "$IsoG" $1"$Tag"_genes_renamed.gff $1"$Tag"_prot_renamed.fa > $1"$Tag"_genome.gbk
#
#cp *renamed.fa /staging/mdrott/
#cp *renamed.gff /staging/mdrott/
#
#rm *.fa *.bls *.gff *.fasta *.fasta.fai
#rm *prot_renamed.fa*
#rm *mCc_prot.fa*
