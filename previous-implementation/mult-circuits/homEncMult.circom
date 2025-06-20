pragma circom 2.1.2;

include "../single-circuits/homEnc.circom";

/*
 * add n ciphertexts using "homAdd()" 
 *
 * c1, c2: The first ciphertext
 * c3, c4: The second ciphertext
 * d1, d2: The resulting ciphertext
 */

template homEncMult(n){

    signal input plain[n];
    signal input randomVal[n];
    signal input pubKey[n][2];

    signal output d1[n][2];
    signal output d2[n][2];

    component encrypts[n];

    var i;
    for (i=0; i<n; i++) {
        encrypts[i] = ElGamalEncrypt();

        encrypts[i].plain     <== plain[i];
        encrypts[i].randomVal <== randomVal[i];
        encrypts[i].pubKey    <== pubKey[i];

        d1[i][0] <== encrypts[i].d1[0];
        d1[i][1] <== encrypts[i].d1[1];

        d2[i][0] <== encrypts[i].d2[0];
        d2[i][1] <== encrypts[i].d2[1];
    }
}