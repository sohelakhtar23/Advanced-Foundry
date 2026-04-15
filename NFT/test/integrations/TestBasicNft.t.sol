// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract TestBasicNft is Test {
    DeployBasicNft deployer;
    BasicNft public basicNft;

    address public USER = makeAddr("user");
    string public constant PUG_URI = 
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();

    }

    function testTokenNameIsCorrect() public view {
        string memory expected = "Doggie";
        assertEq(basicNft.name(), expected);

        // assert(basicNft.name() == expected);
        // the above assert will not work because it is comparing two strings, and in solidity, you cannot compare two strings directly. You need to use the keccak256 hash of the strings to compare them.
        // however assertEq will work, lets use assert with keccak256 hash
        assert(keccak256(abi.encodePacked(basicNft.name())) == keccak256(abi.encodePacked(expected)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG_URI)));
    }
}