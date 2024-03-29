// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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
