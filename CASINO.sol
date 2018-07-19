


pragma solidity ^0.4.24;


contract CASINO {
    uint256 constant private MAX_REGISTER = 10000;
    uint256 constant private REGISTER_REWARD = 100;
    uint256 public totalSupply;
    uint256 public userIndex;
    address[MAX_REGISTER] public addressLookup;
    mapping (address => uint256) public balances;
    

    constructor() public {
        balances[msg.sender] = 21000000;
        totalSupply = 21000000;
        userIndex = 0;
    }

    function register(address _addr) public returns (bool success) {
        balances[_addr] = REGISTER_REWARD;
        addressLookup[userIndex] = _addr;
        userIndex += 1;
        if ( userIndex >= MAX_REGISTER ) userIndex = 0;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
