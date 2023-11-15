// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NFTSpecial} from "../src/NFTSpecial.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTSpecialTest is Test {
    using Strings for uint256;

    NFTSpecial public nftspecial;
    address owner;
    address artist;
    bytes32 public merkleRoot;

    function setUp() public {
        owner = vm.addr(0x1234);
        artist = vm.addr(0x44);
        merkleRoot = testSetUpMerkleTree();
        nftspecial = new NFTSpecial(owner, merkleRoot, artist);
    }

    function generateMerkleProof(bytes32[] memory leaves, uint256 index) public pure returns (bytes32[] memory) {
        bytes32[] memory proof = new bytes32[](ceilLog2(leaves.length));
        bytes32[] memory currentLevel = leaves;
        uint256 currentIndex = index;

        for (uint256 i = 0; i < proof.length; i++) {
            uint256 siblingIndex = currentIndex % 2 == 0 ? currentIndex + 1 : currentIndex - 1;
            if (siblingIndex < currentLevel.length) {
                proof[i] = currentLevel[siblingIndex];
            }

            currentIndex /= 2;
            currentLevel = getNextLevel(currentLevel);
        }

        return proof;
    }

    function testGenerateMerkleProof() public returns (bytes32[] memory) {
        bytes32[] memory leaves = generateLeaves();
        uint256 index = 0;
        return generateMerkleProof(leaves, index);
    }

    function getNextLevel(bytes32[] memory currentLevel) public pure returns (bytes32[] memory) {
        uint256 nextLevelLength = (currentLevel.length + 1) / 2;
        bytes32[] memory nextLevel = new bytes32[](nextLevelLength);

        for (uint256 i = 0; i < currentLevel.length; i += 2) {
            bytes32 left = currentLevel[i];
            bytes32 right = (i + 1 < currentLevel.length) ? currentLevel[i + 1] : left;
            nextLevel[i / 2] = keccak256(abi.encodePacked(left, right));
        }

        return nextLevel;
    }

    function ceilLog2(uint256 x) public pure returns (uint256) {
        uint256 y = 1;
        uint256 n = 0;
        while (x > y) {
            y *= 2;
            n++;
        }
        // Check if x is a power of 2
        if (y == x) {
            return n - 1;
        }
        return n;
    }

    function testSetUpMerkleTree() public returns (bytes32) {
        bytes32[] memory leaves = generateLeaves();
        return computeMerkleRoot(leaves);
    }

    function computeMerkleRoot(bytes32[] memory leaves) internal pure returns (bytes32) {
        if (leaves.length == 0) {
            return bytes32(0);
        }

        while (leaves.length > 1) {
            uint256 nextLevelLength = (leaves.length + 1) / 2; // Ensure even number of elements
            bytes32[] memory nextLevel = new bytes32[](nextLevelLength);

            for (uint256 i = 0; i < leaves.length; i += 2) {
                bytes32 left = leaves[i];
                bytes32 right = (i + 1 < leaves.length) ? leaves[i + 1] : left;
                nextLevel[i / 2] = keccak256(abi.encodePacked(left, right));
            }

            leaves = nextLevel;
        }

        return leaves[0];
    }

    function generateLeaves() internal returns (bytes32[] memory leaves) {
        leaves = new bytes32[](4);
        address[] memory eligibleAddresses = new address[](4);
        eligibleAddresses[0] = vm.addr(0x11);
        eligibleAddresses[1] = vm.addr(0x12);
        eligibleAddresses[2] = vm.addr(0x13);
        eligibleAddresses[3] = vm.addr(0x14);

        leaves[0] = keccak256(abi.encodePacked(eligibleAddresses[0], uint256(0).toString()));
        leaves[1] = keccak256(abi.encodePacked(eligibleAddresses[1], uint256(0).toString()));
        leaves[2] = keccak256(abi.encodePacked(eligibleAddresses[2], uint256(0).toString()));
        leaves[3] = keccak256(abi.encodePacked(eligibleAddresses[3], uint256(0).toString()));

        return leaves;
    }

    function testMintDiscount() public {
        bytes32[] memory leaves = generateLeaves();
        emit log_bytes32(leaves[0]);
        emit log_bytes32(leaves[1]);
        emit log_bytes32(leaves[2]);
        emit log_bytes32(leaves[3]);
        address sender = vm.addr(0x11);

        bytes32 computedRoot = testSetUpMerkleTree();
        emit log_bytes32(computedRoot);
        uint256 index = 0; // For the first leaf
        bytes32[] memory proof = testGenerateMerkleProof();
        vm.deal(vm.addr(0x11), 5 ether);
        vm.prank(vm.addr(0x11));
        nftspecial.mintDiscount{value: 0.8 ether}(sender, proof, index);
    }
}
