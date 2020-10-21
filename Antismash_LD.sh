#!/bin/bash
#
export PATH=/opt/conda/bin:$PATH
#
#Name=`ls -lh /staging/mdrott/Eurotiales/ | grep tar.gz | head -$1 | tail -1 | awk '{print $9}' | sed 's/\.tar\.gz//'`
Name=`ls -lh | grep tar.gz | head -$1 | tail -1 | awk '{print $9}' | sed 's/\.tar\.gz//'`
#
#cp /staging/mdrott/Eurotiales/"$Name".tar.gz .
tar -xvf "$Name".tar.gz
#
. activate antismash
#
antismash --taxon fungi --genefinding-gff "$Name".gff ./"$Name".fna --output-dir "$Name"_anti
#
#tidy up the antismash output
rm ./"$Name"_anti/"$Name".gbk
rm ./"$Name"_anti/*.zip
rm ./"$Name"_anti/*.json
gzip ./"$Name"_anti/regions.js
#
tar -czvf "$Name"_anti.tar.gz ./"$Name"_anti
#
#
#cp "$Name"_anti.tar.gz /staging/mdrott/
#
#rm *.gz
rm *.gff
rm *.fna
