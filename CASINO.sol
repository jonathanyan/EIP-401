pragma solidity ^0.4.24;


contract CASINO {
    uint256 constant private CHAIN_PHASE_PLAYER = 2;
    uint256 constant private MAX_REGISTER = 1000;
    uint256 constant private REGISTER_REWARD = 100;
    uint256 constant private WINNER_BUFFER_SIZE = 1000;

    uint256 public totalSupply;
    uint256 public totalPlayer;
    uint256 public phaseIndex;
    uint256 public phaseHeight;
    uint256 public userIndex;
    address[MAX_REGISTER] public addressLookup;
    address[WINNER_BUFFER_SIZE][CHAIN_PHASE_PLAYER] public winners;
    uint256[WINNER_BUFFER_SIZE] public winnersHeight;
    mapping (address => uint256) public balances;
    

    constructor() public {

        balances[msg.sender] = 21000000;
        totalSupply = 21000000;
        totalPlayer = 0;
        userIndex = 0;
        phaseIndex = 0;
        phaseHeight = 0;
    }

    function register(address _addr) public returns (bool success) {

        balances[_addr] = REGISTER_REWARD;
        addressLookup[userIndex] = _addr;
        userIndex += 1;
        if ( userIndex >= MAX_REGISTER ) userIndex = 0;
        totalPlayer += 1;
        if ( totalPlayer >= MAX_REGISTER )  totalPlayer = MAX_REGISTER;

        return true;
    }

    function getTotalPlayer() public view returns (uint256 numPlayer) {
        uint256 j = 0;
        for ( uint i = 0; i < MAX_REGISTER; ++i) {
            if ( balances[addressLookup[i]] > 0 ) j += 1;
        }
        return j;
    }

    function isWinnerId(uint256 seq, uint256 winnerList) private pure returns (bool success) {
        uint256 w = winnerList;
        for ( uint m = 0; m < CHAIN_PHASE_PLAYER; ++m ) {
            uint256 u = (w & 0xffff);
            if ( seq == u) return true;
            w = (w >> 4); 
        }
        return false;
    }

    function setNextWinners(uint256 currentPhase, uint256 winnerList) public returns (bool success) {

        require(currentPhase == phaseHeight);

        uint256 j = 0;
        uint256 k = 0;
      
        phaseHeight += 1;

        for ( uint i = 0; i < totalPlayer; ++i ) {

            if ( balances[addressLookup[i]] == 0 ) continue;

            balances[addressLookup[i]] -= 1;  

            k += 1;

            if ( isWinnerId(k, winnerList) ) {
                winners[phaseIndex][j] = addressLookup[i];
                j += 1;
            }
        } 
        
        winnersHeight[phaseIndex] = phaseHeight;

        phaseIndex = ( (phaseIndex + 1) % WINNER_BUFFER_SIZE );

        return true;
    }

    function isWinnerMe(uint256 currentPhase) public view returns (bool success) {
        if (currentPhase > phaseHeight || currentPhase + WINNER_BUFFER_SIZE <= phaseHeight) {
            return false;
        }

        for ( uint i = 0 ; i < CHAIN_PHASE_PLAYER; ++i ) {
            if ( winners[currentPhase % WINNER_BUFFER_SIZE][i] == msg.sender ) {
                return true;
            }
        }

        return false;
    } 

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}
