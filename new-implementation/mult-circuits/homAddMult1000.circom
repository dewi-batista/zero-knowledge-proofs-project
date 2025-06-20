pragma circom 2.1.2;

include "homAddMult.circom";

/*
 * add 1000 ciphertexts using "homAdd()"
 */

component main = homAddMult(1000);