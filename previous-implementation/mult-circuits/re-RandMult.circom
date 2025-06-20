pragma circom 2.1.2;

include "../single-circuits/re-Rand.circom";

/*
 * re-randomise n ciphertexts using "reRand()" 
 */

template reRandMult(n){

    signal input c1[n][2];
    signal input c2[n][2];
    signal input randomVal[n];
    signal input pubKey[n][2];

    signal output d1[n][2];
    signal output d2[n][2];

    component reRands[n];

    for (var i = 0; i < n; i++) {
        reRands[i] = ElGamalReRandomize();

        reRands[i].c1        <== c1[i];
        reRands[i].c2        <== c2[i];
        reRands[i].randomVal <== randomVal[i];
        reRands[i].pubKey    <== pubKey[i];

        d1[i][0] <== reRands[i].d1[0];
        d1[i][1] <== reRands[i].d1[1];

        d2[i][0] <== reRands[i].d2[0];
        d2[i][1] <== reRands[i].d2[1];
    }
}