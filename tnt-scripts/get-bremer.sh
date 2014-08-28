#!/bin/bash

#This is a bash script to perform Bremer support analysis AND to get Lee's (1999) Proportional Support Index

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
cp "$1" bremer.run ./results_$STEM/
cd results_$STEM
sed 's@procedure \/;@xinact; hold 100000; sect:slack 200; xmult=level10; bb; taxname=; log '$STEM'-bremer.log; run bremer.run ; log\/; quit;@' $1 > 1TMP.tnt
sed 's@xread@mxram 100; xread@' 1TMP.tnt > bremerTMP.tnt

#this will do everything then quit. output hardcoded to output.log
tnt mxram 200, proc bremerTMP.tnt 

printf "BREMER DONE \n"

cat $STEM-bremer.log
cat $STEM-bremer.log | sed -n '/^Tree [0-9]/,/Again/p' | sed 's/-- .*//' | sed '1d' | tr -d [:alpha:] | tr -d [:punct:] | tr " " "\n" | awk '{ sum += $1 } END { print sum }' > $STEM-SUM-bremer.out

paste $STEM-CI.out $STEM-L.tmp $STEM-SUM-bremer.out | awk '{o = ($3)/($1 * $2)} END { print "Proportional Support Index = " o }' > $STEM-PSI.result 
paste $STEM-L.tmp $STEM-SUM-bremer.out | awk '{o = ($2)/($1)} END { print "Total Support Index = " o }' > $STEM-TSI.result

cat $STEM-PSI.result
cat $STEM-TSI.result

rm bremerTMP.tnt; 
rm bremer.run;
 
