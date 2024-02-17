// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC-CouponNFT.sol";

contract ERC2000 is IERC2000, ERC721 {
    uint256 private latestTokenId = 0;
    uint64 private fullStampNumber;
    address private immutable contractOwner;

    mapping(uint256 => uint64) private currentStampNumber;
    mapping(uint256 => CouponStatus) private couponStatus;

    enum CouponStatus {
        AVAILABLE,
        CONSUMED,
        BURNED
    }

    constructor(string memory name_, string memory symbol_, uint64 _fullStampNumber) ERC721(name_, symbol_) {
        fullStampNumber = _fullStampNumber;
        contractOwner = msg.sender;
    }

    modifier onlyContractOwner {
        require(msg.sender == contractOwner, "Only owner can call this function");
        _;
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function addStampToCoupon(uint256 tokenId) external onlyContractOwner {
        require(couponStatus[tokenId] == CouponStatus.AVAILABLE, "Coupon not available (already consumed or burned)");
        require(!__isFull(tokenId), "Coupon is full");
        currentStampNumber[tokenId] += 1;
        emit AddStamp(tokenId);
    }
    
    function consumeCoupon(uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Only owner or Approved can call this function");
        require(couponStatus[tokenId] == CouponStatus.AVAILABLE, "Coupon not available (already consumed or burned)");
        require(__isFull(tokenId), "Coupon is not full");
        couponStatus[tokenId] = CouponStatus.CONSUMED;
        emit ConsumeCoupon(tokenId);
    }

    function getCurrentStampNumber(uint256 tokenId) view external returns(uint64) {
        require(couponStatus[tokenId] != CouponStatus.BURNED, "The coupon is burned");
        return currentStampNumber[tokenId];
    }

    function getFullStampNumber() view external returns(uint64) {
        return fullStampNumber;
    }

    function __isFull(uint256 tokenId) view internal returns (bool) {
        return currentStampNumber[tokenId] == fullStampNumber;
    }

    function isFull(uint256 tokenId) view external returns (bool) {
        require(couponStatus[tokenId] != CouponStatus.BURNED, "The coupon is burned");
        return __isFull(tokenId);
    }

    function isConsumed(uint256 tokenId) view external returns (bool) {
        require(couponStatus[tokenId] != CouponStatus.BURNED, "The coupon is burned");
        return couponStatus[tokenId] == CouponStatus.CONSUMED;
    }

    function getCouponsStatus(uint256 tokenId) view external returns (CouponStatus) {
        return couponStatus[tokenId];
    }

    function mintCoupon(address recipient) external onlyContractOwner returns (uint256) {
        uint256 tokenId = ++latestTokenId;
        _mint(recipient, tokenId);
        couponStatus[tokenId] = CouponStatus.AVAILABLE;
        currentStampNumber[tokenId] = 0;
        return tokenId;
    }

    function burnCoupon(uint256 tokenId) external onlyContractOwner returns (bool) {
        couponStatus[tokenId] = CouponStatus.BURNED;
        _burn(tokenId);
        return true;
    }
}