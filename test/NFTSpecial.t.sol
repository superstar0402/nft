// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Test, console2} from "forge-std/Test.sol";
// import {NFTSpecial} from "../src/NFTSpecial.sol";

// contract NFTSpecialTest is Test {
//     NFTSpecial public nftspecial;

//     function setUp() public {
//         address owner = vm.addr(0x1234);
//         bytes32 merkleRoot = bytes32("0x1234");
//         nftspecial = new NFTSpecial(owner, merkleRoot);
//     }

//     function testSupply() public {
//         assertEq(nftspecial.tokenSupply(), 1);
//     }

//     function testSupplyIncrease() public {
//         address Bob = vm.addr(0x55);
//         vm.deal(Bob, 2 ether);
//         vm.prank(Bob);
//         nftspecial.mint{value: 1 ether}(0);
//         assertEq(nftspecial.tokenSupply(), 2);
//     }

//     function testMintFail() public {
//         address Bob = vm.addr(0x55);
//         vm.deal(Bob, 10 ether);
//         vm.startPrank(Bob);
//         nftspecial.mint{value: 1 ether}(0);
//         nftspecial.mint{value: 1 ether}(0);
//         vm.stopPrank();
//         assertEq(nftspecial.tokenSupply(), 3);
//     }

//     function testMint() public {
//         nftspecial.mint(0);
//         nftspecial.mint(1);
//         assertEq(nftspecial.tokenSupply(), 2);
//     }
// }
