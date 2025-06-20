pragma circom 2.1.2;

include "homEncMult.circom";

/*
 * encrypt 30 ciphertexts using "homEnc()"
 */

component main = homEncMult(30);