// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    
    function run() external returns (MoodNft) {
        MoodNft moodNft;
        string memory happySvg = vm.readFile('./img/dynamicNft/happy.svg');
        string memory sadSvg = vm.readFile('./img/dynamicNft/sad.svg');

        vm.startBroadcast();
        moodNft = new MoodNft(svgToImageUri(happySvg), svgToImageUri(sadSvg));
        vm.stopBroadcast();
        return moodNft;
    }  

    function svgToImageUri(string memory svg) public pure returns (string memory) {
        // example:
        // '<svg width="500" height="500" viewBox="0 0 285 350" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill="black" d="M150,0,L75,200,L225,200,Z"></path></svg>'
        // will return 'data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94P....
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = 
                            Base64.encode(abi.encodePacked(svg));
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}