use serde::Serde;
use traits::Into;
use sha::sha::sha_u128::U128Bit32Operations;
use sha::sha::sha_traits::SHABitOperations;
use traits::BitNot;
use debug::PrintTrait;
use array::ArrayTrait;
use testing::get_available_gas;
use box::BoxTrait;
use option::OptionTrait;
use clone::Clone;

#[test]
#[available_gas(100000000)]
fn prepare_message_schedule() {
    let mut hash_values = ArrayTrait::<u128>::new();
    // 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
    hash_values.append(0x5be0cd19);
    hash_values.append(0x1f83d9ab);
    hash_values.append(0x9b05688c);
    hash_values.append(0x510e527f);
    hash_values.append(0xa54ff53a);
    hash_values.append(0x3c6ef372);
    hash_values.append(0xbb67ae85);
    hash_values.append(0x6a09e667);
    let mut working_hash = ArrayTrait::<u128>::new();
    working_hash = hash_values.clone();
    // append 48 32 bits
    let mut joined_bytes = ArrayTrait::<u128>::new();
    // starknet predefined
    joined_bytes.append(0x73746172);
    joined_bytes.append(0x6B776172);
    joined_bytes.append(0x65206361);
    joined_bytes.append(0x69726F31);
    joined_bytes.append(0x80000000);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x0);
    joined_bytes.append(0x80);
    // end harcoded
    let mut index: usize = 16;
    get_available_gas().print();
    loop {
        if index == 64_usize {
            break ();
        }
        let sigma_1 = (*(joined_bytes[index - 15_usize])).rr_7()
            ^ (*(joined_bytes[index - 15_usize])).rr_18()
            ^ ((*(joined_bytes[index - 15_usize])) / 0x8_u128);
        let sigma_2 = (*(joined_bytes[index - 2_usize])).rr_17()
            ^ (*(joined_bytes[index - 2_usize])).rr_19()
            ^ ((*(joined_bytes[index - 2_usize])) / 0x400_u128);
        joined_bytes
            .append(
                (*(joined_bytes[index - 16_usize]))
                    .wrapping_add(
                        sigma_1
                            .wrapping_add((*(joined_bytes[index - 7_usize])).wrapping_add(sigma_2))
                    )
            );
        index = index + 1;
    };
    get_available_gas().print();
    assert(*joined_bytes.at(16) == 0xA558F9A3_u128, '16_index check');
    assert(*joined_bytes.at(17) == 0x427D7754_u128, '17_index check');
    assert(*joined_bytes.at(18) == 0xBD1E46FE_u128, '18_index check');
    assert(*joined_bytes.at(19) == 0x8FC2C55D_u128, '19_index check');
    assert(*joined_bytes.at(20) == 0x6B8FCEBD_u128, '20_index check');
    assert(*joined_bytes.at(21) == 0x3A2686A8_u128, '21_index check');
    assert(*joined_bytes.at(22) == 0x1E93FBC5_u128, '22_index check');
    assert(*joined_bytes.at(23) == 0x38E88D99_u128, '23_index check');
    assert(*joined_bytes.at(24) == 0xC51AFFB9_u128, '24_index check');
    assert(*joined_bytes.at(25) == 0x148FC848_u128, '25_index check');
    assert(*joined_bytes.at(26) == 0xAFDD61EE_u128, '26_index check');
    assert(*joined_bytes.at(27) == 0x88B7F9E1_u128, '27_index check');
    assert(*joined_bytes.at(33) == 0x6EC35E92_u128, '33_index check');
    assert(*joined_bytes.at(34) == 0x268D8D13_u128, '34_index check');
    assert(*joined_bytes.at(35) == 0x2F554869_u128, '35_index check');
    assert(*joined_bytes.at(36) == 0xFBCF8B7A_u128, '36_index check');
    assert(*joined_bytes.at(37) == 0xFA115B2C_u128, '37_index check');
    assert(*joined_bytes.at(38) == 0xCCEB5941_u128, '38_index check');
    assert(*joined_bytes.at(39) == 0xBA69B1B6_u128, '39_index check');
    assert(*joined_bytes.at(40) == 0x5C452743_u128, '40_index check');
    assert(*joined_bytes.at(41) == 0xBAC02279_u128, '41_index check');
    assert(*joined_bytes.at(42) == 0x4311721C_u128, '42_index check');
    assert(*joined_bytes.at(43) == 0xB89884D3_u128, '43_index check');
    assert(*joined_bytes.at(44) == 0x29821C5E_u128, '44_index check');
    assert(*joined_bytes.at(45) == 0x5CE16EE9_u128, '45_index check');
    assert(*joined_bytes.at(46) == 0x73A989F3_u128, '46_index check');
    assert(*joined_bytes.at(47) == 0xA4BE66D0_u128, '47_index check');
    assert(*joined_bytes.at(48) == 0xD52979CE_u128, '48_index check');
    assert(*joined_bytes.at(49) == 0xF3489D1A_u128, '49_index check');
    assert(*joined_bytes.at(50) == 0xF8C0549D_u128, '50_index check');
    assert(*joined_bytes.at(51) == 0xBE3B2B3B_u128, '51_index check');
    assert(*joined_bytes.at(52) == 0x8A11A527_u128, '52_index check');
    assert(*joined_bytes.at(53) == 0xAAE4D9CF_u128, '53_index check');
    assert(*joined_bytes.at(54) == 0x6E13BC03_u128, '54_index check');
    assert(*joined_bytes.at(55) == 0x4C68BE53_u128, '55_index check');
    assert(*joined_bytes.at(56) == 0xE5DC0D3C_u128, '56_index check');
    assert(*joined_bytes.at(57) == 0x68D4690F_u128, '57_index check');
    assert(*joined_bytes.at(58) == 0x19A40662_u128, '58_index check');
    assert(*joined_bytes.at(59) == 0x3ADB6437_u128, '59_index check');
    assert(*joined_bytes.at(60) == 0xDB01D54C_u128, '60_index check');
    assert(*joined_bytes.at(61) == 0x3477B6A2_u128, '61_index check');
    assert(*joined_bytes.at(62) == 0xBCB61813_u128, '62_index check');
    assert(*joined_bytes.at(63) == 0x919F7DE4_u128, '63_index check');
    get_available_gas().print();

    let mut index: usize = 0;
    let round_constants = get_k();
    loop {
        if index == 64_usize {
            break ();
        }
        let sigma_1 = (*(working_hash[7 - 4])).rr_6()
            ^ (*(working_hash[7 - 4])).rr_11()
            ^ (*(working_hash[7 - 4])).rr_25();
        let choice = (*working_hash[7 - 4] & *working_hash[7 - 5])
            ^ ((BitNot::bitnot(*working_hash[7 - 4])) & *working_hash[7 - 6]);
        let temp_1 = ((*working_hash[7 - 7]))
            .wrapping_add(
                sigma_1
                    .wrapping_add(
                        choice
                            .wrapping_add(
                                (*round_constants[index]).wrapping_add(*joined_bytes[index])
                            ),
                    )
            );

        let sigma_0 = (*(working_hash[7 - 0])).rr_2()
            ^ (*(working_hash[7 - 0])).rr_13()
            ^ (*(working_hash[7 - 0])).rr_22();
        let majority = (*working_hash[7 - 0] & *working_hash[7 - 1])
            ^ (*working_hash[7 - 0] & *working_hash[7 - 2])
            ^ (*working_hash[7 - 1] & *working_hash[7 - 2]);
        let temp_2 = sigma_0.wrapping_add(majority);
        // assert(sigma_1 == 0x3587272B, 'sigma_1 check');
        // assert(choice == 0x1F85C98C, 'choice check');
        // assert(temp_1 == 0x66EC4EDA, 'temp_1');
        // assert(sigma_0 == 0xCE20B47E, 'sigma_0');
        // assert(majority == 0x3A6FE667, 'majority');
        // assert(temp_2 == 0x8909AE5, 'temp_2');

        working_hash.pop_front();
        // gas::withdraw_gas_all(gas::BuiltinCosts).expect('Out of gas');
        gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');
        // (*working_hash.at(0)).print();
        // working_hash.len().print();

        // assert(*working_hash.at(0) == 528734635, 'working_hash_0_index check');
        // assert(*working_hash.at(1) == 2600822924, 'working_hash_1_index check');
        // assert(*working_hash.at(2) == 1359893119, 'working_hash_2_index check');
        // assert(*working_hash.at(3) == 2773480762, 'working_hash_3_index check');
        // assert(*working_hash.at(4) == 1013904242, 'working_hash_4_index check');
        // assert(*working_hash.at(5) == 3144134277, 'working_hash_5_index check');
        // assert(*working_hash.at(6) == 1779033703, 'working_hash_6_index check');
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());

        // (*working_hash[7 - 2]).wrapping_add(temp_1).print();
        // (*working_hash[7 - 3]).wrapping_add(temp_1).print();
        // (*working_hash[7 - 5]).wrapping_add(temp_1).print();
        // (*working_hash[7 - 6]).wrapping_add(temp_1).print();
        // (*working_hash[7 - 7]).wrapping_add(temp_1).print();
        gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');

        working_hash.append((*working_hash[7 - 7]).wrapping_add(temp_1));
        working_hash.pop_front();
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(temp_1.wrapping_add(temp_2));

        // (*working_hash.at(3)).print();
        // assert(*working_hash.at(0) == 528734635, 'working_hash_0_index check');
        // assert(*working_hash.at(1) == 2600822924, 'working_hash_1_index check');
        // assert(*working_hash.at(2) == 1359893119, 'working_hash_2_index check');
        // assert(*working_hash.at(3) == 205276180, 'working_hash_3_index check');
        // assert(*working_hash.at(4) == 1013904242, 'working_hash_4_index check');
        // assert(*working_hash.at(5) == 3144134277, 'working_hash_5_index check');
        // assert(*working_hash.at(6) == 1779033703, 'working_hash_6_index check');
        // assert(*working_hash.at(7) == 1870457279, 'working_hash_7_index check');

        index = index + 1;
    };

    // let mut sd = ArrayTrait::<felt252>::new();
    // working_hash.serialize(ref sd);
    // sd.print();

    assert(*working_hash.at(0) == 3279359735, 'working_hash_0_index check');
    assert(*working_hash.at(1) == 3401733292, 'working_hash_1_index check');
    assert(*working_hash.at(2) == 2951321243, 'working_hash_2_index check');
    assert(*working_hash.at(3) == 21222273, 'working_hash_3_index check');
    assert(*working_hash.at(4) == 2186331948, 'working_hash_4_index check');
    assert(*working_hash.at(5) == 2524738497, 'working_hash_5_index check');
    assert(*working_hash.at(6) == 3660659799, 'working_hash_6_index check');
    assert(*working_hash.at(7) == 2553025654, 'working_hash_7_index check');

    get_available_gas().print();

    testing::get_available_gas().print();
    gas::withdraw_gas_all(get_builtin_costs()).expect('Out of gas');

    let mut output = ArrayTrait::<felt252>::new();

    let mut index = 7_usize;
    loop {
        if index == 0_usize {
            output.append(((*hash_values[index]).wrapping_add(*working_hash[index])).into());
            break ();
        }
        output.append(((*hash_values[index]).wrapping_add(*working_hash[index])).into());

        index = index - 1;
    };
    

    // let mut sd = ArrayTrait::<felt252>::new();
    // output.serialize(ref sd);
    // sd.print();
    // output.print();

    assert(*output[0] == 37092061, 'final_hash_0_index check');
    assert(*output[1] == 2509826780, 'final_hash_1_index check');
    assert(*output[2] == 3538642739, 'final_hash_2_index check');
    assert(*output[3] == 664845414, 'final_hash_3_index check');
    assert(*output[4] == 1381115392, 'final_hash_4_index check');
    assert(*output[5] == 1257176871, 'final_hash_5_index check');
    assert(*output[6] == 3930467927, 'final_hash_6_index check');
    assert(*output[7] == 525851664, 'final_hash_7_index check');
}

fn get_k() -> Array<u128> {
    let mut k = ArrayTrait::new();
    k.append(0x428a2f98);
    k.append(0x71374491);
    k.append(0xb5c0fbcf);
    k.append(0xe9b5dba5);
    k.append(0x3956c25b);
    k.append(0x59f111f1);
    k.append(0x923f82a4);
    k.append(0xab1c5ed5);
    k.append(0xd807aa98);
    k.append(0x12835b01);
    k.append(0x243185be);
    k.append(0x550c7dc3);
    k.append(0x72be5d74);
    k.append(0x80deb1fe);
    k.append(0x9bdc06a7);
    k.append(0xc19bf174);
    k.append(0xe49b69c1);
    k.append(0xefbe4786);
    k.append(0x0fc19dc6);
    k.append(0x240ca1cc);
    k.append(0x2de92c6f);
    k.append(0x4a7484aa);
    k.append(0x5cb0a9dc);
    k.append(0x76f988da);
    k.append(0x983e5152);
    k.append(0xa831c66d);
    k.append(0xb00327c8);
    k.append(0xbf597fc7);
    k.append(0xc6e00bf3);
    k.append(0xd5a79147);
    k.append(0x06ca6351);
    k.append(0x14292967);
    k.append(0x27b70a85);
    k.append(0x2e1b2138);
    k.append(0x4d2c6dfc);
    k.append(0x53380d13);
    k.append(0x650a7354);
    k.append(0x766a0abb);
    k.append(0x81c2c92e);
    k.append(0x92722c85);
    k.append(0xa2bfe8a1);
    k.append(0xa81a664b);
    k.append(0xc24b8b70);
    k.append(0xc76c51a3);
    k.append(0xd192e819);
    k.append(0xd6990624);
    k.append(0xf40e3585);
    k.append(0x106aa070);
    k.append(0x19a4c116);
    k.append(0x1e376c08);
    k.append(0x2748774c);
    k.append(0x34b0bcb5);
    k.append(0x391c0cb3);
    k.append(0x4ed8aa4a);
    k.append(0x5b9cca4f);
    k.append(0x682e6ff3);
    k.append(0x748f82ee);
    k.append(0x78a5636f);
    k.append(0x84c87814);
    k.append(0x8cc70208);
    k.append(0x90befffa);
    k.append(0xa4506ceb);
    k.append(0xbef9a3f7);
    k.append(0xc67178f2);
    k
}
