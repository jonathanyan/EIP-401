pragma solidity ^0.4.23;

contract Faucet {
    uint constant COIN = 100000000;

    function() payable public {
        this.deposit.value(msg.value)();
    }

    function deposit() public payable {
    }
    
    function withdraw() public returns (bool) {
        uint amount = 100 * COIN;
        if(address(this).balance < 100 * COIN){
            amount = address(this).balance;
        }
        msg.sender.transfer(amount);
        return true;
    }

    function send(address a) public returns (bool) {
        uint amount = 100 * COIN;
        if( address(this).balance < 100 * COIN ){
            amount = address(this).balance;
        }
        a.transfer(amount);
        return true;
    }
}