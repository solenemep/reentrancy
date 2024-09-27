// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "lib/forge-std/src/Script.sol";

import "src/Lottery.sol";
import "src/Attacker.sol";

contract DeployScript is Script {
    Lottery public lottery;
    Attacker public attacker;

    uint256 public deployAmount = 0.5 ether;
    uint256 public playAmount = 0.1 ether;

    function setUp() public {
        lottery = Lottery(vm.envAddress("LOTTERY_ADDRESS"));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        lottery = new Lottery{value: deployAmount}();
        console.log("lottery address", address(lottery));

        uint256 winAmount = uint256(
            vm.load(address(lottery), bytes32(uint256(0)))
        );
        console.log("winAmount", winAmount);

        attacker = new Attacker{value: playAmount}(address(lottery), winAmount);
        console.log("attacker address", address(attacker));

        console.log("lottery balance before", address(lottery).balance);
        console.log("attacker balance before", address(attacker).balance);

        vm.stopBroadcast();
    }
}
