// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Script, console} from "lib/forge-std/src/Script.sol";

import "src/Lottery.sol";
import "src/Attacker.sol";

contract WithdrawkScript is Script {
    Lottery public lottery;
    Attacker public attacker;

    address public owner;

    function setUp() public {
        lottery = Lottery(payable(vm.envAddress("LOTTERY_ADDRESS")));
        attacker = Attacker(payable(vm.envAddress("ATTACKER_ADDRESS")));

        owner = vm.addr(vm.envUint("PRIVATE_KEY"));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("owner balance before", owner.balance);
        console.log("attacker balance before", address(attacker).balance);

        attacker.withdraw();

        console.log("owner balance after", owner.balance);
        console.log("attacker balance after", address(attacker).balance);

        vm.stopBroadcast();
    }
}
