pragma solidity ^0.4.20;


contract FIP001Interface {
    function deposit(uint256 coins)  public returns (bool success);
    function depositTo(address to, uint256 coins)  public returns (bool success);
    function withdrawRequest(uint256 coins)  public returns (uint256 serialNumber);
    function withdrawConfirm(uint256 serailNumber, uint256 coins)  public returns (bool success);
    function withdrawCancel(uint256 serailNumber)  public returns (bool success);
    function getWithdrawBalance(uint256 serialNumber) public returns (uint256 coins);
    function getWithdrawHeight() public returns (uint256 sequenceNumber);
    function getWithdrawAddress(uint256 serialNumber) public returns (bytes accountAddress);

    event DepositEvent(address indexed to, uint256 coins);
    event WithdrawRequestEvent(address indexed to, uint256 coins);
    event WithdrawConfirmEvent(address indexed to, uint256 coins);
    event WithdrawCancelEvent(address indexed to, uint256 coins);
}

contract StandardFIP001 is FIP001Interface {

    struct FIP001Account {
        address addr;
        uint256 coins;
        uint status;
    }
    uint256 sequenceNumber;
    mapping (uint256 => FIP001Account) internal fip001List;
    mapping (address => uint256) internal fip001Balance;
    bytes internal b;

    constructor() public {
        sequenceNumber = 0;
    }

    function deposit( uint256 coins)  public returns (bool) {
        if (coins <= 0) return false;
        //fip001Balance[] += msg.value;
        emit DepositEvent(msg.sender, coins);
        return true;
    }

    function depositTo(address to, uint256 coins)  public returns (bool) {
        if (coins <= 0) return false;
        fip001Balance[to] += coins;
        emit DepositEvent(msg.sender, coins);
        return true;
    }

    function withdrawRequest(uint256 coins)  public returns (uint256) {
        sequenceNumber += 1;
        uint256 serialNumber = sequenceNumber;
        fip001List[serialNumber] = FIP001Account(msg.sender, coins, 1);
        emit WithdrawRequestEvent(msg.sender, coins);
        return serialNumber;
    }
    
    function withdrawConfirm(uint256 serialNumber, uint256 coins) public returns (bool) { 
        if (fip001List[serialNumber].status == 0) {
            return false;
        }
        if (fip001List[serialNumber].coins > coins) {
            return false;
        }
        fip001List[serialNumber].status == 0;
        emit WithdrawConfirmEvent(msg.sender, coins);
        return true;
    }

    function withdrawCancel(uint256 serialNumber) public returns (bool) {
        if (fip001List[serialNumber].status == 0) {
            return false;
        }
        fip001List[serialNumber].status == 0;
        emit WithdrawCancelEvent(msg.sender, fip001List[serialNumber].coins);
        return true;
    }

    function getWithdrawBalance(uint256 serialNumber) public returns (uint256) {
        if (serialNumber == 0 || serialNumber > sequenceNumber ) return 0;
        if (fip001List[serialNumber].status == 0) return 0;
        return fip001List[serialNumber].coins;
    }

    function getWithdrawAddress(uint256 serialNumber) public returns (bytes) {
        if (serialNumber == 0 || serialNumber > sequenceNumber ) return new bytes(20);
        if (fip001List[serialNumber].status == 0) return new bytes(20);
        b = new bytes(20);
        for (uint i = 0; i < 20; i++)
            b[i] = byte(uint8(uint(fip001List[serialNumber].addr) / (2**(8*(19 - i)))));
        return b;
    }

    function getWithdrawHeight() public returns (uint256) {
        return sequenceNumber;
    }
}