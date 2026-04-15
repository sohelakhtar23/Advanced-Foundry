// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;
    uint256 private s_tokenCounter;
    enum NFTState {
        HAPPY,
        SAD
    }
    mapping (uint256 => NFTState) private s_tokenIdToMood;

    error MoodNft__CantFlipMoodIfNotOwner();

    constructor(string memory happySvgImageUri, string memory sadSvgImageUri) ERC721("MoodNft", "MOOD") {
        s_happySvgImageUri = happySvgImageUri;
        s_sadSvgImageUri = sadSvgImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = NFTState.HAPPY;
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == NFTState.HAPPY) {
            imageUri = s_happySvgImageUri;
        } else {
            imageUri = s_sadSvgImageUri;
        }
        // below is a tokenURI str json like {name, description...}
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                name(),
                '", "description": "An NFT that changes based on mood", ',
                '"attributes": [{"trait_type": "moodiness", "value": 100}], ',
                '"image": "',
                imageUri,
                '"}'
            )
        );
        // check README file, there is eg
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function flipMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (s_tokenIdToMood[tokenId] == NFTState.HAPPY) {
            s_tokenIdToMood[tokenId] = NFTState.SAD;
        } else {
            s_tokenIdToMood[tokenId] = NFTState.HAPPY;
        }
    }


}