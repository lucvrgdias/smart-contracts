pragma solidity >= 0.4.0 < 0.7.0;

import './StandardToken.sol';

contract HumanStandardToken is StandardToken {

    function () external {
        //if ether is sent to this address, send it back.
        revert();
    }

    /* Public variables of the token */

    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
    string public symbol;                 //An identifier: eg SBX
    string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.

    constructor (uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string memory _tokenSymbol) public {
        balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
        total_supply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        (bool ok, ) = _spender.call(abi.encode(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, address(this), _extraData));
        if(!ok)
        { 
            revert(); 
        }
        return true;
    }
}
