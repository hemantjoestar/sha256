use sha::sha::sha_traits::SHABitOperations;
use integer::{u256_from_felt252, u128_wrapping_add};
use array::ArrayTrait;
use array::SpanTrait;
use serde::Serde;
use traits::Into;
use traits::TryInto;
use sha::sha::sha_constants::load_round_constants;
use sha::sha::sha_constants::load_hash_constants;
use option::OptionTrait;
use result::ResultTrait;
use clone::Clone;
use debug::PrintTrait;

// TODO: Put in readme
// will use u128 since the boolean operations are running using libfuncs and using u64 
// offers worse performance

fn SHA_func(mut bytes: Span<felt252>) -> Result<Array<felt252>, felt252> {
    // 512 bits or 16 * 32 bit chunks for each iteration
    if (bytes.len() % 16_usize != 0) {
        return Result::Err('Input_length_!=_16');
    }
    // Using Span resolved issue. check TODO in compression section
	// Span
    let round_constants = load_round_constants();
	// Array
    let mut hash_values = load_hash_constants();

    // 512 bits or 16 * 32 bit chunks for each iteration
    loop {
        if bytes.is_empty() {
            break ();
        }
        let mut joined_bytes = Default::<Array<u128>>::default();
        loop {
            if joined_bytes.len() == 16_usize {
                break ();
            }
            joined_bytes.append((*bytes.pop_front().unwrap()).try_into().unwrap());
        };

        // Message Loop
        let mut message_loop_index: usize = 16;
        loop {
            if message_loop_index == 64_usize {
                break ();
            }
            let sigma_1 = (*joined_bytes[message_loop_index - 15_usize]).rr_7()
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

        let mut working_hash = hash_values.clone();
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
                ^ ((~(*working_hash[3])) & *working_hash[1]);
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
    };

    let mut output = Default::default();
    let mut unreverse = 7_usize;
    loop {
        if unreverse == 0_usize {
            output.append((*hash_values[unreverse]).into());
            break ();
        }
        output.append((*hash_values[unreverse]).into());

        unreverse = unreverse - 1_usize;
    };
    Result::Ok(output)
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

