use debug::PrintTrait;
use traits::TryInto;
// use clone::Clone;
use array::ArrayTrait;
use array::SpanTrait;
use serde::Serde;
use option::OptionTrait;

trait SHA<T> {
    fn hash(input: Array<felt252>) -> Array<felt252>;
}

trait SHABitOperations<T> {
    fn shl_30(self: T) -> T;
    fn shr_2(self: T) -> T;
    fn rr_2(self: T) -> T;
    fn rr_6(self: T) -> T;
    fn rr_7(self: T) -> T;
    fn rr_11(self: T) -> T;
    fn rr_13(self: T) -> T;
    fn rr_17(self: T) -> T;
    fn rr_18(self: T) -> T;
    fn rr_19(self: T) -> T;
    fn rr_22(self: T) -> T;
    fn rr_25(self: T) -> T;
    fn wrapping_add(self: T, other: T) -> T;
}

