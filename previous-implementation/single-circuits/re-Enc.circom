pragma circom 2.1.2;

include "babyjub.circom";
include "bitify.circom";
include "escalarmulany.circom";
include "escalarmulfix.circom";

/*
    description of what this does
    the maths of it is probably useful as a description
*/

template reEnc() {

    signal input plainPoint[2];
    signal input pubKey[2];
    signal input randomVal;

    signal output out1[2];
    signal output out2[2];

    // Convert randomVal to bits
    component randomValBits = Num2Bits(253);
    randomValBits.in <== randomVal;

    var BASE8[2] = [
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203
    ];

    component dAddGenerator = EscalarMulFix(253, BASE8);
    for (var i = 0; i < 253; i ++) {
        dAddGenerator.e[i] <== randomValBits.out[i];
    }

    component dAddAny = EscalarMulAny(253);
    for (var i = 0; i < 253; i ++) {
        dAddAny.e[i] <== randomValBits.out[i];
    }
    dAddAny.p[0] <== pubKey[0];
    dAddAny.p[1] <== pubKey[1];

    component singleAddition = BabyAdd();
    singleAddition.x1 <== plainPoint[0];
    singleAddition.y1 <== plainPoint[1];
    singleAddition.x2 <== dAddAny.out[0];
    singleAddition.y2 <== dAddAny.out[1];
}