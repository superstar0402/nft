// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NFTSpecial} from "../src/NFTSpecial.sol";

contract NFTSpecialTest is Test {
    NFTSpecial public nftspecial;

    mapping(address => bool) public bitmap;

    function setUp() public {
        address owner = vm.addr(0x1234);
        address artist = vm.addr(0x44);
        bytes32 merkleRoot = 0xa363ce445148603408e6b99e5f58271a80b194bfce04d7270672f0ac98e086f5;
        nftspecial = new NFTSpecial(owner, merkleRoot, artist);
    }

    function testVerifyEligible() public {
    }

    function testSupply() public {
        assertEq(nftspecial.tokenSupply(), 0);
    }

    // function testSupplyIncrease() public {
    //     address Bob = vm.addr(0x55);
    //     vm.deal(Bob, 2 ether);
    //     vm.prank(Bob);
    //     nftspecial.mint{value: 1 ether}(0);
    //     assertEq(nftspecial.tokenSupply(), 2);
    // }

    // function testMintFail() public {
    //     address Bob = vm.addr(0x55);
    //     vm.deal(Bob, 10 ether);
    //     vm.startPrank(Bob);
    //     nftspecial.mint{value: 1 ether}(0);
    //     nftspecial.mint{value: 1 ether}(0);
    //     vm.stopPrank();
    //     assertEq(nftspecial.tokenSupply(), 3);
    // }

    // function testMint() public {
    //     nftspecial.mint(0);
    //     nftspecial.mint(1);
    //     assertEq(nftspecial.tokenSupply(), 2);
    // }
}
