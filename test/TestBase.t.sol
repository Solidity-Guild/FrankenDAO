// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { DeployScript } from "../script/Deploy.s.sol";
import { Test } from "forge-std/Test.sol";

contract TestBase is Test, DeployScript {
    // Errors
    error NonExistentToken();
    error InvalidDelegation();
    error Paused();
    error InvalidParameter();
    error TokenLocked();
    error ZeroAddress();
    error AlreadyInitialized();
    error ParameterOutOfBounds();
    error InvalidId();
    error InvalidProposal();
    error InvalidStatus();
    error InvalidInput();
    error AlreadyQueued();
    error AlreadyVoted();
    error RequirementsNotMet();
    error NotEligible();
    error Unauthorized();
    error NotRefundable();
    error InsufficientRefundBalance();

    function setUp() virtual public {
        vm.createSelectFork("https://mainnet.infura.io/v3/324422b5714843da8a919967a9c652ac");
        deployAllContractsForTesting();
    }

    function dealRefundBalance() internal {
        vm.deal(address( staking ), 10 ether);
        vm.deal(address( govImpl ), 10 ether);
    }

    function setRefundStatus(uint256 _status) internal {
        require(_status <= 3);

        vm.prank(address(executor));
        staking.setRefund(_status);
    }

    function _generateAddress(string memory name) internal pure returns (address) {
        return address(uint160(uint(keccak256(abi.encodePacked(name)))));
    }
}
