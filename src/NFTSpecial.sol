// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFTSpecial is ERC721, ERC2981, Ownable2Step {
    using BitMaps for BitMaps.BitMap;

    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _discountList;
    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 1_000;
    uint256 public constant PRICE = 1 ether;
    uint256 public constant DISCOUNT_PRICE = 0.8 ether; // 20% discount for Address in the Merkle Tree

    mapping(uint256 => address) public owners;

    constructor(address owner, bytes32 _merkleRoot, address _artist) ERC721("NFTSpecial", "NFS") Ownable(owner) {
        merkleRoot = _merkleRoot;
        _setDefaultRoyalty(_artist, 250);
    }

    function _verifyEligible(bytes32[] calldata merkleProof, uint256 index) internal  {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, index));
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf));
    }


    function mintDiscount(bytes32[] calldata proof, uint256 index, uint256 _price) external payable {
        require(tokenSupply < MAX_SUPPLY, "Maximum supply reached");
        require(!_discountList.get(index), "Already minted");
        require(_price == DISCOUNT_PRICE , "Invalid price");
        _verifyEligible(proof, index);
        BitMaps.setTo(_discountList, index, true);
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "Maximum supply reached");
        require(msg.value == PRICE, "Invalid price");
        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return ERC721.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
    }
}
