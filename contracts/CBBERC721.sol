// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CBBToken is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    address private cnbAddress;

    struct TokenMetadata {
        address burner;
        uint256 amountBurned;
        uint256 timestamp;
    }

    mapping(uint256 => TokenMetadata) tokensMetadata;

    constructor(address _cnbAddress) ERC721("Carbon Bond Burned", "CBB") {
        cnbAddress = _cnbAddress;
        transferOwnership(_cnbAddress);
    }

    function createToken(address burner, uint256 amountBurned)
        external
        onlyOwner
        returns (uint256)
    {
        uint tokenId = _tokenIds.current();
        _safeMint(burner, tokenId);
        tokensMetadata[tokenId] = TokenMetadata(
            burner,
            amountBurned,
            block.timestamp
        );
        _tokenIds.increment();
        return tokenId;
    }
}
