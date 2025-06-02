// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

interface IUtilityContract{

    function initialize(bytes memory _initData) external returns(bool);
}

