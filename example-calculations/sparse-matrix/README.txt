To recalculate the statistics for the example sparse matrix figure demonstrating the difference between HER & MHER, run:

bash get-mher.sh sparse_matrix.tnt #to get MHER
bash get-her.sh sparse_matrix.tnt #to get HER

'get-mher.sh' and 'get-her.sh' are bash wrapper scripts that give TNT input instructions whilst also parsing TNT output to calculate & save the descriptive statistics produced.

'sparse_matrix.tnt' is the hypothetical sparse matrix given in the paper, in TNT format.

'mher.run' is the TNT script which actually performs the selective matrix permutations - only permuting known states.

'100reps.txt' is essentially a parameter file, in which it is hardcoded to perform 100 selective (MHER) matrix permutation replications.

'her-reps.txt' is another parameter file, in which is hardcoded 100 (HER) matrix permutation replications.


