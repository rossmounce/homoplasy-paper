To recalculate the statistics for the example sparse matrix figure demonstrating the difference between HER & MHER, run:

bash get-mher.sh sparse_matrix.tnt

get-mher.sh is a bash wrapper script that gives TNT input instructions and parses TNT output to calculate & save the descriptive statistics produced.

sparse_matrix.tnt is the hypothetical sparse matrix given in the paper, in TNT format.

1000reps.txt is essentially a parameter file, in which it is hardcoded to perform 1000 matrix permutation replications.

mher.run is the TNT script which actually performs the selective matrix permutations - only permuting known states.


