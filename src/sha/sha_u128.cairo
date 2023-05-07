use sha::sha::sha_traits::SHABitOperations;
use integer::u128_wrapping_add;
use array::ArrayTrait;
use serde::Serde;
use traits::Into;
use traits::TryInto;
use sha::sha::sha_constants::load_round_constants;
use sha::sha::sha_constants::load_hash_constants;
use traits::BitNot;
use option::OptionTrait;
use clone::Clone;

fn SHA_func(mut bytes: Array<felt252>) -> Array<felt252> {
    assert(bytes.len() % 16_usize == 0, 'byteslen != 16*8 bytes multiple');

    // Using Span resolved issue. check TODO in compression section
    let round_constants = load_round_constants();
    let mut hash_values = load_hash_constants();
    let mut working_hash = hash_values.clone();

    let loop_until = bytes.len() / 16_usize;
    let mut outer_loop: usize = 0;
    loop {
        if outer_loop == loop_until {
            assert(bytes.len() == 0, 'bytes_pop_check');
            break ();
        }

        let mut joined_bytes = ArrayTrait::<u128>::new();
        // let mut joined_bytes=SHASerde::deserialize(ref throw).unwrap();
        let mut load_bytes_index: usize = 0;
        loop {
            if load_bytes_index == 16_usize {
                break ();
            }
            joined_bytes.append(bytes.pop_front().unwrap().try_into().unwrap());
            load_bytes_index = load_bytes_index + 1;
        };

        let mut message_loop_index: usize = 16;
        loop {
            if message_loop_index == 64_usize {
                break ();
            }
            let sigma_1 = (*(joined_bytes[message_loop_index - 15_usize])).rr_7()
                ^ (*(joined_bytes[message_loop_index - 15_usize])).rr_18()
                ^ ((*(joined_bytes[message_loop_index - 15_usize])) / 0x8_u128);
            let sigma_2 = (*(joined_bytes[message_loop_index - 2_usize])).rr_17()
                ^ (*(joined_bytes[message_loop_index - 2_usize])).rr_19()
                ^ ((*(joined_bytes[message_loop_index - 2_usize])) / 0x400_u128);
            joined_bytes
                .append(
                    (*(joined_bytes[message_loop_index - 16_usize]))
                        .wrapping_add(
                            sigma_1
                                .wrapping_add(
                                    (*(joined_bytes[message_loop_index - 7_usize]))
                                        .wrapping_add(sigma_2)
                                )
                        )
                );
            message_loop_index = message_loop_index + 1;
        };

        working_hash = hash_values.clone();
        let mut compression_loop_index = 0_usize;
        // TODO: Used Span. need to measure if better against Array. Also span resolved issue below
        // TODO: Not needed to be loaded repeatedly. but loop moved problem. unroll didnt work
        // let round_constants = load_round_constants();
        loop {
            if compression_loop_index == 64_usize {
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
                                    (*round_constants[compression_loop_index])
                                        .wrapping_add(*joined_bytes[compression_loop_index])
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

            compression_loop_index = compression_loop_index + 1;
        };
        // TODO :: dont want to load here but getting for hash_values
        // Variable was previously moved. Trait has no implementation in context: core::traits::Copy::<core::array::Array::<core::integer::u128>>
        let mut for_next_iter: usize = 0;
        loop {
            if for_next_iter == 8_usize {
                break ();
            }

            hash_values
                .append(
                    ((hash_values.pop_front().unwrap())
                        .wrapping_add(working_hash.pop_front().unwrap()))
                );
            for_next_iter = for_next_iter + 1_usize;
        };
        outer_loop = outer_loop + 1_usize;
    };

    let mut output = ArrayTrait::<felt252>::new();
    let mut unreverse = 7_usize;
    loop {
        if unreverse == 0_usize {
            output.append((*hash_values[unreverse]).into());
            break ();
        }
        output.append((*hash_values[unreverse]).into());

        unreverse = unreverse - 1_usize;
    };
    output
}

impl U128Bit32Operations of SHABitOperations<u128> {
    fn wrapping_add(self: u128, other: u128) -> u128 {
        u128_wrapping_add(self, other) & 0xFFFFFFFF
    }
    fn shl_30(self: u128) -> u128 {
        self * 0x40000000
    }
    fn shr_2(self: u128) -> u128 {
        self / 0x4
    }
    fn rr_2(self: u128) -> u128 {
        (self & 0xFFFFFFFC) / 0x4 | (self & 0x3) * 0x40000000
    }
    fn rr_6(self: u128) -> u128 {
        (self & 0xFFFFFFC0) / 0x40 | (self & 0x3F) * 0x4000000
    }
    fn rr_7(self: u128) -> u128 {
        (self & 0xFFFFFF80) / 0x80 | (self & 0x7F) * 0x2000000
    }
    fn rr_11(self: u128) -> u128 {
        (self & 0xFFFFF800) / 0x800 | (self & 0x7FF) * 0x200000
    }
    fn rr_13(self: u128) -> u128 {
        (self & 0xFFFFE000) / 0x2000 | (self & 0x1FFF) * 0x80000
    }
    fn rr_17(self: u128) -> u128 {
        (self & 0xFFFE0000) / 0x20000 | (self & 0x1FFFF) * 0x8000
    }
    fn rr_18(self: u128) -> u128 {
        (self & 0xFFFC0000) / 0x40000 | (self & 0x3FFFF) * 0x4000
    }
    fn rr_19(self: u128) -> u128 {
        (self & 0xFFF80000) / 0x80000 | (self & 0x7FFFF) * 0x2000
    }
    fn rr_22(self: u128) -> u128 {
        (self & 0xFFC00000) / 0x400000 | (self & 0x3FFFFF) * 0x400
    }
    fn rr_25(self: u128) -> u128 {
        (self & 0xFE000000) / 0x2000000 | (self & 0x1FFFFFF) * 0x80
    }
}
// impl SHASerde of Serde<Array<u128>> {
//     fn serialize(self: @Array<u128>, ref output: Array<felt252>) {
//         self.len().serialize(ref output);
//         serialize_array_helper(self.span(), ref output);
//     }
//     fn deserialize(ref serialized: Span<felt252>) -> Option<Array<u128>> {
//         let mut arr = ArrayTrait::new();
//         deserialize_array_helper(ref serialized, arr)
//     }
// }
// fn deserialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
//     ref serialized: Span<felt252>, mut curr_output: Array<T>
// ) -> Option<Array<T>> {
//     if serialized.len() == 0 {
//         return Option::Some(curr_output);
//     }
//     curr_output.append(TSerde::deserialize(ref serialized)?);
//     deserialize_array_helper(ref serialized, curr_output)
// }

// fn serialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
//     mut input: Span<T>, ref output: Array<felt252>
// ) {
//     match input.pop_front() {
//         Option::Some(value) => {
//             value.serialize(ref output);
//             serialize_array_helper(input, ref output);
//         },
//         Option::None(_) => {},
//     }
// }


