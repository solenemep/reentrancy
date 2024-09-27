// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

error WrongInit();
error NotPaying();
error FailedTransfer();

contract Lottery {
    uint256 private _winAmount = 0;

    constructor() payable {
        if (msg.value != 0.5 ether) revert WrongInit();
    }

    function play(uint256 guess) external payable returns (bool) {
        if (msg.value != 0.1 ether) revert NotPaying();

        uint256 rand = uint256(
            keccak256(
                abi.encode(
                    block.coinbase,
                    block.difficulty,
                    block.gaslimit,
                    block.number,
                    blockhash(block.number - 1),
                    block.timestamp,
                    tx.gasprice,
                    _winAmount,
                    address(this).balance
                )
            )
        );

        if (rand == guess) {
            (bool success, ) = payable(msg.sender).call{value: 0.2 ether}("");
            require(success, "Error while sending reward");

            _winAmount++;

            return true;
        }

        return false;
    }

    function hackCompleted() external view returns (bool) {
        return address(this).balance < 0.1 ether;
    }
}
