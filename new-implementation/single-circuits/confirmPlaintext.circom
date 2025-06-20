pragma circom 2.1.2;

include "babyjub.circom";
include "doubleAndAddAny.circom";
include "doubleAndAddGenerator.circom";

/*
    Given a ciphertext (C1, C2) = ([r]G, [m]G + [r]Y) where r is the random integer,
    m is the plaintext value, G is the generator, Y = [s]G and s is the secret key,
    one can recover [m]G by computing
                        [m]G = C2 - [s]C1.
    To confirm such a computation, one can simply compute [m]G.
*/

template confirmPlaintext() {

    signal input c1_x;
    signal input c1_y;
    signal input c2_x;
    signal input c2_y;
    signal input plain;
    signal input secret_key;

    component dAdd_ANY = doubleAndAddAny();
    component dAdd_GEN = doubleAndAddGenerator();
    component adder    = BabyAdd();
    
    dAdd_ANY.k <== secret_key;
    dAdd_ANY.x <== c1_x;
    dAdd_ANY.y <== c1_y;

    adder.x1 <== c2_x;
    adder.y1 <== c2_y;
    adder.x2 <== dAdd_ANY.xout;
    adder.y2 <== -dAdd_ANY.yout;

    dAdd_GEN.k <== plain;

    log("");
    log(adder.xout == dAdd_GEN.xout && adder.yout == dAdd_GEN.yout);
    log("");
}

component main = confirmPlaintext();