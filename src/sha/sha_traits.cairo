use array::ArrayTrait;
use array::SpanTrait;

#[derive(Drop)]
struct Hasher<T> {
    input: Array<T>, 
}

trait SHA<T> {
    fn new() -> Hasher<T>;
    fn update(ref self: Hasher<T>, input: Span<felt252>);
    fn finalize(self: Hasher<T>) -> Array<felt252>;
}

trait SHABitOperations<T> {
    fn shl_30(self: T) -> T;
    fn shr_2(self: T) -> T;
    fn rr_2(self: T) -> T;
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
// fn sigma_0(self: T) -> T;
// fn sigma_1(self: T) -> T;
// fn gamma_0(self: T) -> T;
// fn gamma_1(self: T) -> T;
// fn rr_6(self: T) -> T;
// fn rr_11(self: T) -> T;
// fn rr_13(self: T) -> T;
// fn rr_22(self: T) -> T;
// fn rr_25(self: T) -> T;


