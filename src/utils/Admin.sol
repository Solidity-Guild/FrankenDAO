// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Admin {
    /// @notice Administrator roles for this contract
    address public founders;
    address public council;

    /// @notice Executor (Timelock) contract address
    address public executor;

    /// @notice Pending administrator addresses for this contract
    address public pendingFounders;
    address public pendingCouncil;

    /// @notice Emitted when pendingFounders or pendingCouncil is changed
    event NewPendingFounders(address oldPendingFounders, address newPendingFounders);
    event NewPendingCouncil(address oldPendingCouncil, address newPendingCouncil);

    /// @notice Emitted when pendingFounders or pendingCouncil is accepted,
    ///         which means admin roles updated
    event NewFounders(address oldFounders, address newFounders);
    event NewCouncil(address oldCouncil, address newCouncil);

    /**
     * @notice Begins transfer of founder rights. The newPendingFounders must call `_acceptFounders` to finalize the transfer.
     * @dev Founders function to begin change of founder. The newPendingFounders must call `_acceptFounders` to finalize the transfer.
     * @param newPendingFounders New pending founder.
     */
    function _setPendingFounders(address newPendingFounders) external {
        // @todo only the executor can set the founder role? (aside from in
        //       intialize)
        // Check caller = executor
        require(
            isAdmin(),
            "FrankenDAO::_setPendingFounders: executor only"
        );

        // Save current value, if any, for inclusion in log
        address oldPendingFounders = pendingFounders;

        // Store pendingFounders with value newPendingFounders
        pendingFounders = newPendingFounders;

        // Emit NewPendingFounders(oldPendingFounders, newPendingFounders)
        emit NewPendingFounders(oldPendingFounders, newPendingFounders);
    }

    /**
     * @notice Accepts transfer of founder rights. msg.sender must be pendingFounders
     * @dev Founders function for pending founder to accept role and update founder
     */
    function _acceptFounders() external {
        // Check caller is pendingFounders and pendingFounders ≠ address(0)
        // @todo why is the zero addr check needed? msg.sender will never be addr(0), can it?
        require(
            msg.sender == pendingFounders && msg.sender != address(0),
            "FrankenDAO::_acceptFounders: pending founder only"
        );

        // Save current values for inclusion in log
        address oldFounders = founders;
        address oldPendingFounders = pendingFounders;

        // Store founder with value pendingFounders
        founders = pendingFounders;

        // Clear the pending value
        pendingFounders = address(0);

        emit NewFounders(oldFounders, founders);
        emit NewPendingFounders(oldPendingFounders, pendingFounders);
    }

    /**
     * @notice Begins transfer of council rights. The newPendingCouncil must call `_acceptCouncil` to finalize the transfer.
     * @dev Council function to begin change of council. The newPendingCouncil must call `_acceptCouncil` to finalize the transfer.
     * @param newPendingCouncil New pending council.
     */
    function _setPendingCouncil(address newPendingCouncil) external {
        // @todo only the executor can set the council address? (aside from in intialize)
        // Check caller = executor
        require(
            canVeto,
            "FrankenDAO::_setPendingCouncil: executor only"
        );

        // Save current value, if any, for inclusion in log
        address oldPendingCouncil = pendingCouncil;

        // Store pendingCouncil with value newPendingCouncil
        pendingCouncil = newPendingCouncil;

        // Emit NewPendingCouncil(oldPendingCouncil, newPendingCouncil)
        emit NewPendingCouncil(oldPendingCouncil, newPendingCouncil);
    }

    /**
     * @notice Accepts transfer of council rights. msg.sender must be pendingCouncil
     * @dev Council function for pending council to accept role and update council
     */
    function _acceptCouncil() external {
        // Check caller is pendingCouncil and pendingCouncil ≠ address(0)
        // @todo why is the zero addr check needed? msg.sender will never be addr(0), can it?
        require(
            msg.sender == pendingCouncil && msg.sender != address(0),
            "FrankenDAO::_acceptCouncil: pending council only"
        );

        // Save current values for inclusion in log
        address oldCouncil = council;
        address oldPendingCouncil = pendingCouncil;

        // Store council with value pendingCouncil
        council = pendingCouncil;

        // Clear the pending value
        pendingCouncil = address(0);

        emit NewCouncil(oldCouncil, council);
        emit NewPendingCouncil(oldPendingCouncil, pendingCouncil);
    }

    /// @notice Helper that returns true if msg.sender is one of the admin
    ///         addresses on this contract (executor or founders);
    function isAdmin() internal returns (bool) {
        return (msg.sender == executor || msg.sender == founders);
    }

    /// @notice Helper that returns true if msg.sender has the power to veto
    function canVeto() internal returns (bool) {
        return (
            msg.sender == executor || 
            msg.sender == founders || 
            msg.sender == council
        );
    }
}
