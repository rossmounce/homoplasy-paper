#!/bin/bash

#This is a bash script to get XXX on cladistic datasets including the modified Homoplasy Excess Ratio, CI, RI, ci's for each and every character
#on a dataset of your choice passed to this script as an argument
#You also need the files 'mher.run', 'reps.txt' , 'stats.run' AND 'cstats.run' in the same dir as this script file

#The MIT License (MIT)

#Copyright (C) 2013 Ross Mounce

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#DATA FILE TO BE TESTED MUST END with 'procedure /;'
#this makes a copy of the data file with 
#additional instructions appended to tmp.tnt
STEM=$(echo $1 | awk -F. '{ print $1 }')
mkdir results_$STEM 
cp "$1" mher.run reps.txt stats.run cstats.run ./results_$STEM/
cd results_$STEM
sed 's@procedure \/;@log '$STEM'-GCbootstrap.log; xinact; hold 10000; sect:slack 40; xmult=level10; bb; taxname=; resample boot replications 1000; log\/; log jakbootstrap.log; resample jak replications 1000 probability 75; log\/; log symbootstrap.log; resample sym replications 1000 ; log\/; quit;@' $1 > boot-tmp2.tnt 

#this will do everything then quit. output hardcoded to output.log
tnt proc boot-tmp2.tnt 

#clean up temporary files but leave behind the necessary files
# rm temp12.log;
rm boot-tmp2.tnt; 
# rm minl2.tmp; 
# rm l2.tmp;
# rm mns.tmp;
 
