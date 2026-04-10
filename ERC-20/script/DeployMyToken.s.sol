// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MyToken} from "../src/MyToken.sol";
import {Script} from "forge-std/Script.sol";

contract DeployMyToken is Script {
    uint256 initialSupply = 100 ether;

    function run() external returns (MyToken) {
        vm.startBroadcast();
        MyToken myToken = new MyToken(initialSupply);
        vm.stopBroadcast();
        return myToken;
    }

}