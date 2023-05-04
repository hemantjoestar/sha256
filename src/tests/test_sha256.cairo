use option::OptionTrait;
use debug::PrintTrait;
use array::ArrayTrait;
use sha::sha::sha_traits::SHA;
// will try to use generics to get this impl
use sha::sha::sha_u128::U128SHA;

#[test]
fn test_init_concrete() {
    // let mut hasher = U128SHA::new();
    // requires impl import
    let mut hasher = SHA::<u128>::new();
    let mut test_input = ArrayTrait::new();
    test_input.append(0xABCDEF12);
    // if you pull in impls
    // U128SHA::update(ref hasher,test_input.span());
    hasher.update(test_input.span());
// hasher.input.pop_front().unwrap().print();
}
