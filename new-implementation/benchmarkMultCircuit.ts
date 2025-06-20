import { execSync } from 'child_process'

// working directiry must be ./circuits when running this 
process.chdir("./new-implementation");

function timeSetupProof(circuit : string, potFile : string, scheme : string) {
    const startTime = new Date().getTime();
    execSync(`circom "./mult-circuits/${circuit}".circom --r1cs --wasm`);
    process.chdir(`./${circuit}_js`);
    if(scheme == 'groth16') {
        execSync(`snarkjs ${scheme} setup ../${circuit}.r1cs ../potFiles/${potFile}.ptau ${circuit}_initialZkeyFile.zkey`);
        execSync(`snarkjs zkey contribute ${circuit}_initialZkeyFile.zkey ${circuit}_finalZkeyFile.zkey --name="1st Contributor Name" -e="e"`);
    }
    else {
        execSync(`snarkjs ${scheme} setup ../${circuit}.r1cs ../potFiles/${potFile}.ptau ${circuit}_finalZkeyFile.zkey`);
    }
    execSync(`snarkjs zkey export verificationkey ${circuit}_finalZkeyFile.zkey verification_key.json`);
    let elapsedTime = new Date().getTime() - startTime;
    return elapsedTime / 1000;
}

function timeGenerateProof(circuit : string, input : string, scheme : string) {
    const startTime = new Date().getTime();
    execSync(`node generate_witness.js ${circuit}.wasm ../mult-circuits-inputs/${input}.json witness.wtns`);
    execSync(`snarkjs ${scheme} prove ${circuit}_finalZkeyFile.zkey witness.wtns proof.json public.json`);
    let elapsedTime = new Date().getTime() - startTime;
    return elapsedTime / 1000;
}

function timeVerifyProof(scheme : string) {
    const startTime = new Date().getTime();
    execSync(`snarkjs ${scheme} verify verification_key.json public.json proof.json`);
    let elapsedTime = new Date().getTime() - startTime;
    return elapsedTime / 1000;
}

function averageTimes(circuit : string, input : string, potFile : string, scheme : string, iterations : number) {
    
    var averageTimeSetupProof    = 0;
    var averageTimeGenerateProof = 0;
    var averageTimeVerifyProof   = 0;
    for(let i = 0; i < iterations; i++) {
        averageTimeSetupProof    += timeSetupProof(circuit, potFile, scheme);
        averageTimeGenerateProof += timeGenerateProof(circuit, input, scheme);
        averageTimeVerifyProof   += timeVerifyProof(scheme);
        process.chdir("..");
    }
    console.log(`\n${circuit}_${scheme} set up average`, averageTimeSetupProof / iterations);
    console.log(`${circuit}_${scheme} generate average`, averageTimeGenerateProof / iterations);
    console.log(`${circuit}_${scheme} verify average`,   averageTimeVerifyProof / iterations);
}

// groth16, prints the average time taken to run each phase 10 times

averageTimes('homAddMult10',   'homAddMult10-input',   'powersOfTau28_hez_final_08', 'groth16', 10);
averageTimes('homAddMult100',  'homAddMult100-input',  'powersOfTau28_hez_final_10', 'groth16', 10);
averageTimes('homAddMult1000', 'homAddMult1000-input', 'powersOfTau28_hez_final_14', 'groth16', 10);

averageTimes('homEncMult10',  'homEncMult10-input',  'powersOfTau28_hez_final_15', 'groth16', 10);
averageTimes('homEncMult20',  'homEncMult20-input',  'powersOfTau28_hez_final_16', 'groth16', 10);
averageTimes('homEncMult30',  'homEncMult30-input',  'powersOfTau28_hez_final_17', 'groth16', 10);
averageTimes('homEncMult40',  'homEncMult40-input',  'powersOfTau28_hez_final_17', 'groth16', 10);
averageTimes('homEncMult50',  'homEncMult50-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('homEncMult60',  'homEncMult60-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('homEncMult70',  'homEncMult70-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('homEncMult80',  'homEncMult80-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('homEncMult90',  'homEncMult90-input',  'powersOfTau28_hez_final_19', 'groth16', 10);
averageTimes('homEncMult100', 'homEncMult100-input', 'powersOfTau28_hez_final_19', 'groth16', 10);

averageTimes('re-RandMult10',  're-RandMult10-input',  'powersOfTau28_hez_final_15', 'groth16', 10);
averageTimes('re-RandMult20',  're-RandMult20-input',  'powersOfTau28_hez_final_16', 'groth16', 10);
averageTimes('re-RandMult30',  're-RandMult30-input',  'powersOfTau28_hez_final_17', 'groth16', 10);
averageTimes('re-RandMult40',  're-RandMult40-input',  'powersOfTau28_hez_final_17', 'groth16', 10);
averageTimes('re-RandMult50',  're-RandMult50-input',  'powersOfTau28_hez_final_17', 'groth16', 10);
averageTimes('re-RandMult60',  're-RandMult60-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('re-RandMult70',  're-RandMult70-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('re-RandMult80',  're-RandMult80-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('re-RandMult90',  're-RandMult90-input',  'powersOfTau28_hez_final_18', 'groth16', 10);
averageTimes('re-RandMult100', 're-RandMult100-input', 'powersOfTau28_hez_final_18', 'groth16', 10);