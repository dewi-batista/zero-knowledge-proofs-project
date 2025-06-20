pragma circom 2.1.2;

include "homAddMult.circom";

/*
 * add 100 ciphertexts using "homAdd()"
 */

component main = homAddMult(100);