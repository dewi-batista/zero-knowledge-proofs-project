pragma circom 2.1.2;

include "babyjub.circom";
include "doubleAndAddAny.circom";
include "doubleAndAddGenerator.circom";

template homEnc() {

    signal input plain;
    signal input pubKey[2];
    signal input randomVal;

    signal output out1[2];
    signal output out2[2];

    component multiplyRandom = doubleAndAddGenerator(); // [r] * GENERATOR
    component multiplyPlain  = doubleAndAddGenerator(); // [m] * GENERATOR
    component multiplyPubKey = doubleAndAddAny();       // [r] * PUBLICKEY = [r] * ([secretKey] * GENERATOR)
    component singleAddition = BabyAdd();

    // computes [r] * GENERATOR
    multiplyRandom.k <== randomVal;

    // computes [m] * GENERATOR
    multiplyPlain.k <== plain;

    // computes [r] * PUBLICKEY
    multiplyPubKey.k <== randomVal;
    multiplyPubKey.x <== pubKey[0];
    multiplyPubKey.y <== pubKey[1];

    // first output point
    out1[0] <== multiplyRandom.xout;
    out1[1] <== multiplyRandom.yout;

    // computes [m] * GENERATOR + [r] * PUBLICKEY
    singleAddition.x1 <== multiplyPlain.xout;
    singleAddition.y1 <== multiplyPlain.yout;
    singleAddition.x2 <== multiplyPubKey.xout;
    singleAddition.y2 <== multiplyPubKey.yout;

    // second output point
    out2[0] <== singleAddition.xout;
    out2[1] <== singleAddition.yout;
}