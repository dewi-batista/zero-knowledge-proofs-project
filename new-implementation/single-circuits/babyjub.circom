pragma circom 2.1.2;

/*
    Montgomery curve addition using the parameters
    of the BabyJubJub curve (A = 168698 and B = 1)
*/

template BabyAdd() {

    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    
    signal output xout;
    signal output yout;

    var A = 168698;
    var B = 1;

    signal lamda;

    lamda <-- (y2 - y1) / (x2 - x1);
    lamda * (x2 - x1) === (y2 - y1);

    xout <== B * lamda * lamda - A - x1 - x2;
    yout <== lamda * (x1 - xout) - y1;
}

/*
    Montgomery curve doubling using the parameters
    of the BabyJubJub curve (A = 168698 and B = 1)
*/

template BabyDbl() {

    signal input x;
    signal input y;
    
    signal output xout;
    signal output yout;

    var A = 168698;
    var B = 1;

    signal lamda;
    signal x_2;

    x_2 <== x * x;

    lamda <-- (3 * x_2 + 2 * A * x + 1) / (2 * B * y);
    lamda * (2 * B * y) === (3 * x_2 + 2 * A * x + 1);

    xout <== B * lamda * lamda - A - 2 * x;
    yout <== lamda * (x - xout) - y;
}