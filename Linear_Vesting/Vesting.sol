//SPDX-License-Identifier: MIT
//Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.29;

import "./IUtilityContract.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vesting is IUtilityContract, Ownable{
    
constructor() Ownable(msg.sender){}

bool private initialized;
IERC20 public token;
address public beneficiary;
uint256 public totalAmount;
uint256 public startTime;
uint256 public cliff;
uint256 public duration;

error AlreadyInitialized();
  
  modifier notInitialized() {
        require(!initialized, AlreadyInitialized());
        _;
    }
function claim() public {}

function vestedAmount() public {
    uint256 passedTime=block.timestamp-(startTime+cliff);

}

function claimableAmount() public view {}





        function initialize(bytes memory _initData) external notInitialized returns(bool) {

        (address _token, uint256 _amount, address _treasury, address _owner) = abi.decode(_initData, (address, uint256, address, address));

      //  token = IERC20(_token);
       // amount = _amount;
       // treasury = _treasury;

        Ownable.transferOwnership(_owner);

        initialized = true;
        return true;
    }

     function getInitData(address _token, uint256 _amount, address _treasury, address _owner) external pure returns(bytes memory) {
        return abi.encode(_token, _amount, _treasury, _owner);
    }





}