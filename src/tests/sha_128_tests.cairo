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
    let mut inner: usize = 16;
    loop {
        if inner == 64_usize {
            break ();
        }
        let sigma_1 = (*(joined_bytes[inner - 15_usize])).rr_7()
            ^ (*(joined_bytes[inner - 15_usize])).rr_18()
            ^ ((*(joined_bytes[inner - 15_usize])) / 0x8_u128);
        let sigma_2 = (*(joined_bytes[inner - 2_usize])).rr_17()
            ^ (*(joined_bytes[inner - 2_usize])).rr_19()
            ^ ((*(joined_bytes[inner - 2_usize])) / 0x400_u128);
        joined_bytes
            .append(
                (*(joined_bytes[inner - 16_usize]))
                    .wrapping_add(
                        sigma_1
                            .wrapping_add((*(joined_bytes[inner - 7_usize])).wrapping_add(sigma_2))
                    )
            );
        inner = inner + 1;
    };

    inner = 0_usize;
    let round_constants = load_round_constants();
    loop {
        if inner == 64_usize {
            break ();
        }
        let sigma_1 = (*(working_hash[3])).rr_6()
            ^ (*(working_hash[3])).rr_11()
            ^ (*(working_hash[3])).rr_25();
        let choice = (*working_hash[3] & *working_hash[2])
            ^ ((BitNot::bitnot(*working_hash[3])) & *working_hash[1]);
        let temp_1 = ((*working_hash[0]))
            .wrapping_add(
                sigma_1
                    .wrapping_add(
                        choice
                            .wrapping_add(
                                (*round_constants[inner]).wrapping_add(*joined_bytes[inner])
                            ),
                    )
            );

        let sigma_0 = (*(working_hash[7])).rr_2()
            ^ (*(working_hash[7])).rr_13()
            ^ (*(working_hash[7])).rr_22();
        let majority = (*working_hash[7] & *working_hash[6])
            ^ (*working_hash[7] & *working_hash[5])
            ^ (*working_hash[6] & *working_hash[5]);
        let temp_2 = sigma_0.wrapping_add(majority);

        working_hash.pop_front();
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append((*working_hash[0]).wrapping_add(temp_1));
        working_hash.pop_front();
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(working_hash.pop_front().unwrap());
        working_hash.append(temp_1.wrapping_add(temp_2));

        inner = inner + 1;
    };

    let mut output = ArrayTrait::<felt252>::new();
    inner = 7_usize;
    loop {
        if inner == 0_usize {
            output.append(((*hash_values[inner]).wrapping_add(*working_hash[inner])).into());
            break ();
        }
        output.append(((*hash_values[inner]).wrapping_add(*working_hash[inner])).into());

        inner = inner - 1;
    };
}

fn load_round_constants() -> Array<u128> {
    let mut round_constants_array = ArrayTrait::new();
    round_constants_array.append(0x428a2f98);
    round_constants_array.append(0x71374491);
    round_constants_array.append(0xb5c0fbcf);
    round_constants_array.append(0xe9b5dba5);
    round_constants_array.append(0x3956c25b);
    round_constants_array.append(0x59f111f1);
    round_constants_array.append(0x923f82a4);
    round_constants_array.append(0xab1c5ed5);
    round_constants_array.append(0xd807aa98);
    round_constants_array.append(0x12835b01);
    round_constants_array.append(0x243185be);
    round_constants_array.append(0x550c7dc3);
    round_constants_array.append(0x72be5d74);
    round_constants_array.append(0x80deb1fe);
    round_constants_array.append(0x9bdc06a7);
    round_constants_array.append(0xc19bf174);
    round_constants_array.append(0xe49b69c1);
    round_constants_array.append(0xefbe4786);
    round_constants_array.append(0x0fc19dc6);
    round_constants_array.append(0x240ca1cc);
    round_constants_array.append(0x2de92c6f);
    round_constants_array.append(0x4a7484aa);
    round_constants_array.append(0x5cb0a9dc);
    round_constants_array.append(0x76f988da);
    round_constants_array.append(0x983e5152);
    round_constants_array.append(0xa831c66d);
    round_constants_array.append(0xb00327c8);
    round_constants_array.append(0xbf597fc7);
    round_constants_array.append(0xc6e00bf3);
    round_constants_array.append(0xd5a79147);
    round_constants_array.append(0x06ca6351);
    round_constants_array.append(0x14292967);
    round_constants_array.append(0x27b70a85);
    round_constants_array.append(0x2e1b2138);
    round_constants_array.append(0x4d2c6dfc);
    round_constants_array.append(0x53380d13);
    round_constants_array.append(0x650a7354);
    round_constants_array.append(0x766a0abb);
    round_constants_array.append(0x81c2c92e);
    round_constants_array.append(0x92722c85);
    round_constants_array.append(0xa2bfe8a1);
    round_constants_array.append(0xa81a664b);
    round_constants_array.append(0xc24b8b70);
    round_constants_array.append(0xc76c51a3);
    round_constants_array.append(0xd192e819);
    round_constants_array.append(0xd6990624);
    round_constants_array.append(0xf40e3585);
    round_constants_array.append(0x106aa070);
    round_constants_array.append(0x19a4c116);
    round_constants_array.append(0x1e376c08);
    round_constants_array.append(0x2748774c);
    round_constants_array.append(0x34b0bcb5);
    round_constants_array.append(0x391c0cb3);
    round_constants_array.append(0x4ed8aa4a);
    round_constants_array.append(0x5b9cca4f);
    round_constants_array.append(0x682e6ff3);
    round_constants_array.append(0x748f82ee);
    round_constants_array.append(0x78a5636f);
    round_constants_array.append(0x84c87814);
    round_constants_array.append(0x8cc70208);
    round_constants_array.append(0x90befffa);
    round_constants_array.append(0xa4506ceb);
    round_constants_array.append(0xbef9a3f7);
    round_constants_array.append(0xc67178f2);
    round_constants_array
}
