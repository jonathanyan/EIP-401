pragma solidity ^0.4.20;

contract FIP001Interface {
    function deposit() payable public returns (bool success);
    function depositTo(address to) payable public returns (bool success);
    function withdrawRequest(uint256 coins) public returns (uint256 serialNumber);
    function withdrawConfirm(uint256 serailNumber) payable public returns (bool success);
    function withdrawCancel(uint256 serailNumber)  public returns (bool success);

    function getWithdrawBalance(uint256 serialNumber) public returns (uint256 coins);
    function getWithdrawRequest(uint256 serialNumber) public returns (uint256 coins);
    function getWithdrawConfirm(uint256 serialNumber) public returns (uint256 coins); 
    function getWithdrawHeight() public returns (uint256 sequenceNumber);
    function getWithdrawAddress(uint256 serialNumber) public returns (string accountAddress);

    event DepositEvent(address indexed to, uint256 coins);
    event WithdrawRequestEvent(address indexed to, uint256 coins);
    event WithdrawConfirmEvent(address indexed to, uint256 coins);
    event WithdrawCancelEvent(address indexed to, uint256 coins);
}

contract StandardFIP001 is FIP001Interface {

    struct FIP001Account {
        address from;
        address to;
        uint256 coins;
    }
    uint256 sequenceNumberWithdraw;
    uint256 sequenceNumberDeposit;
    mapping (uint256 => FIP001Account) internal fip001WithdrawRequest;
    mapping (uint256 => FIP001Account) internal fip001WithdrawConfirm;
    mapping (uint256 => FIP001Account) internal fip001Deposit;

    constructor() public {
        sequenceNumberWithdraw = 0;
        sequenceNumberDeposit = 0;
    }

    function deposit() payable public returns (bool) {
        return depositTo(address(this));
    }

    function depositTo(address to) payable public returns (bool) {
        require(msg.value > 0);
        sequenceNumberDeposit += 1;
        fip001Deposit[sequenceNumberDeposit] = FIP001Account(msg.sender, to, msg.value);
        emit DepositEvent(msg.sender, msg.value);
        return true;
    }

    function withdrawRequest(uint256 coins) public returns (uint256) {
        return withdrawRequestInternal(msg.sender, coins);
    }

    function withdrawRequestInternal(address to, uint256 coins)  private returns (uint256) {
        require(coins > 0);
        sequenceNumberWithdraw += 1;
        uint256 serialNumber = sequenceNumberWithdraw;
        fip001WithdrawRequest[serialNumber] = FIP001Account(address(this), to, coins);
        emit WithdrawRequestEvent(to, coins);
        return serialNumber;
    }
    
    function withdrawConfirm(uint256 serialNumber) payable public returns (bool) { 
        require(msg.value > 0 && serialNumber > 0 && serialNumber <= sequenceNumberWithdraw);
        if (fip001WithdrawConfirm[serialNumber].coins > 0 ) {
            fip001WithdrawConfirm[serialNumber].coins += msg.value;
        } else {
            fip001WithdrawConfirm[serialNumber] = FIP001Account(msg.sender, fip001WithdrawRequest[serialNumber].to, msg.value);
        }
        emit WithdrawConfirmEvent(msg.sender, fip001WithdrawConfirm[serialNumber].coins);
        return true;
    }

    function withdrawCancel(uint256 serialNumber) public returns (bool) {
        require(serialNumber > 0 && serialNumber <= sequenceNumberWithdraw);
        fip001WithdrawRequest[serialNumber].coins = 0;
        emit WithdrawCancelEvent(msg.sender, fip001WithdrawConfirm[serialNumber].coins);
        return true;
    }

    function getWithdrawBalance(uint256 serialNumber) public returns (uint256) {
        require(serialNumber > 0 && serialNumber <= sequenceNumberWithdraw);
        if (fip001WithdrawRequest[serialNumber].coins <= fip001WithdrawConfirm[serialNumber].coins) 
            return 0;
        return fip001WithdrawRequest[serialNumber].coins - fip001WithdrawConfirm[serialNumber].coins;
    }

    function getWithdrawRequest(uint256 serialNumber) public returns (uint256) {
        return fip001WithdrawRequest[serialNumber].coins;
    }

    function getWithdrawConfirm(uint256 serialNumber) public returns (uint256) {
        return fip001WithdrawConfirm[serialNumber].coins;
    }

    function getWithdrawAddress(uint256 serialNumber) public returns (string) {
        require(serialNumber > 0 && serialNumber <= sequenceNumberWithdraw);
        bytes memory b = new bytes(20);
        for (uint i = 0; i < 20; i++) {
            b[i] = byte(uint8(uint(fip001WithdrawRequest[serialNumber].to) / (2**(8*(19 - i)))));
        }
        return string(b);
    }

    function getWithdrawHeight() public returns (uint256) {
        return sequenceNumberWithdraw;
    }
}