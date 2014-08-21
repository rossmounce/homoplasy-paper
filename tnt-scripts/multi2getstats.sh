#!/bin/bash
# Usage: attempt to make a plaintext conversion copy of all PDFs in all subfolders (maxdepth 1 folder down) of the working directory

# Turning on the nullglob shell option
shopt -s nullglob

# Loop through pwd cd'ing into each directory then pdftotext all PDFs within each subdirectory
  for f in *.tnt
	do
	echo "running $f"
	./2get-alltrees.sh "$f"
        ./2get-stats.sh "$f"
	./bootstrap.sh "$f"
	./get-bremer.sh "$f"  
	done
