use debug::PrintTrait;
use traits::TryInto;
// use clone::Clone;
use array::ArrayTrait;
use array::SpanTrait;
use serde::Serde;
use option::OptionTrait;


impl SHAImpl<
    T,
    impl TSHABitOperations: SHABitOperations<T>,
    impl TBitXor: BitXor<T>,
    impl TDiv: Div<T>,
    impl TSHASerde: Serde<T>,
    impl TTryInto: TryInto<felt252, T>,
    impl TDrop: Drop<T>,
    impl TCopy: Copy<T>,
> of SHA<T> {
    fn hash(input: Array<felt252>) -> Array<felt252> {
        let mut throw = input.span();
        let mut joined_bytes = TSHASerde::<T>::deserialize(ref throw).unwrap();
        let mut hash_values = ArrayTrait::<T>::new();
        // 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
        hash_values.append(0x5be0cd19.try_into().unwrap());
        hash_values.append(0x1f83d9ab.try_into().unwrap());
        hash_values.append(0x9b05688c.try_into().unwrap());
        hash_values.append(0x510e527f.try_into().unwrap());
        hash_values.append(0xa54ff53a.try_into().unwrap());
        hash_values.append(0x3c6ef372.try_into().unwrap());
        hash_values.append(0xbb67ae85.try_into().unwrap());
        hash_values.append(0x6a09e667.try_into().unwrap());
        let mut working_hash = ArrayTrait::new();
        working_hash = hash_values;
        let mut index: usize = 16;
        loop {
            if index == 64_usize {
                break ();
            }
            let sigma_1 = (*(joined_bytes[index - 15_usize])).rr_7()
                ^ (*(joined_bytes[index - 15_usize])).rr_18()
                ^ ((*(joined_bytes[index - 15_usize])) / 0x8.try_into().unwrap());
            let sigma_2 = (*(joined_bytes[index - 2_usize])).rr_17()
                ^ (*(joined_bytes[index - 2_usize])).rr_19()
                ^ ((*(joined_bytes[index - 2_usize])) / 0x400.try_into().unwrap());
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
        let mut output = ArrayTrait::new();
        TSHASerde::<T>::serialize(@hash_values, ref output);
        output
    }
}

impl TSHAConstants<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of Serde<Array<T>> {
    fn serialize(self: @Array<T>, ref output: Array<felt252>) {
        self.len().serialize(ref output);
        serialize_array_helper(self.span(), ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<Array<T>> {
        let mut arr = ArrayTrait::new();
        deserialize_array_helper(ref serialized, arr)
    }
}
impl TSHASerde<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of Serde<Array<T>> {
    fn serialize(self: @Array<T>, ref output: Array<felt252>) {
        self.len().serialize(ref output);
        serialize_array_helper(self.span(), ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<Array<T>> {
        let mut arr = ArrayTrait::new();
        deserialize_array_helper(ref serialized, arr)
    }
}
fn deserialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    ref serialized: Span<felt252>, mut curr_output: Array<T>
) -> Option<Array<T>> {
    if serialized.len() == 0 {
        return Option::Some(curr_output);
    }
    curr_output.append(TSerde::deserialize(ref serialized)?);
    deserialize_array_helper(ref serialized, curr_output)
}

fn serialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    mut input: Span<T>, ref output: Array<felt252>
) {
    match input.pop_front() {
        Option::Some(value) => {
            value.serialize(ref output);
            serialize_array_helper(input, ref output);
        },
        Option::None(_) => {},
    }
}


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

