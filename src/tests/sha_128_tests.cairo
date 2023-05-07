use serde::Serde;
use traits::Into;
use sha::sha::sha_u128::U128Bit32Operations;
use sha::sha::sha_traits::SHABitOperations;
use sha::sha::sha_constants::load_round_constants;
use traits::BitNot;
use debug::PrintTrait;
use array::ArrayTrait;
use testing::get_available_gas;
use box::BoxTrait;
use option::OptionTrait;
use clone::Clone;

#[test]
#[available_gas(1000000000)]
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
    // append 48 32 bits
    let mut bytes = ArrayTrait::<u128>::new();
    bytes.append(0x73746172_u128);
    bytes.append(0x6B6E6574_u128);
    bytes.append(0x80000000_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x0_u128);
    bytes.append(0x40_u128);
    // end harcoded
    let mut working_hash = ArrayTrait::<u128>::new();
    working_hash = hash_values.clone();
    assert(bytes.len() % 16_usize == 0, 'byteslen != 16*8 bytes multiple');
    let loop_until = bytes.len() / 16_usize;

    let mut outer: usize = 0;
    loop {
        if outer == loop_until {
            assert(bytes.len() == 0, 'bytes_pop_check');
            break ();
        }

        outer.print();
        // had to do this since loop MOVES bytes inside
        let mut joined_bytes = ArrayTrait::<u128>::new();
        // joined_bytes = bytes.clone();
        // had to do this since loop MOVES bytes inside
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        joined_bytes.append(bytes.pop_front().unwrap());
        assert(joined_bytes.len() == 16, 'length check');
        let mut index: usize = 16;
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
                                .wrapping_add(
                                    (*(joined_bytes[index - 7_usize])).wrapping_add(sigma_2)
                                )
                        )
                );
            index = index + 1;
        };

        index = 0_usize;
        let round_constants = load_round_constants();
        loop {
            if index == 64_usize {
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
                                    (*round_constants[index]).wrapping_add(*joined_bytes[index])
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

            index = index + 1;
        };

        working_hash.append(((*hash_values[0]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[1]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[2]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[3]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[4]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[5]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[6]).wrapping_add(working_hash.pop_front().unwrap())));
        working_hash.append(((*hash_values[7]).wrapping_add(working_hash.pop_front().unwrap())));
        outer = outer + 1_usize;
    };

    (*working_hash.at(0)).print();
    let mut output = ArrayTrait::<felt252>::new();

    let mut index = 7_usize;
    loop {
        if index == 0_usize {
            output.append((*working_hash[index]).into());
            break ();
        }
        output.append((*working_hash[index]).into());

        index = index - 1;
    };
    output.print();
// assert(*output[0] == 2541875948, 'final_hash_0_index check');
// assert(*output[1] == 3479205334, 'final_hash_1_index check');
// assert(*output[2] == 2534622915, 'final_hash_2_index check');
// assert(*output[3] == 1021255763, 'final_hash_3_index check');
// assert(*output[4] == 2026962479, 'final_hash_4_index check');
// assert(*output[5] == 1611312724, 'final_hash_5_index check');
// assert(*output[6] == 2207786822, 'final_hash_6_index check');
// assert(*output[7] == 3523740160, 'final_hash_7_index check');
}
// output.append((*working_hash[7]).into());
// output.append((*working_hash[6]).into());
// output.append((*working_hash[5]).into());
// output.append((*working_hash[4]).into());
// output.append((*working_hash[3]).into());
// output.append((*working_hash[2]).into());
// output.append((*working_hash[1]).into());
// output.append((*working_hash[0]).into());

// bytes.append(0x43616972_u128);
// bytes.append(0x6F206973_u128);
// bytes.append(0x20746865_u128);
// bytes.append(0x20666972_u128);
// bytes.append(0x73742054_u128);
// bytes.append(0x7572696E_u128);
// bytes.append(0x672D636F_u128);
// bytes.append(0x6D706C65_u128);
// bytes.append(0x7465206C_u128);
// bytes.append(0x616E6775_u128);
// bytes.append(0x61676520_u128);
// bytes.append(0x666F7220_u128);
// bytes.append(0x63726561_u128);
// bytes.append(0x74696E67_u128);
// bytes.append(0x2070726F_u128);
// bytes.append(0x7661626C_u128);
// bytes.append(0x65207072_u128);
// bytes.append(0x6F677261_u128);
// bytes.append(0x6D732066_u128);
// bytes.append(0x6F722067_u128);
// bytes.append(0x656E6572_u128);
// bytes.append(0x616C2063_u128);
// bytes.append(0x6F6D7075_u128);
// bytes.append(0x74617469_u128);
// bytes.append(0x6F6E2E80_u128);
// bytes.append(0x0_u128);
// bytes.append(0x0_u128);
// bytes.append(0x0_u128);
// bytes.append(0x0_u128);
// bytes.append(0x0_u128);
// bytes.append(0x0_u128);
// bytes.append(0x318_u128);


