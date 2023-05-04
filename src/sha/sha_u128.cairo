use integer::u128_wrapping_add;
use array::ArrayTrait;
use array::SpanTrait;
use sha::sha::sha_traits::SHABitOperations;
use sha::sha::sha_traits::SHA;
use sha::sha::sha_traits::Hasher;

impl U128SHA of SHA<u128> {
    fn new() -> Hasher<u128> {
        let mut input = ArrayTrait::new();
        Hasher { input }
    }
    fn update(ref self: Hasher<u128>, input: Span<felt252>) {}
    fn finalize(self: Hasher<u128>) -> Array<felt252> {
        let mut output = ArrayTrait::new();
        output.append(123);
        output
    }
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
// fn sigma_0(self: u128) -> u128 {
//     self.rr_2() ^ self.rr_13() ^ self.rr_22()
// }

// fn sigma_1(self: u128) -> u128 {
//     self.rr_6() ^ self.rr_11() ^ self.rr_25()
// }

// fn gamma_0(self: u128) -> u128 {
//     self.rr_7() ^ self.rr_18() ^ (self & 0x7FFFFFFF00) / 0x100
// }

// fn gamma_1(self: u128) -> u128 {
//     self.rr_17() ^ self.rr_19() ^ (self & 0x7FFFF0000) / 0x10000
// }


