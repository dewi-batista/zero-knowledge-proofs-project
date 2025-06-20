pragma circom 2.1.2;

include "babyjub.circom";

/*
    scalar multiplication using double and add
    for any point on the Montgomery curve whose
    parameters are A = 168698 and B = 1
*/

template doubleAndAddAny() {

    signal input k;
    signal input x;
    signal input y;

    signal output xout;
    signal output yout;

    var A = 168698;
    var components_limit = 251;

    component adder[components_limit];
    component doubler[components_limit];

    for(var l = 0; l < components_limit; l++) {
        adder[l]   = BabyAdd();
        doubler[l] = BabyDbl();
    }

    // set adder[0] <- GENERATOR
    adder[0].x1 <== -x - A;
    adder[0].y1 <== -y;
    adder[0].x2 <== 0;
    adder[0].y2 <== -y;

    // set doubler[0] <- [2](x, y)
    doubler[0].x <== x;
    doubler[0].y <== y;
    for(var m = 1; m < components_limit; m++) {
        doubler[m].x <== doubler[m-1].xout;
        doubler[m].y <== doubler[m-1].yout;
    }

    // check the least significant bit of k and store it for later
    // if it is 0 (i.e. k is even) then add 1, other wise continue
    var var_k = k;
    var first_bit = var_k & 1;
    var_k += 1 - (var_k & 1);

    // initilise the rest of our needed variables
    var bit;   // variable for current rightmost bit of k
    var i = 1; // variable for adder[j]
    var j = 1; // variable for doubler[j]
    var_k >>= 1;

    while(i < 250) {

        bit = var_k & 1;
        adder[i].x1 <-- adder[i-1].xout   * bit + (-adder[i-1].xout - A) * (1 - bit);
        adder[i].y1 <-- adder[i-1].yout   * bit + (-adder[i-1].yout)     * (1 - bit);
        adder[i].x2 <-- doubler[j-1].xout * bit                                     ;
        adder[i].y2 <-- doubler[j-1].yout * bit + (-adder[i-1].yout)     * (1 - bit);

        i += 1;
        j += 1;
        var_k >>= 1;
    }

    adder[i].x1 <==  adder[i-1].xout;
    adder[i].y1 <==  adder[i-1].yout;
    adder[i].x2 <==  adder[0].xout;
    adder[i].y2 <== -adder[0].yout;

    xout <-- adder[i-first_bit].xout;
    yout <-- adder[i-first_bit].yout;
}

component main = doubleAndAddAny();