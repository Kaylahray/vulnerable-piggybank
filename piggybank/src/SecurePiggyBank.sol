// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecurePiggyBank {
    address public owner;
    uint256 public totalBalance;
    
    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed withdrawer, uint256 amount);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }
    
    function deposit() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        totalBalance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    function withdraw() public onlyOwner {
        require(totalBalance > 0, "No funds to withdraw");
        uint256 amount = totalBalance;
        totalBalance = 0;
        
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, amount);
    }
}
