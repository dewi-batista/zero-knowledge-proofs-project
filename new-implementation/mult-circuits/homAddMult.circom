pragma circom 2.1.2;

include "../single-circuits/homAdd.circom";

/*
 * add n ciphertexts using "homAdd()" 
 */

template homAddMult(n){
    
    signal input c1x[n];
    signal input c1y[n];
    signal input c2x[n];
    signal input c2y[n];
    signal input c3x[n];
    signal input c3y[n];
    signal input c4x[n];
    signal input c4y[n];
    
    signal output d1x[n];
    signal output d1y[n];
    signal output d2x[n];
    signal output d2y[n];

    component adders[n];

    var i;
    for (i=0; i<n; i++) {
        adders[i] = homAdd();
        adders[i].c1x <== c1x[i];
        adders[i].c1y <== c1y[i];
        adders[i].c2x <== c2x[i];
        adders[i].c2y <== c2y[i];
        adders[i].c3x <== c3x[i];
        adders[i].c3y <== c3y[i];
        adders[i].c4x <== c4x[i];
        adders[i].c4y <== c4y[i];

        d1x[i] <== adders[i].d1[0];
        d1y[i] <== adders[i].d1[1];

        d2x[i] <== adders[i].d2[0];
        d2y[i] <== adders[i].d2[1];
    }
}