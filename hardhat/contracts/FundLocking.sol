// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract FundLocking {

    address parentContract;
    address owner;

    mapping(address=>mapping(address=>uint)) holders;

    modifier onlyParentContract {
      require(msg.sender == parentContract);
      _;
    }

    modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }

    constructor(){
        owner=msg.sender;
    }

    function addParentContractAddress(address _parent) public onlyOwner{
        parentContract=_parent;
    }

    function addFund(address token,address holder, uint amount) external payable onlyParentContract{
        holders[token][holder]+=amount;
    }

    function withdrawFund(address token,address holder, uint amount) external payable onlyParentContract{
        require(amount<=holders[token][holder],"Insufficient amount");
        holders[token][holder]-=amount;
        ERC20(token).transfer(holder,amount);
    }
}
