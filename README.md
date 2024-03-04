# Abstraction

This standard is an extension of ERC-721 and defines standard functions outlining a scope for creating and using coupon in the form of NFT. NFT coupon is a non-fungible token that has stamp receiving spaces. When the coupon fulfills the required stamps, the coupon can be consumed which means that coupon can take effect or action in real or digital world.

# Motivation

As attempts to integrate Web3 and real-world assets have been made repeatedly, there has been a demand for NFTs that can function as coupons. The advantage of an NFT coupon lies in its value, regardless of whether the user fulfills the required conditions, as it can be easily and securely exchanged. This not only benefits users but also companies offering membership benefits. For instance, in Korea, mobile carriers or card companies may offer perks like free coffee after a user visits Starbucks 10 times. However, users often find these membership benefits uncomfortable due to their inability to meet the requirements. Consequently, users miss out on membership benefits, and companies waste their budgets. NFT coupons offer a solution, as owners can sell their active coupons to those in need. Furthermore, NFT coupons are not limited to real-world assets but can also be applied to digital assets, such as the gaming industry.

To provide a digital coupon service, businesses need to develop applications that users can use. However, small companies find it difficult to develop digital coupon services. By utilizing NFT coupons on the blockchain, we can easily issue digital coupon services using a simple web UI that we provide, and users can freely use them wherever the internet is available.

# Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “NOT RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in RFC 2119 and RFC 8174.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Coupon Non-Fungible Token Standard Based ERC-721 
interface IERC_CouponNFT {
    /**
     * @dev CouponStatus represents the token's current status
     */
    enum CouponStatus {
        AVAILABLE,
        CONSUMED,
        BURNED
    }

    /**
     * @param currentStampNumber Number of current recieved stamp
     * @param couponStatus status of coupon NFT
     */
    struct CouponInfo {
        uint64 currentStampNumber;
        CouponStatus couponStatus;
    }

    /**
     *@notice Emitted when stamp is added to the coupon NFT of tokenId
     */
    event AddStamp(uint256 indexed tokenId);

    /**
     *@notice Emitted when the coupon NFT of tokenId is consumed
     */
    event ConsumeCoupon(uint256 indexed tokenId);

    /**
    @notice add one stamp to the coupon NFT
    *@dev MUST revert if msg.sender is not the contract owner
    *MUST revert if coupon NFT is consumed or burned
    *MUST revert if coupon NFT's stamp receiving space is full 
    *MUST emit `AddStamp` event
    *@param tokenId  ID of the coupon NFT to add a stamp to
    */
    function addStampToCoupon(uint256 tokenId) external;

    /**
     *@notice consume the full stamp coupon NFT
     *@dev MUST revert if msg.sender is not the owner or approved user of the token
     *MUST revert if coupon NFT is consumed or burned
     *MUST revert if coupon NFT's stamp receiving space is not full
     *MUST emit `ConstumeCoupon` event
     *@param tokenId  ID of the coupon NFT to consume
     */
    function consumeCoupon(uint256 tokenId) external;

    /**
     *@notice return the number of current received stamps of the coupon NFT
     *@dev MUST revert if token is burned
     * returns 0 or throws error is tokenId is not valid
     *@param tokenId  ID of the coupon NFT to get the number of received stamps
     *@return the number of received stamps to the coupon NFT
     */
    function getCurrentStampNumber(
        uint256 tokenId
    ) external view returns (uint64);

    /**
     *@notice returns the maximum stamp number that a coupon NFT can receive
     *@return the number of stamp that the coupon NFT can receive
     */
    function getTotalStampNumber() external view returns (uint64);

    /**
     *@notice returns the current coupon status of the coupon NFT
     *@param tokenId  ID of the coupon NFT to get the coupon status
     *@return the CouponStatus of the coupon NFT
     */
    function getCouponStatus(
        uint256 tokenId
    ) external view returns (CouponStatus);

    /**
     *@notice Determines whether the coupon NFT has recieved full stamps
     *@dev MUST revert if token is burned
     *@return the boolean of whether the coupon NFT is full
     */
    function isFull(uint256 tokenId) external view returns (bool);

    /**
     *@notice Determines whether the coupon NFT has been consumed
     *@dev MUST revert if token is burned
     *@return the boolean of whether the coupon NFT is consumed
     */
    function isConsumed(uint256 tokenId) external view returns (bool);
}
```
