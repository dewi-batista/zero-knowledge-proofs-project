pragma circom 2.1.2;

include "homAddMult.circom";

/*
 * add 10 ciphertexts using "homAdd()"
 */

component main = homAddMult(10);