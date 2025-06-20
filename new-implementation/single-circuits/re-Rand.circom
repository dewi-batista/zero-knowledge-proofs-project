pragma circom 2.1.2;

include "babyjub.circom";
include "doubleAndAddAny.circom";
include "doubleAndAddGenerator.circom";

/*
 * Performs rerandomization on an ElGamal ciphertext.
 * c1, c2: The existing ciphertext
 * d1, d2: The rerandomized ciphertext
 * randomVal:      The random value (randomVal)
 * pubKey: The public key under which the existing ciphertext was encrypted
 * g:      A generator
 *
 * d1 = (g ** z) * c1
 * d2 = (pk ** z) * c2
 */

template reRand() {

    signal input c1[2];
    signal input c2[2];
    signal input randomVal;
    signal input pubKey[2];
    
    signal output d1[2];
    signal output d2[2];
    
    component addition1     = BabyAdd();
    component addition2     = BabyAdd();
    component dAddGenerator = doubleAndAddGenerator();
    component dAddAny       = doubleAndAddAny();
    
    dAddGenerator.k <== randomVal;
    
    addition1.x1 <== dAddGenerator.xout;
    addition1.y1 <== dAddGenerator.yout;
    addition1.x2 <== c1[0];
    addition1.y2 <== c1[1];

    dAddAny.k <== randomVal;
    dAddAny.x <== pubKey[0];
    dAddAny.y <== pubKey[1];

    addition2.x1 <== dAddAny.xout;
    addition2.y1 <== dAddAny.yout;
    addition2.x2 <== c2[0];
    addition2.y2 <== c2[1];

    // Output the rerandomized ciphertext
    d1[0] <== addition1.xout;
    d1[1] <== addition1.yout;
    d2[0] <== addition2.xout;
    d2[1] <== addition2.yout;
}