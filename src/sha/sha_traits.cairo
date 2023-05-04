use debug::PrintTrait;
// use clone::Clone;
use array::ArrayTrait;
use array::SpanTrait;
use serde::Serde;
use option::OptionTrait;

impl SHAImpl<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of SHA<T> {
    fn new(ref input: Span<felt252>) -> Hasher<T> {
        // Serde::<Hasher<T>>::deserialize(ref input).unwrap()
        let tmp = TSerde::<T>::deserialize(ref input).unwrap();
        Hasher { input: tmp }
    }
    // fn update(ref self: Hasher<T>, input: Span<felt252>) {}
    fn finalize(self: Hasher<T>) -> Array<felt252> {
        let mut hash_values = ArrayTrait::new();
        // 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19,
        hash_values.append(0x5be0cd19);
        hash_values.append(0x1f83d9ab);
        hash_values.append(0x9b05688c);
        hash_values.append(0x510e527f);
        hash_values.append(0xa54ff53a);
        hash_values.append(0x3c6ef372);
        hash_values.append(0xbb67ae85);
        hash_values.append(0x6a09e667);
        // hash_values.clone().print();
        let mut working_hash = ArrayTrait::new();
        working_hash = hash_values;
        // working_hash.print();
        let mut output = ArrayTrait::new();
        output.append(123);
        output
    }
}

impl TSerde<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of Serde<Array<T>> {
    fn serialize(self: @Array<T>, ref output: Array<felt252>) {
        self.len().serialize(ref output);
        serialize_array_helper_1(self.span(), ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<Array<T>> {
        let mut arr = ArrayTrait::new();
        deserialize_array_helper_1(ref serialized, arr)
    }
}
fn deserialize_array_helper_1<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    ref serialized: Span<felt252>, mut curr_output: Array<T>
) -> Option<Array<T>> {
    if serialized.len() == 0 {
        return Option::Some(curr_output);
    }
    curr_output.append(TSerde::deserialize(ref serialized)?);
    deserialize_array_helper_1(ref serialized, curr_output)
}

fn serialize_array_helper_1<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    mut input: Span<T>, ref output: Array<felt252>
) {
    match input.pop_front() {
        Option::Some(value) => {
            value.serialize(ref output);
            serialize_array_helper_1(input, ref output);
        },
        Option::None(_) => {},
    }
}
#[derive(Drop)]
struct Hasher<T> {
    input: Array<T>, 
}

impl HasherSerde<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>> of Serde<Hasher<T>> {
    fn serialize(self: @Hasher<T>, ref output: Array<felt252>) {
        self.input.len().serialize(ref output);
        serialize_array_helper(self.input.span(), ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<Hasher<T>> {
        // let length = *serialized.pop_front()?;
        let mut arr = ArrayTrait::<T>::new();
        deserialize_array_helper(ref serialized, arr)
    }
}

fn deserialize_array_helper<T, impl TSerde: Serde<T>, impl TDrop: Drop<T>>(
    ref serialized: Span<felt252>, mut curr_output: Array<T>
) -> Option<Hasher<T>> {
    if serialized.len() == 0 {
        return Option::Some(Hasher { input: curr_output });
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
    fn new(ref input: Span<felt252>) -> Hasher<T>;
    // fn update(ref self: Hasher<T>, input: Span<felt252>);
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

