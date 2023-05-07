use serde::Serde;
use traits::Into;
use sha::sha::sha_u128::SHA_func;
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
#[ignore]
#[available_gas(1000000000)]
fn test_less_than_512_bits() {
    let mut input = ArrayTrait::new();
    input.append(0x73746172);
    input.append(0x6B6E6574);
    input.append(0x80000000);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x40);
    let mut output = SHA_func(input);
    assert(*output[0] == 4246238833, 'final_hash_0_index check');
    assert(*output[1] == 2715154529, 'final_hash_1_index check');
    assert(*output[2] == 3111545146, 'final_hash_2_index check');
    assert(*output[3] == 2523928951, 'final_hash_3_index check');
    assert(*output[4] == 2343742124, 'final_hash_4_index check');
    assert(*output[5] == 816016193, 'final_hash_5_index check');
    assert(*output[6] == 2467408739, 'final_hash_6_index check');
    assert(*output[7] == 3342985673, 'final_hash_7_index check');
}
#[test]
#[available_gas(1000000000)]
fn test_more_than_512_bits() {
    // append 48 32 bits
    let mut input = ArrayTrait::new();
    input.append(0x43616972);
    input.append(0x6F206973);
    input.append(0x20746865);
    input.append(0x20666972);
    input.append(0x73742054);
    input.append(0x7572696E);
    input.append(0x672D636F);
    input.append(0x6D706C65);
    input.append(0x7465206C);
    input.append(0x616E6775);
    input.append(0x61676520);
    input.append(0x666F7220);
    input.append(0x63726561);
    input.append(0x74696E67);
    input.append(0x2070726F);
    input.append(0x7661626C);
    // 16 32 bits
    input.append(0x65207072);
    input.append(0x6F677261);
    input.append(0x6D732066);
    input.append(0x6F722067);
    input.append(0x656E6572);
    input.append(0x616C2063);
    input.append(0x6F6D7075);
    input.append(0x74617469);
    input.append(0x6F6E2E80);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x318);
    let mut output = SHA_func(input);
    assert(*output[0] == 2541875948, 'final_hash_0_index check');
    assert(*output[1] == 3479205334, 'final_hash_1_index check');
    assert(*output[2] == 2534622915, 'final_hash_2_index check');
    assert(*output[3] == 1021255763, 'final_hash_3_index check');
    assert(*output[4] == 2026962479, 'final_hash_4_index check');
    assert(*output[5] == 1611312724, 'final_hash_5_index check');
    assert(*output[6] == 2207786822, 'final_hash_6_index check');
    assert(*output[7] == 3523740160, 'final_hash_7_index check');
}
