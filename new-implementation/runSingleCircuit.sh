# set circuit and input
circuit='doubleAndAddAny'
input='doubleAndAddAny-input'
potFile='powersOfTau28_hez_final_17'

# set up proof
circom "./single-circuits/$circuit".circom --r1cs --wasm
cd ./"$circuit"_js
snarkjs groth16 setup "../$circuit".r1cs "../potFiles/$potFile".ptau "$circuit"_0000.zkey
snarkjs zkey contribute "$circuit"_0000.zkey "$circuit"_0001.zkey --name="1st Contributor Name" -e="e"
# snarkjs plonk setup "../$circuit".r1cs "../potFiles/$potFile".ptau "$circuit"_0001.zkey
snarkjs zkey export verificationkey "$circuit"_0001.zkey verification_key.json

# generate proof
node generate_witness.js "$circuit".wasm "../single-circuits-inputs/$input".json witness.wtns
snarkjs groth16 prove "$circuit"_0001.zkey witness.wtns proof.json public.json
# snarkjs plonk prove "$circuit"_0001.zkey witness.wtns proof.json public.json

# verify proof
snarkjs groth16 verify verification_key.json public.json proof.json
# snarkjs plonk verify verification_key.json public.json proof.json