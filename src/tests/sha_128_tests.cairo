use zeroable::IsZeroResult;
use zeroable::Zeroable;
use clone::Clone;
use dict::Felt252DictTrait;
use sha::sha::sha_128::U128SHAOperations;
// use sha::sha::sha_128;
use sha::sha::sha_traits::SHAOperations;
// use sha::sha::sha_traits;
use debug::PrintTrait;
use integer::BoundedInt;
use array::ArrayTrait;
use array::SpanTrait;
use traits::Into;

#[test]
#[available_gas(100000000)]
fn prepare_message_schedule() {
    let mut hash_values = ArrayTrait::new();
    // 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
    hash_values.append(0x5be0cd19_u128);
    hash_values.append(0x1f83d9ab_u128);
    hash_values.append(0x9b05688c_u128);
    hash_values.append(0x510e527f_u128);
    hash_values.append(0xa54ff53a_u128);
    hash_values.append(0x3c6ef372_u128);
    hash_values.append(0xbb67ae85_u128);
    hash_values.append(0x6a09e667_u128);
    let mut working_hash = ArrayTrait::new();
    // 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
    working_hash.append(0x5be0cd19_u128);
    working_hash.append(0x1f83d9ab_u128);
    working_hash.append(0x9b05688c_u128);
    working_hash.append(0x510e527f_u128);
    working_hash.append(0xa54ff53a_u128);
    working_hash.append(0x3c6ef372_u128);
    working_hash.append(0xbb67ae85_u128);
    working_hash.append(0x6a09e667_u128);

    // append 48 32 bits
    let mut joined_bytes = ArrayTrait::new();
    // starknet predefined
    joined_bytes.append(0x73746172_u128);
    joined_bytes.append(0x6B6E6574_u128);
    joined_bytes.append(0x80000000_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x0_u128);
    joined_bytes.append(0x40_u128);
    // end harcoded
    joined_bytes.len().print();
    // message loop
    let mut index: usize = 16;
    // let mut tmp: u128 = 0_u128;
    // let mut sigma_1: u128 = 0_u128;
    // let mut sigma_2: u128 = 0_u128;
    loop {
        if index == 64_usize {
            break ();
        }

        // joined_bytes.append(
        // (*(joined_bytes.at(
        let sigma_1 = (*(joined_bytes[index - 15_usize])).rr_7()
            ^ (*(joined_bytes[index - 15_usize])).rr_18()
            ^ ((*(joined_bytes[index - 15_usize])) / 0x8_u128);
        let sigma_2 = (*(joined_bytes[index - 2_usize])).rr_17()
            ^ (*(joined_bytes[index - 2_usize])).rr_19()
            ^ ((*(joined_bytes[index - 2_usize])) / 0x400_u128);
        // tmp =
        joined_bytes
            .append(
                (*(joined_bytes[index - 16_usize]))
                    .wrapping_add(
                        sigma_1
                            .wrapping_add((*(joined_bytes[index - 7_usize])).wrapping_add(sigma_2))
                    )
            );
        // joined_bytes.append(tmp);
        index = index + 1;
    };
    //message loop end

    joined_bytes.len().print();
    assert(*joined_bytes[16] == 0xF05A6C31_u128, '16_index check');
    assert(*joined_bytes[17] == 0x7C968574_u128, '17_index check');
    assert(*joined_bytes[18] == 0xFBA2D0BD_u128, '18_index check');
    assert(*joined_bytes[19] == 0x920B9478_u128, '19_index check');
    assert(*joined_bytes[20] == 0x3277AA11_u128, '20_index check');
    assert(*joined_bytes[21] == 0xB897D9A1_u128, '21_index check');
    assert(*joined_bytes[22] == 0x204622DF_u128, '22_index check');
    assert(*joined_bytes[23] == 0x8253AE0_u128, '23_index check');
    assert(*joined_bytes[24] == 0x51D2EB17_u128, '24_index check');
    assert(*joined_bytes[25] == 0x35D0DD15_u128, '25_index check');
    assert(*joined_bytes[26] == 0xBB08CAE1_u128, '26_index check');
    assert(*joined_bytes[27] == 0xA79CF276_u128, '27_index check');
    assert(*joined_bytes[28] == 0x349A0278_u128, '28_index check');
    assert(*joined_bytes[29] == 0x7A282E0_u128, '29_index check');
    assert(*joined_bytes[30] == 0xC9B37546_u128, '30_index check');
    assert(*joined_bytes[31] == 0x49E85C24_u128, '31_index check');
    assert(*joined_bytes[32] == 0x409BFCF9_u128, '32_index check');
    assert(*joined_bytes[33] == 0x2DD08991_u128, '33_index check');
    assert(*joined_bytes[34] == 0x2BAEB2F9_u128, '34_index check');
    assert(*joined_bytes[35] == 0xEB45B4EB_u128, '35_index check');
    assert(*joined_bytes[36] == 0x6B4F42A1_u128, '36_index check');
    assert(*joined_bytes[37] == 0x221D289D_u128, '37_index check');
    assert(*joined_bytes[38] == 0x42F9B941_u128, '38_index check');
    assert(*joined_bytes[39] == 0x187316A0_u128, '39_index check');
    assert(*joined_bytes[40] == 0x86D0A361_u128, '40_index check');
    assert(*joined_bytes[41] == 0x31B10A0B_u128, '41_index check');
    assert(*joined_bytes[42] == 0xB16CD5B3_u128, '42_index check');
    assert(*joined_bytes[43] == 0x2D994130_u128, '43_index check');
    assert(*joined_bytes[44] == 0xA73E3574_u128, '44_index check');
    assert(*joined_bytes[45] == 0x1D466B7E_u128, '45_index check');
    assert(*joined_bytes[46] == 0x150B5E21_u128, '46_index check');
    assert(*joined_bytes[47] == 0xCF3CB456_u128, '47_index check');
    assert(*joined_bytes[48] == 0x3CA4ED4C_u128, '48_index check');
    assert(*joined_bytes[49] == 0x76C9269_u128, '49_index check');
    assert(*joined_bytes[50] == 0xEBCD6C4B_u128, '50_index check');
    assert(*joined_bytes[51] == 0xD138EE0_u128, '51_index check');
    assert(*joined_bytes[52] == 0x184D01A8_u128, '52_index check');
    assert(*joined_bytes[53] == 0xD2625F6A_u128, '53_index check');
    assert(*joined_bytes[54] == 0xB9B40CEB_u128, '54_index check');
    assert(*joined_bytes[55] == 0xB4948474_u128, '55_index check');
    assert(*joined_bytes[56] == 0x68DB8BF2_u128, '56_index check');
    assert(*joined_bytes[57] == 0x343C0F95_u128, '57_index check');
    assert(*joined_bytes[58] == 0xA8C1C5E9_u128, '58_index check');
    assert(*joined_bytes[59] == 0x3D10097D_u128, '59_index check');
    assert(*joined_bytes[60] == 0xB9522CCF_u128, '60_index check');
    assert(*joined_bytes[61] == 0x739C2DCB_u128, '61_index check');
    assert(*joined_bytes[62] == 0xB6DCBDCA_u128, '62_index check');
    assert(*joined_bytes[63] == 0x70174C58_u128, '63_index check');
// tmp =
//     (*(joined_bytes[index
//         - 16_usize])).wrapping_add(
//             (*(joined_bytes[index
//                 - 15_usize])).rr_7() ^ (*(joined_bytes[index
//                     - 15_usize])).rr_18() ^ ((*(joined_bytes[index - 15_usize]))
//                         / 0x8_u128).wrapping_add(
//                             (*(joined_bytes[index
//                                 - 7_usize])).wrapping_add(
//                                     (*(joined_bytes[index
//                                         - 2_usize])).rr_17() ^ (*(joined_bytes[index
//                                             - 2_usize])).rr_19() ^ ((*(joined_bytes[index
//                                                 - 2_usize]))
//                                                 / 0x400_u128)
//                                 )
//                         )
//         // )
//         );
// let mut a = ArrayTrait::new();
// a.append(1);
// a.append(2);
// a.append(3);
// a.append(4);
// a.append(5);
// a.append(1);
// a.clone().print();
// a.append(1);
// a.clone().print();
// a.pop_front();
// a.clone().print();
// a.append(16);
// a.clone().print();
// a.append(0xFF_u128);
// let tmp: u128 = ((*a.at(
//     0
// )).gamma_1()).wrapping_add(*a.at(0)).wrapping_add(*a.at(0)).wrapping_add(*a.at(0));
// a.append(tmp);
// (*(a.at(1))).print();
// (*(a.at(0))).print();
// let mut b = Felt252DictTrait::new();
// b.insert(1, 1_u128);
// b.insert(1, 16_u128);
// b.insert(2, 2_u128);
// b.get(2).print();
// b.get(1).print();
// b.insert(1, 32_u128);
// b.get(1).print();
// let z: NonZero = 252.into();
// let z: IsZeroResult::NonZero<u8> = 7.into();
// let mut c = Felt252DictTrait::<u128>::new();
// let tmp = (c.get(
//     14
// ).gamma_1()).wrapping_add(c.get(13)).wrapping_add(c.get(2).gamma_0()).wrapping_add(c.get(0));
// c.insert(16, tmp);
// c.get(16).print();
// c.insert(1, 1_u128);
}
#[test]
#[ignore]
fn shift_right() {
    assert(U128SHAOperations::rr_2(0xABCDEF12_u128) == 0xAAF37BC4_u128, 'rr_2 failed');
    assert(0xABCDEF13_u128.rr_2() == 0xEAF37BC4_u128, 'rr_2');
    assert(0xABCDEF13_u128.rr_6() == 0x4EAF37BC_u128, 'rr_6');
    assert(0xABCDEF13_u128.rr_7() == 0x27579BDE_u128, 'rr_7');
    assert(0xABCDEF13_u128.rr_11() == 0xE27579BD_u128, 'rr_11');
    assert(0xABCDEF13_u128.rr_13() == 0x789D5E6F_u128, 'rr_13');
    assert(0xABCDEF13_u128.rr_17() == 0xF789D5E6_u128, 'rr_17');
    assert(0xABCDEF13_u128.rr_18() == 0x7BC4EAF3_u128, 'rr_18');
    assert(0xABCDEF13_u128.rr_19() == 0xBDE27579_u128, 'rr_19');
    assert(0xABCDEF13_u128.rr_22() == 0x37BC4EAF_u128, 'rr_22');
    assert(0xABCDEF13_u128.rr_25() == 0xE6F789D5_u128, 'rr_25');
}
