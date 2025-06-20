pragma circom 2.1.2;

include "babyjub.circom";
include "doubleAndAddAny.circom";
include "doubleAndAddGenerator.circom";

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

    component singleAddition = BabyAdd();
    component dAddAny        = doubleAndAddAny();

    dAddGenerator.k <== randomVal;

    dAddAny.k <== randomVal;
    dAddAny.x <== pubKey[0];
    dAddAny.y <== pubKey[1];

    singleAddition.x1 <== plainPoint[0];
    singleAddition.y1 <== plainPoint[1];
    singleAddition.x2 <== dAddAny.xout;
    singleAddition.y2 <== dAddAny.yout;
}