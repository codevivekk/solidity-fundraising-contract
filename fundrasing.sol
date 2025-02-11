// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fundraising {
    address immutable Owner;
    uint256 public totalFunds = 0;
    uint256 public requriedFunds = 200000;
    bool public isCompleted;
    uint256 public deadline;

    mapping(address => uint256) public contributions;

    constructor() {
        Owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == Owner, "Not the owner");
        _;
    }

    modifier validAmount() {
        require(msg.value > 0, "Contribution must be greater than zero");
        _;
    }

    function raiseFunds() external payable validAmount {
        contributions[msg.sender] += msg.value;
         unchecked {
            totalFunds += msg.value;
        }

        if (totalFunds >= requriedFunds) {
            isCompleted = true;
        }
    }

    function withdrawFunds() public onlyOwner {
        require(!isCompleted, "Fundraising is not completed yet");
        uint256 amount = totalFunds;
        totalFunds = 0;
        payable(Owner).transfer(amount);
    }

    function getRefund() public {
        uint256 contribution = contributions[msg.sender];
        require(
            isCompleted,
            "Sorry you cannot withdraw funds beacuse fundrasing is completed"
        );
        require(contribution > 0, "No Contribution done by you");
        totalFunds -= contribution;
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contribution);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
