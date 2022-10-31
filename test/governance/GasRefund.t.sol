// pragma solidity ^0.8.13;

// import { GovernanceBase } from "../bases/GovernanceBase.t.sol";
// import { IGovernance } from "../../src/interfaces/IGovernance.sol";
// import "forge-std/Test.sol";

// contract GasRefundTests is GovernanceBase {
//     /**********************
//      *      Admin
//      **********************/

//     // Test that executor can turn off gas refunds
//     function testGovGasRefund__ExecutorCanTurnOffGasRefunds() public {
//         (
//             address[] memory targets,
//             uint256[] memory values,
//             string[] memory sigs,
//             bytes[] memory calldatas
//         ) = _generateFakeProposalData();

//         sigs[0] = "setRefund(uint8)";
//         calldatas[0] = abi.encode(IGovernance.RefundStatus.NoRefunds);

//         vm.prank(proposer);
//         uint proposalId = gov.propose(targets, values, sigs, calldatas, "test");

//         vm.prank(COUNCIL_MULTISIG);
//         gov.verifyProposal(proposalId);

//         vm.warp(block.timestamp + gov.votingDelay());

//         _vote(proposalId, 1, true); // voter votes for proposal

//         vm.warp(block.timestamp + gov.votingPeriod() + 1);

//         gov.queue(proposalId);

//         vm.warp(block.timestamp + executor.DELAY());

//         IGovernance.RefundStatus refund = gov.refund();
//         assert(refund == IGovernance.RefundStatus.VotingAndProposalRefund);

//         gov.execute(proposalId);

//         IGovernance.RefundStatus newRefund = gov.refund();
//         assert(newRefund == IGovernance.RefundStatus.NoRefunds);
//     }

//     /**********************
//      *      Proposing
//      **********************/
//     // Changing refund RefundStatus
//     function testGovGasRefund__ExecutorCanSetRefundStatus() public {
//         //VotingAndProposalRefund (defualt)
//         assertEq(
//             uint( gov.refund() ),
//             uint( IGovernance.RefundStatus.VotingAndProposalRefund)
//         );
//         //VotingRefund
//         setGovernanceRefundStatus(IGovernance.RefundStatus.VotingRefund);
//         assertEq(
//             uint( gov.refund() ),
//             uint( IGovernance.RefundStatus.VotingRefund)
//         );
//         //ProposalRefund
//         setGovernanceRefundStatus(IGovernance.RefundStatus.ProposalRefund);
//         assertEq(
//             uint( gov.refund() ),
//             uint( IGovernance.RefundStatus.ProposalRefund)
//         );
//         //NoRefunds (Default)
//         setGovernanceRefundStatus(IGovernance.RefundStatus.NoRefunds);
//         assertEq(
//             uint( gov.refund() ),
//             uint( IGovernance.RefundStatus.NoRefunds)
//         );
//     }
//     // reverts if insufficient balance: proposing
//     function testGovGasRefund__ProposingRevertsIfInsufficientBalance() public {
//         (
//             address[] memory targets, 
//             uint[] memory values, 
//             string[] memory sigs, 
//             bytes[] memory calldatas
//         ) = _generateFakeProposalData();

//         vm.prank(proposer);

//         vm.expectRevert(InsufficientRefundBalance.selector);
//         gov.proposeWithRefund(targets, values, sigs, calldatas, "test");
//     }
//     // reverts if refunding is turned off: proposing
//     function testGovGasRefund__RevertsIfRefundingOffForProposing() public {
//         dealRefundBalance();
//         (
//             address[] memory targets, 
//             uint[] memory values, 
//             string[] memory sigs, 
//             bytes[] memory calldatas
//         ) = _generateFakeProposalData();

//         setGovernanceRefundStatus(IGovernance.RefundStatus.NoRefunds);

//         vm.startPrank(proposer);
//         vm.expectRevert(NotRefundable.selector);
//         gov.proposeWithRefund(targets, values, sigs, calldatas, "test");
//     }
//     // refund gas for proposing
//     function testGovGasRefund__RefundsGasForProposing() public {
//         dealRefundBalance();
//         setGovernanceRefundStatus(IGovernance.RefundStatus.VotingAndProposalRefund);

//         uint startingBalance = proposer.balance;

//         (
//             address[] memory targets, 
//             uint[] memory values, 
//             string[] memory sigs, 
//             bytes[] memory calldatas
//         ) = _generateFakeProposalData();

//         vm.prank(proposer);
//         gov.proposeWithRefund(targets, values, sigs, calldatas, "test");

//         uint endingBalance = proposer.balance;

//         assertEq(startingBalance, endingBalance);
//     }

//     /**********************
//      *      Voting
//      **********************/
//     // reverts if insufficient balance: voting
//     function testGovGasRefund__VotingRevertsIfInsufficientBalance() public {
//         uint proposalId = _createAndVerifyProposal();

//         vm.prank(proposer);
//         vm.expectRevert(InsufficientRefundBalance.selector);
//         gov.castVoteWithRefund(proposalId, 1);
//     }

//     // reverts if refunding is turned off: voting
//     function testGovGasRefund__RevertsIfRefundingOffForVoting() public {
//         dealRefundBalance();
//         uint proposalId = _createAndVerifyProposal();

//         setGovernanceRefundStatus(IGovernance.RefundStatus.NoRefunds);

//         vm.prank(proposer);
//         vm.expectRevert(NotRefundable.selector);
//         gov.castVoteWithRefund(proposalId, 1);
//     }

//     // refunds gas for voting
//     function testGovGasRefund__RefundsGasForVoting() public {
//         dealRefundBalance();
//         uint proposalId = _createProposal();

//         vm.prank(COUNCIL_MULTISIG);
//         gov.verifyProposal(proposalId);

//         vm.warp(block.timestamp + gov.votingDelay());

//         uint startingBalance = voter.balance;

//         vm.prank(voter);
//         gov.castVoteWithRefund(proposalId, 1);

//         uint endingBalance = voter.balance;

//         assertEq(
//             startingBalance,
//             endingBalance
//         );
//     }
// }
