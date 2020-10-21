#!/bin/sh
#
#Name=`ls -lh | awk '{print $9}'| grep ^GC|  grep tar.gz |  sed 's/\.tar\.gz//'`
Name=22_ICS
tar -xvf "$Name".tar.gz
#
tar -xzf FungalPopgenSMGC-master.tar.gz
tar -xzf cufflinks-2.2.1.Linux_x86_64.tar.gz
tar -xzf pythonNEW.tar.gz
#
#
export PATH=$(pwd)/FungalPopgenSMGC-master/AssemblyScripts:$PATH
export PATH=$(pwd)/python/bin:$PATH
export PATH=$(pwd)/cufflinks-2.2.1.Linux_x86_64:$PATH
#
#make sure gff is sorted
sort -k1,1V -k4,4n -k5,5rn -k3,3r "$Name".gff > temp.gff
mv temp.gff "$Name".gff
#
#make prot file and list genes in order
gffread "$Name".gff -x CDS.fa -g "$Name".fna
translate_nucl_to_prot_fasta.py CDS.fa > "$Name"_prot.fa
list_genes_by_scaff.py "$Name".gff > "$Name"_genes_in_order.txt
#
tar -xzf jdk-11.0.7_linux-x64_bin.tar.gz
tar -xzf interproscan-5.44-79.0-64-bit.tar.gz
#
#
export PATH=$(pwd)/jdk-11.0.7/bin:$PATH
#
#it looks like ~40 prots have stop codons in them that were simply ignored. For this analysis I think I can just remove them..
#
cat "$Name"_prot.fa | sed 's/\*//g' > temp
mv temp "$Name"_prot.fa
#
./interproscan-5.44-79.0/interproscan.sh -i "$Name"_prot.fa -f tsv -goterms -pathways
#
rm CDS.fa "$Name".gff "$Name".fna *.tar.gz
#
tar -czvf "$Name"_prots.tar.gz "$Name"_prot.fa "$Name"_prot.fa.tsv "$Name"_genes_in_order.txt
rm "$Name"_prot.fa "$Name"_prot.fa.tsv "$Name"_genes_in_order.txt
