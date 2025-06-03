// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import "./IUtilityContract.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract ErcAirDropper is IUtilityContract{

   error AlreadyInitialized();

   modifier notInitialized(){
   require(!initialized, AlreadyInitialized());
   _;
   }
   
   
    uint256 public number;
    address public bigBoss;
    bool private initialized;
    IERC20 public token;
    uint256 public amount;

    constructor(address _tokenAddress, uint256 _airdropAmount) {
    amount=_airdropAmount;
    token=IERC20(_tokenAddress);
  }

      function initialize(bytes memory _initData) external notInitialized returns (bool){
       
      
      (uint256 _number, address _bigBoss)=abi.decode(_initData,(uint256,address));
      number=_number;
      bigBoss=_bigBoss;
      initialized=true;
      return true;

      }
      
      function getInitData(uint256 _number, address _bigBoss) external pure returns (bytes memory){
        return abi.encode(_number,_bigBoss);
      }
         function showInitData() external view returns (uint256, address){

return (number,bigBoss);
      }

  

      function airdrop(address[] calldata receivers, uint256[] calldata amounts) external{

require(receivers.length==amounts.length, "arrays length dismatch");
require(token.allowance(msg.sender, address(this))>=amount, "not enough approved tokens");

for (uint256 i = 0; i < receivers.length;i++){
 
require (token.transferFrom(msg.sender, receivers[i], amounts[i]), "transfer failed");

}


  }

}