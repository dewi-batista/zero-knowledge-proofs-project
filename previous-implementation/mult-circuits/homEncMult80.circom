pragma circom 2.1.2;

include "homEncMult.circom";

/*
 * encrypt 80 ciphertexts using "homEnc()"
 */

component main = homEncMult(80);