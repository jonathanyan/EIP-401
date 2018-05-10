pragma solidity ^0.4.20;


contract FIP001Interface {
    function deposit(uint256 coins)  public returns (bool success);
    function depositTo(address to, uint256 coins)  public returns (bool success);
    function withdrawRequest(uint256 coins)  public returns (uint256 serialNumber);
    function withdrawConfirm(uint256 serailNumber, uint256 coins)  public returns (bool success);
    function withdrawCancel(uint256 serailNumber)  public returns (bool success);

    event DepositEvent(address indexed to, uint256 coins);
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

    function StandardFIP001() public {
        sequenceNumber = 0;
    }

    function deposit( uint256 coins)  public returns (bool) {
        require(coins > 0);
        //fip001Balance[] += msg.value;
        DepositEvent(msg.sender, coins);
        return true;
    }

    function depositTo(address to, uint256 coins)  public returns (bool) {
        require(coins > 0);
        fip001Balance[to] += coins;
        DepositEvent(msg.sender, coins);
        return true;
    }

    function withdrawRequest(uint256 coins)  public returns (uint256) {
        sequenceNumber += 1;
        uint256 serialNumber = sequenceNumber;
        fip001List[serialNumber] = FIP001Account(msg.sender, coins, 1);
        return serialNumber;
    }
    
    function withdrawConfirm(uint256 serialNumber, uint256 coins) public returns (bool) { 
        if (fip001List[serialNumber].status == 0) {
            return false;
        }
        if (fip001List[serialNumber].coins > coins) {
            return false;
        }
        fip001List[serialNumber].status == 1;
        WithdrawConfirmEvent(msg.sender, coins);
        return true;
    }
    function withdrawCancel(uint256 serialNumber)  public returns (bool) {
        if (fip001List[serialNumber].status == 0) {
            return false;
        }
        fip001List[serialNumber].status == 0;
        WithdrawCancelEvent(msg.sender, fip001List[serialNumber].coins);
        return true;
    }
}
