#!/bin/bash

#This is a bash script to perform the modified Homoplasy Excess Ratio
#on a dataset of your choice passed to this script as an argument
#You also need the files 'mher.run' AND '1000reps.txt' in the same dir

#The MIT License (MIT)

#Copyright (C) 2013 Ross Mounce

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#DATA FILE TO BE TESTED MUST END with 'procedure /;'
#this makes a copy of the data file with 
#additional instructions appended to tmp.tnt
sed 's@procedure \/;@log temp1.log; minmax\*; sect:slack 40; xmult=level10; log\/; log output_reps.log; mher start; proc 1000reps.txt; quit;@' $1 > tmp.tnt

#ensure that all inapplicables have been converted to ? marks
sed -i 's/-/?/g' tmp.tnt;
#put back hyphens in ccode block if they were taken out by the above command
sed -i 's/?\[\//-\[\//g' tmp.tnt;

#this will do everything then quit. output hardcoded to output.log
tnt proc tmp.tnt; 

mkdir output-${1%.tnt}

printf "MEANNS calculations in TNT are complete \n"

#hacky shorter way of gettings the modified-MEANNS
grep 'Best score:' output_reps.log | awk '{sum+=$3} END { print sum/NR}' > ./output-${1%.tnt}/mns.tmp

#get MINL, temp1 is the first logfile output from TNT
head -1 temp1.log | sed 's/\// /g' | cut -d ' ' -f 8 > ./output-${1%.tnt}/minl.tmp
#get L, L=tmp3.tmp, MINL=tmp2.tmp
tail -1 temp1.log | sed 's/\./ /g' | cut -d ' ' -f 3 > ./output-${1%.tnt}/l.tmp

#print results
printf "MINL = `cat ./output-${1%.tnt}/minl.tmp` \n"
printf "L = `cat ./output-${1%.tnt}/l.tmp` \n"
printf "Modified-MEANNS = `cat ./output-${1%.tnt}/mns.tmp` \n"
paste ./output-${1%.tnt}/mns.tmp ./output-${1%.tnt}/minl.tmp ./output-${1%.tnt}/l.tmp | awk '{o = ($1-$3)/($1-$2)} END { print "Modified-HER = " o }' | tee ./output-${1%.tnt}/MHER.out

#clean up temporary files but leave behind permuted matrix log file
rm temp1.log;
rm tmp.tnt; 
rm output_reps.log; 

