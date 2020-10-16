#!/bin/sh
#
#2mFc_prot_renamed.fa name of protein file
File=2mFuGrepResults.txt
echo "The following is the results for -A1 grep" >> $File
echo "\n" >> $File
grep -A1 Afu4g01420 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A1 Afu4g01370 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A1 Afu5g02660 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A1 Afu3g13690 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A1 Afu3g13700 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File

echo "The following is the results for -A3 grep" >> $File
echo "\n" >> $File
grep -A3 Afu4g01420 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A3 Afu4g01370 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A3 Afu5g02660 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A3 Afu3g13690 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
grep -A3 Afu3g13700 2mFc_prot_renamed.fa >> $File
echo "\n" >> $File
