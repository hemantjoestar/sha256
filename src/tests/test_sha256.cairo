use option::OptionTrait;
use debug::PrintTrait;
use array::ArrayTrait;
use sha::sha::sha_traits::SHA;
use sha::sha::sha_u128;
use testing::get_available_gas;

#[test]
#[ignore]
#[available_gas(100000000)]
fn test_init_concrete() {
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
    let hash = SHA::<u128>::hash(test_input);
    get_available_gas().print();
}
