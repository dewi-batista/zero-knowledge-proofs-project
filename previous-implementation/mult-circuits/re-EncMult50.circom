pragma circom 2.1.2;

include "re-EncMult.circom";

/*
 * re-encrypt 50 plaintext points using "reEnc()"
 */

component main = reEncMult(50);