pragma circom 2.1.2;

include "../single-circuits/re-Enc.circom";

/*
 * re-encrypt n 'recovered plaintext points' (of the form [m]G) using "re-Enc()" 
 */

template reEncMult(n){

    signal input plainPoint[n][2];
    signal input pubKey[n][2];
    signal input randomVal[n];

    signal output out1[n][2];
    signal output out2[n][2];

    component re_encrypts[n];

    for (var i = 0; i < n; i++) {
        re_encrypts[i] = reEnc();

        re_encrypts[i].plainPoint <== plainPoint[i];
        re_encrypts[i].pubKey     <== pubKey[i];
        re_encrypts[i].randomVal  <== randomVal[i];

        out1[i][0] <== re_encrypts[i].out1[0];
        out1[i][1] <== re_encrypts[i].out1[1];

        out2[i][0] <== re_encrypts[i].out2[0];
        out2[i][1] <== re_encrypts[i].out2[1];
    }
}