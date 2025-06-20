pragma circom 2.1.2;

include "../single-circuits/homEnc.circom";

/*
 * encrypt n plaintexts using "homEnc()" 
 */

template homEncMult(n){

    signal input plain[n];
    signal input pubKey[n][2];
    signal input randomVal[n];

    signal output out1[n][2];
    signal output out2[n][2];

    component encrypts[n];

    for (var i = 0; i < n; i++) {
        encrypts[i] = homEnc();

        encrypts[i].plain     <== plain[i];
        encrypts[i].pubKey    <== pubKey[i];
        encrypts[i].randomVal <== randomVal[i];

        out1[i][0] <== encrypts[i].out1[0];
        out1[i][1] <== encrypts[i].out1[1];

        out2[i][0] <== encrypts[i].out2[0];
        out2[i][1] <== encrypts[i].out2[1];
    }
}