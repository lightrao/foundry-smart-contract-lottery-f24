// SPDX-License-Identifier: MIT

// @dev This contract has been adapted to fit with dappTools
pragma solidity ^0.8.0;

import {ERC20} from "@solmate/tokens/ERC20.sol";

interface ERC677Receiver {
    function onTokenTransfer(
        address _sender,
        uint256 _value,
        bytes memory _data
    ) external;
}

contract LinkToken is ERC20 {
    uint256 constant INITIAL_SUPPLY = 1000000000000000000000000;
    uint8 constant DECIMALS = 18;

    // Constructor function for the LinkToken contract
    constructor() ERC20("LinkToken", "LINK", DECIMALS) {
        // The constructor calls the constructor of the inherited ERC20 contract
        // "LinkToken" is the name of the token
        // "LINK" is the symbol of the token
        // DECIMALS is the number of decimal places the token uses, defined elsewhere in the contract

        _mint(msg.sender, INITIAL_SUPPLY);
        // This line mints the initial supply of tokens and assigns them to the deployer's address
        // msg.sender refers to the address deploying the contract
        // INITIAL_SUPPLY is the total number of tokens to be minted initially, defined elsewhere in the contract
    }

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data
    );

    /**
     * @dev transfer token to a contract address with additional data if the recipient is a contract.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     * @param _data The extra data to be passed to the receiving contract.
     */
    function transferAndCall(
        address _to,
        uint256 _value,
        bytes memory _data
    ) public virtual returns (bool success) {
        super.transfer(_to, _value);
        emit Transfer(msg.sender, _to, _value, _data);

        if (isContract(_to)) {
            contractFallback(_to, _value, _data);
        }
        return true;
    }

    // PRIVATE

    function contractFallback(
        address _to,
        uint256 _value,
        bytes memory _data
    ) private {
        ERC677Receiver receiver = ERC677Receiver(_to);

        // the LinkToken contract notifies the receiving contract that it has received a token transfer,
        // providing it with the sender's address, the amount of tokens transferred,
        // and any additional data that was included in the transfer.
        receiver.onTokenTransfer(msg.sender, _value, _data);
    }

    function isContract(address _addr) private view returns (bool hasCode) {
        uint256 length;

        // an inline assembly block, allowing for low-level operations and direct access to EVM instructions.
        assembly {
            // extcodesize: This is an EVM opcode that gets the size of the code stored at a specific address.
            length := extcodesize(_addr)
        }
        return length > 0;
    }
}
