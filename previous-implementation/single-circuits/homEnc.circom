pragma circom 2.1.2;

include "babyjub.circom";
include "bitify.circom";
include "escalarmulany.circom";
include "escalarmulfix.circom";

/*
 * Performs encryption on an ElGamal ciphertext.
 * plain: The plaintext
 * d1, d2: The ciphertext
 * z:      The random value (randomVal)
 * pubKey: The public key
 * g:      A generator
 *
 * d1 = g ** z
 * d2 = (pk ** z) * (g ** plain)
 */

template ElGamalEncrypt() {
    
    signal input plain;
    signal input randomVal;
    signal input pubKey[2];
    
    signal output d1[2];
    signal output d2[2];

    // Convert plain to bits
    component plainBits = Num2Bits(253);
    plainBits.in <== plain;

    // Convert randomVal to bits
    component randomValBits = Num2Bits(253);
    randomValBits.in <== randomVal;

    // g ** z
    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];
    
    component gz = EscalarMulFix(253, BASE8);
    for (var i = 0; i < 253; i ++) {
        gz.e[i] <== randomValBits.out[i];
    }

    // pubKey ** z
    component pubKeyZ = EscalarMulAny(253);
    for (var i = 0; i < 253; i ++) {
        pubKeyZ.e[i] <== randomValBits.out[i];
    }
    pubKeyZ.p[0] <== pubKey[0];
    pubKeyZ.p[1] <== pubKey[1];

    // g ** plain
    component gPlain = EscalarMulFix(253, BASE8);
    for (var i = 0; i < 253; i ++) {
        gPlain.e[i] <== plainBits.out[i];
    }

    // -
    component d2Adder = BabyAdd();
    d2Adder.x1 <== pubKeyZ.out[0];
    d2Adder.y1 <== pubKeyZ.out[1];
    d2Adder.x2 <== gPlain.out[0];
    d2Adder.y2 <== gPlain.out[1];

    // Output the ciphertext
    d1[0] <== gz.out[0];
    d1[1] <== gz.out[1];
    d2[0] <== d2Adder.xout;
    d2[1] <== d2Adder.yout;
}