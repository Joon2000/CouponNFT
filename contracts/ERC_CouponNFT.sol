// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC_CouponNFT.sol";

contract ERC_CouponNFT is IERC_CouponNFT, ERC721 {
    uint256 private latestTokenId = 0;
    uint64 private totalStampNumber;
    address private immutable contractOwner;

    mapping(uint256 => CouponInfo) private couponInfo;

    constructor(
        string memory name_,
        string memory symbol_,
        uint64 _totalStampNumber
    ) ERC721(name_, symbol_) {
        totalStampNumber = _totalStampNumber;
        contractOwner = msg.sender;
    }

    modifier onlyContractOwner() {
        require(
            msg.sender == contractOwner,
            "Only owner can call this function"
        );
        _;
    }

    function _isApprovedOrOwner(
        address spender,
        uint256 tokenId
    ) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender);
    }

    function addStampToCoupon(uint256 tokenId) external onlyContractOwner {
        require(
            couponInfo[tokenId].couponStatus == CouponStatus.AVAILABLE,
            "Coupon not available (already consumed or burned)"
        );
        require(!_isFull(tokenId), "Coupon is full");
        couponInfo[tokenId].currentStampNumber += 1;
        emit AddStamp(tokenId);
    }

    function consumeCoupon(uint256 tokenId) external {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Only owner or Approved can call this function"
        );
        require(
            couponInfo[tokenId].couponStatus == CouponStatus.AVAILABLE,
            "Coupon not available (already consumed or burned)"
        );
        require(_isFull(tokenId), "Coupon is not full");
        couponInfo[tokenId].couponStatus = CouponStatus.CONSUMED;
        emit ConsumeCoupon(tokenId);
    }

    function getCurrentStampNumber(
        uint256 tokenId
    ) external view returns (uint64) {
        require(
            couponInfo[tokenId].couponStatus != CouponStatus.BURNED,
            "The coupon is burned"
        );
        return couponInfo[tokenId].currentStampNumber;
    }

    function getTotalStampNumber() external view returns (uint64) {
        return totalStampNumber;
    }

    function getCouponStatus(
        uint256 tokenId
    ) external view returns (CouponStatus) {
        return couponInfo[tokenId].couponStatus;
    }

    function _isFull(uint256 tokenId) internal view returns (bool) {
        return couponInfo[tokenId].currentStampNumber == totalStampNumber;
    }

    function isFull(uint256 tokenId) external view returns (bool) {
        require(
            couponInfo[tokenId].couponStatus != CouponStatus.BURNED,
            "The coupon is burned"
        );
        return _isFull(tokenId);
    }

    function isConsumed(uint256 tokenId) external view returns (bool) {
        require(
            couponInfo[tokenId].couponStatus != CouponStatus.BURNED,
            "The coupon is burned"
        );
        return couponInfo[tokenId].couponStatus == CouponStatus.CONSUMED;
    }

    function mintCoupon(
        address recipient
    ) external onlyContractOwner returns (uint256) {
        uint256 tokenId = ++latestTokenId;
        _mint(recipient, tokenId);
        couponInfo[tokenId].couponStatus = CouponStatus.AVAILABLE;
        couponInfo[tokenId].currentStampNumber = 0;
        return tokenId;
    }

    function burnCoupon(
        uint256 tokenId
    ) external onlyContractOwner returns (bool) {
        couponInfo[tokenId].couponStatus = CouponStatus.BURNED;
        _burn(tokenId);
        return true;
    }
}
