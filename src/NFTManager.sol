// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";
import "./NFTSpecial.sol";

contract NFTManager is IERC721Receiver, Ownable2Step {
    using SafeERC20 for IERC20;

    IERC20 public immutable rewardToken;
    NFTSpecial public immutable nftSpecial;

    uint256 public immutable threshold = 24 hours;
    uint256 constant public rewardAmount = 10;  

    mapping(address => mapping(uint256 => bool)) public stakedNFT;
    mapping(address => mapping(uint256 => uint256)) public stakedTime;

    constructor(address _owner, address _rewardToken) public Ownable(_owner){
         rewardToken = IERC20(_rewardToken);
    }

    function stakeNFT(uint256 tokenId) external {
        require(stakedNFT[msg.sender][tokenId] == false, "Already staked");
        require(ERC721(nftSpecial).ownerOf(tokenId) == msg.sender, "Invalid Owner");
        stakedNFT[msg.sender][tokenId] = true;
        stakedTime[msg.sender][tokenId] = block.timestamp;
        ERC721(nftSpecial).safeTransferFrom(msg.sender, address(this), tokenId);
    }

    function unStakeNFT(uint256 tokenId) external {
        ERC721(nftSpecial).safeTransferFrom(msg.sender, address(this), tokenId);
    }

    function claim(uint256 tokenId, uint256 amount) external returns (bool) {
        require(stakedNFT[msg.sender][tokenId] == true, "Not staked");
        require(block.timestamp > stakedTime[msg.sender][tokenId] + threshold, "Not enough time has passed");
        IERC20(rewardToken).safeTransferFrom(address(this), msg.sender, rewardAmount);
        return true;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {   
        require(msg.sender == address(nftSpecial), "Invalid NFT");
        return this.onERC721Received.selector;
    }
}
