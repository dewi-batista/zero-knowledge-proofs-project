pragma circom 2.1.2;

include "re-RandMult.circom";

/*
 * re-randomise 100 ciphertexts using "reRand()"
 */

component main = reRandMult(100);