// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTSpecial is ERC721, ERC2981, Ownable2Step {
    using BitMaps for BitMaps.BitMap;
    using Strings for uint256;

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

    function _verifyEligible(address sender, bytes32[] calldata merkleProof, uint256 index) public {
        bytes32 leaf = keccak256(abi.encodePacked(sender, index.toString()));
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Invalid merkle proof");
    }

    function mintDiscount(address sender, bytes32[] calldata proof, uint256 index) external payable {
        require(tokenSupply < MAX_SUPPLY, "Maximum supply reached");
        require(!_discountList.get(index), "Already minted");
        require(msg.value == DISCOUNT_PRICE, "Invalid price");
        _verifyEligible(sender, proof, index);
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

    function transferNFT(address stakingContract, uint256 tokenId) external {
        require(owners[tokenId] == msg.sender, "Not owner");
        ERC721(address(this)).safeTransferFrom(msg.sender, stakingContract, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
        return ERC721.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
    }
}
