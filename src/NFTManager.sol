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

    mapping(address => uint256) public stakedNFT;
    mapping(address => uint256) public stakedTime;

    constructor(address _owner, address _rewardToken) public Ownable(_owner){
         rewardToken = IERC20(_rewardToken);
    }

    function stakeNFT(address nft, uint256 tokenId) external {
        ERC721(nftSpecial).safeTransferFrom(msg.sender, address(this), tokenId);
        stakedNFT[msg.sender] = tokenId;
        stakedTime[msg.sender] = block.timestamp;
    }

    function unStakeNFT() external {
        ERC721(nftSpecial).safeTransferFrom(address(this), msg.sender, stakedNFT[msg.sender]);
    }

    function claim(uint256 tokenId, uint256 amount) external returns (bool) {
        require(stakedNFT[msg.sender] == tokenId, "Invalid Owner");
        require(block.timestamp > stakedTime[msg.sender] + threshold, "Not enough time has passed");
        IERC20(rewardToken).safeTransferFrom(address(this), msg.sender, rewardAmount);
        return true;
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
        external
        returns (bytes4)
    {
        return this.onERC721Received.selector;
    }
}
