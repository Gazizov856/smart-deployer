// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./IUtilityContract.sol";

contract DeployManager is Ownable{

    event NewContractAdded(address _contractAddress, uint256 _fee, bool _isActive, uint256 _timeStamped);
    event ContractFeeUpdated(address _contractAddress, uint256 _oldFee, uint256 _newFee, uint256 _timestamp);
    event ContractStatusUpdated(address _contractAddress, bool _isActive, uint256 _timestamp);
    event NewDeployment(address _contractAddress, address deployer, uint256 _fee, uint256 _timeStamped);
     constructor() Ownable(msg.sender) {}

     struct ContractInfo{
        uint256 fee;
        bool isActive;
        uint256 registeredAt;
     }
     mapping(address=>address[]) public deployedContracts;
     mapping(address=>ContractInfo) public contractsData;

     error ContractNotActive();
     error NotEnoughFunds();
     error contractDoesNotExist();
     error InitializationFailed();
     error ContractIsNotRegistered();

     function deploy(address _utilityContract, bytes calldata _initData) external payable returns (address){
     ContractInfo memory info=contractsData[_utilityContract];
     require (info.isActive, ContractNotActive());
     require (msg.value>=info.fee, NotEnoughFunds());
     require (info.registeredAt>0, contractDoesNotExist());

     address clone = Clones.clone(_utilityContract);
     require(IUtilityContract(clone).initialize(_initData),InitializationFailed());
     payable(owner()).transfer(msg.value);
     deployedContracts[msg.sender].push(clone);
     emit NewDeployment(msg.sender, clone, msg.value, block.timestamp);
     return clone;
     }

     function addNewContract(address _contractAddress, uint256 _fee, bool _isActive) external onlyOwner{
     contractsData[_contractAddress]=ContractInfo({
         fee: _fee,
         isActive: _isActive,
         registeredAt: block.timestamp
         });
         emit NewContractAdded(_contractAddress, _fee, _isActive, block.timestamp);
     }
     function updateFee (address _contractAddress, uint256 _newFee) external onlyOwner {
       require(contractsData[_contractAddress].registeredAt>0, ContractIsNotRegistered());
        uint256 _oldFee=contractsData[_contractAddress].fee;
        contractsData[_contractAddress].fee=_newFee;
        emit ContractFeeUpdated(_contractAddress, _oldFee, _newFee, block.timestamp);

     }
     function deactivateContract(address _Address) external onlyOwner{
        require(contractsData[_Address].registeredAt>0, ContractIsNotRegistered());
         contractsData[_Address].isActive=false;
         emit ContractStatusUpdated(_Address, false, block.timestamp);
     }
      function activateContract(address _Address) external onlyOwner {
         require(contractsData[_Address].registeredAt>0, ContractIsNotRegistered());
         contractsData[_Address].isActive=true;
         emit ContractStatusUpdated(_Address, true, block.timestamp);
     }
}

