use option::OptionTrait;
use debug::PrintTrait;
use array::ArrayTrait;
use sha::sha::sha_traits::SHA;
use sha::sha::sha_u128;

#[test]
#[available_gas(1000000)]
fn test_init_concrete() {
    // let mut hasher = SHA::<u128>::new();

    // taking in prepped for now. can prep using scripts
    // b"starkware cairo1"
    let mut test_input = ArrayTrait::new();
    test_input.append(0x73746172);
    test_input.append(0x6B776172);
    test_input.append(0x65206361);
    test_input.append(0x69726F31);
    test_input.append(0x80000000);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x0);
    test_input.append(0x80);
    let mut span_input = test_input.span();
    let mut hasher = SHA::<u128>::new(ref span_input);
    // hasher.update(test_input.span());

    hasher.finalize();
}
