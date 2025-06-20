pragma circom 2.1.2;

include "babyjub.circom";
include "generatorDoubles.circom";

/*
    scalar multiplication using double and add for the generator
    x = 7117928050407583618111176421555214756675765419608405867398403713213306743542
    y = 14577268218881899420966779687690205425227431577728659819975198491127179315626
    on the Montgomery curve whose parameters are A = 168698 and B = 1
*/

template doubleAndAddGenerator() {

    signal input k;

    signal output xout;
    signal output yout;

    component adder[251]; // has 6 non-linear constraints

    for(var l = 0; l < 251; l++) {
        adder[l] = BabyAdd();
    }

    var A = 168698;
    var x = 7117928050407583618111176421555214756675765419608405867398403713213306743542;
    var y = 14577268218881899420966779687690205425227431577728659819975198491127179315626;

    // set adder[0] <- GENERATOR
    adder[0].x1 <== -x - A;
    adder[0].y1 <== -y;     // what's being done here to achieve
    adder[0].x2 <== 0;      // this requires some explanation
    adder[0].y2 <== -y;

    // doubles[i][0 or 1] = [2 ** i] * GENERATOR for i in {0, ..., 255}
    var doubles[256][2];
    doubles = getDoubles();
    
    // check the least significant bit of k and store it for later
    // if it is 0 (i.e. k is even) then add 1, other wise continue
    var var_k = k;
    var first_bit = var_k & 1;
    var_k += 1 - (var_k & 1);

    // initialise the rest of our needed variables
    var bit;   // variable for current rightmost bit of k >> i
    var i = 1; // variable for adder[j]
    var j = 2; // variable for doubles[j][0/1]
    var_k >>= 1;

    while(i < 250) {

        bit = var_k & 1;
        adder[i].x1 <-- adder[i-1].xout * bit + (-adder[i-1].xout - A) * (1 - bit);
        adder[i].y1 <-- adder[i-1].yout * bit + (-adder[i-1].yout)     * (1 - bit);
        adder[i].x2 <-- doubles[j-1][0] * bit                                     ;
        adder[i].y2 <-- doubles[j-1][1] * bit + (-adder[i-1].yout)     * (1 - bit);

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