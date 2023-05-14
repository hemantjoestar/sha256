use sha::sha::sha_u128::{get_256_bit_hash, SHA_func};
use array::ArrayTrait;
use debug::PrintTrait;

// let test_str = b"starknet";
#[test]
#[available_gas(200000000)]
fn test_less_than_512_bits() {
    let mut input = ArrayTrait::new();
    input.append(0x73746172);
    input.append(0x6B6E6574);
    input.append(0x80000000);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x40);
    let mut output = SHA_func(input);
    assert(*output[0] == 4246238833, 'final_hash_0_index check');
    assert(*output[1] == 2715154529, 'final_hash_1_index check');
    assert(*output[2] == 3111545146, 'final_hash_2_index check');
    assert(*output[3] == 2523928951, 'final_hash_3_index check');
    assert(*output[4] == 2343742124, 'final_hash_4_index check');
    assert(*output[5] == 816016193, 'final_hash_5_index check');
    assert(*output[6] == 2467408739, 'final_hash_6_index check');
    assert(*output[7] == 3342985673, 'final_hash_7_index check');
    let hash: u256 = get_256_bit_hash(output.span());
    hash.print();
    let precomputed_hash: u256 = 0xfd187671a1d5f861b976693a967019778bb2aaac30a36b419311ab63c741e9c9;
    assert(hash == precomputed_hash, 'Hash starknet Match fail');
}

// let test_str = b"Cairo is the first Turing-complete language for creating provable programs for general computation.";
#[test]
#[available_gas(200000000)]
fn test_more_than_512_bits() {
    let mut input = ArrayTrait::new();
    input.append(0x43616972);
    input.append(0x6F206973);
    input.append(0x20746865);
    input.append(0x20666972);
    input.append(0x73742054);
    input.append(0x7572696E);
    input.append(0x672D636F);
    input.append(0x6D706C65);
    input.append(0x7465206C);
    input.append(0x616E6775);
    input.append(0x61676520);
    input.append(0x666F7220);
    input.append(0x63726561);
    input.append(0x74696E67);
    input.append(0x2070726F);
    input.append(0x7661626C);
    input.append(0x65207072);
    input.append(0x6F677261);
    input.append(0x6D732066);
    input.append(0x6F722067);
    input.append(0x656E6572);
    input.append(0x616C2063);
    input.append(0x6F6D7075);
    input.append(0x74617469);
    input.append(0x6F6E2E80);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x318);
    let mut output = SHA_func(input);
    assert(*output[0] == 2541875948, 'final_hash_0_index check');
    assert(*output[1] == 3479205334, 'final_hash_1_index check');
    assert(*output[2] == 2534622915, 'final_hash_2_index check');
    assert(*output[3] == 1021255763, 'final_hash_3_index check');
    assert(*output[4] == 2026962479, 'final_hash_4_index check');
    assert(*output[5] == 1611312724, 'final_hash_5_index check');
    assert(*output[6] == 2207786822, 'final_hash_6_index check');
    assert(*output[7] == 3523740160, 'final_hash_7_index check');
    let hash: u256 = get_256_bit_hash(output.span());
    let precomputed_hash: u256 = 0x9781f2eccf6075d6971346c33cdf205378d0fe2f600aae5483982746d2080200;
    assert(hash == precomputed_hash, 'Hash > 512 bits Match fail');
}

// Cairo Wwhitepaper Abstract
#[test]
#[available_gas(400000000)]
fn should_pass() {
    let mut input = ArrayTrait::new();
    input.append(0x57652070);
    input.append(0x72657365);
    input.append(0x6E742043);
    input.append(0x6169726F);
    input.append(0x2C206120);
    input.append(0x70726163);
    input.append(0x74696361);
    input.append(0x6C6C792D);
    input.append(0x65666669);
    input.append(0x6369656E);
    input.append(0x74205475);
    input.append(0x72696E67);
    input.append(0x2D636F6D);
    input.append(0x706C6574);
    input.append(0x65205354);
    input.append(0x41524B2D);
    input.append(0x66726965);
    input.append(0x6E646C79);
    input.append(0xA202020);
    input.append(0x20202020);
    input.append(0x20202020);
    input.append(0x20435055);
    input.append(0x20617263);
    input.append(0x68697465);
    input.append(0x63747572);
    input.append(0x652E2057);
    input.append(0x65206465);
    input.append(0x73637269);
    input.append(0x62652061);
    input.append(0x2073696E);
    input.append(0x676C6520);
    input.append(0x73657420);
    input.append(0x6F662070);
    input.append(0x6F6C796E);
    input.append(0x6F6D6961);
    input.append(0x6C206571);
    input.append(0x75617469);
    input.append(0x6F6E7320);
    input.append(0x666F720A);
    input.append(0x20202020);
    input.append(0x20202020);
    input.append(0x20202020);
    input.append(0x74686520);
    input.append(0x73746174);
    input.append(0x656D656E);
    input.append(0x74207468);
    input.append(0x61742074);
    input.append(0x68652065);
    input.append(0x78656375);
    input.append(0x74696F6E);
    input.append(0x206F6620);
    input.append(0x61207072);
    input.append(0x6F677261);
    input.append(0x6D206F6E);
    input.append(0x20746869);
    input.append(0x73206172);
    input.append(0x63686974);
    input.append(0x65637475);
    input.append(0x72652069);
    input.append(0x730A2020);
    input.append(0x20202020);
    input.append(0x20202020);
    input.append(0x20207661);
    input.append(0x6C69642E);
    input.append(0x20476976);
    input.append(0x656E2061);
    input.append(0x20737461);
    input.append(0x74656D65);
    input.append(0x6E74206F);
    input.append(0x6E652077);
    input.append(0x69736865);
    input.append(0x7320746F);
    input.append(0x2070726F);
    input.append(0x76652C20);
    input.append(0x43616972);
    input.append(0x6F20616C);
    input.append(0x6C6F7773);
    input.append(0x20777269);
    input.append(0x74696E67);
    input.append(0x20610A20);
    input.append(0x20202020);
    input.append(0x20202020);
    input.append(0x20202070);
    input.append(0x726F6772);
    input.append(0x616D2074);
    input.append(0x68617420);
    input.append(0x64657363);
    input.append(0x72696265);
    input.append(0x73207468);
    input.append(0x61742073);
    input.append(0x74617465);
    input.append(0x6D656E74);
    input.append(0x2C20696E);
    input.append(0x73746561);
    input.append(0x64206F66);
    input.append(0x20777269);
    input.append(0x74696E67);
    input.append(0x20612073);
    input.append(0x6574206F);
    input.append(0x6620706F);
    input.append(0x6C796E6F);
    input.append(0x6D69616C);
    input.append(0x20657175);
    input.append(0x6174696F);
    input.append(0x6E732E80);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0x0);
    input.append(0xD18);
    let mut output = SHA_func(input);
    assert(*output[0] == 1441192377, 'final_hash_0_index check');
    assert(*output[1] == 1769845322, 'final_hash_1_index check');
    assert(*output[2] == 2796635096, 'final_hash_2_index check');
    assert(*output[3] == 4107306602, 'final_hash_3_index check');
    assert(*output[4] == 1148488327, 'final_hash_4_index check');
    assert(*output[5] == 1847243362, 'final_hash_5_index check');
    assert(*output[6] == 3282689944, 'final_hash_6_index check');
    assert(*output[7] == 579914429, 'final_hash_7_index check');
    let hash: u256 = get_256_bit_hash(output.span());
    let precomputed_hash: u256 = 0x55e6d9b9697db24aa6b143d8f4d0866a44748a876e1ab262c3a9df982290cabd;
    assert(hash == precomputed_hash, 'Hash CWP Match fail');
}
