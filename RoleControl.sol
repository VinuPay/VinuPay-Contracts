// SPDX-License-Identifier: MIT - (c) iMalFect
pragma solidity ^0.8.0;

contract RoleControl {
    mapping(bytes32 => address) private _roles;
    
    /**
    * @dev Emitted when role holder is changed
    */
    event RoleHolderChanged(bytes32 indexed role, address previousHolder, address newHolder);

    /**
    * @dev Setup Role (internal).
    * @param roleId Role ID.
    * @param roleHolder Role holder address.
    */
    function _setupRole(bytes32 roleId, address roleHolder) internal {
        _roles[roleId] = roleHolder;
    }

    /**
    * @dev Transfer Role (internal).
    * @param roleId Role ID.
    * @param newRoleHolder Role holder address.
    */
    function _transferRole(bytes32 roleId, address newRoleHolder) internal {
        _roles[roleId] = newRoleHolder;
        emit RoleHolderChanged(roleId, _roles[roleId], newRoleHolder);
    }

    /**
    * @dev Return `true` if role holder is address(0x0)
    * @param roleId Role ID.
    */
    function _isRoleRenounced(bytes32 roleId) internal view returns (bool) {
        return _roles[roleId] == address(0);
    }
    
    // Public functions

    /**
    * @dev Return current role holder
    * @param roleId Role ID.
    */
    function getRoleHolder(bytes32 roleId) public view returns (address) {
        return _roles[roleId];
    }

    /**
    * @dev Transfer role to another address, only role holder can do this. Public function
    * @param roleId Role ID.
    * @param newRoleHolder Role holder address.
    */    
    function transferRole(bytes32 roleId, address newRoleHolder) public {
        require(_roles[roleId] == msg.sender, "RoleControl: caller is not the role holder");
        _transferRole(roleId, newRoleHolder);
    }

    /**
    * @dev Renounce role (setting the holder to address(0)), public.
    * @param roleId Role ID.
    */
    function renounceRole(bytes32 roleId) public {
        require(_roles[roleId] == msg.sender, "RoleControl: caller is not the role holder");
        _transferRole(roleId, address(0));
    }

    /**
    * @dev Modifier to allow access to the function only to a specific role
    * @param roleId Role ID.
    */
    modifier onlyRole(bytes32 roleId) {
        require(_roles[roleId] == msg.sender, "RoleControl: caller is not the role holder");
        _;
    }

}
