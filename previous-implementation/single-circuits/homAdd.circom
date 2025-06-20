pragma circom 2.1.2;

include "babyjub.circom";

/*
 * add two ElGamal ciphertext over babyjubjub.
 *
 * c1, c2:     The first ciphertext
 * c3, c4:     The second ciphertext
 * d1, d2:        The resulting ciphertext
 *
 */

template homAdd() {

    signal input c1x;
    signal input c1y;
    signal input c2x;
    signal input c2y;
    signal input c3x;
    signal input c3y;
    signal input c4x;
    signal input c4y;
    
    signal output d1[2];
    signal output d2[2];

    component xPoint = BabyAdd();
    xPoint.x1 <== c1x;
    xPoint.y1 <== c1y;
    xPoint.x2 <== c2x;
    xPoint.y2 <== c2y;

    d1[0] <== xPoint.xout;
    d1[1] <== xPoint.yout;

    component yPoint = BabyAdd();
    yPoint.x1 <== c3x;
    yPoint.y1 <== c3y;
    yPoint.x2 <== c4x;
    yPoint.y2 <== c4y;

    d2[0] <== yPoint.xout;
    d2[1] <== yPoint.yout;
}