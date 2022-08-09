// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract guessTheNumber{

// setting up original nparticipant
    constructor(uint _number, string memory _myName){
        owner = msg.sender;
        number = _number;
        participantsList.push(participant(0x0000000000000000000000000000000000000000, _myName, 0, 0));
        participantsCounter = 1;
    }

// basic variables
    address private owner;
    uint private number;
    address public winnersAddr;
    uint public participantsCounter;
    mapping (address => uint) internal userCounter;
    
// struct for praticipants list
    struct participant {
        address addr;
        string username;
        uint counter;
        uint userId;
    }

    participant[] participantsList;

//register participant
    function username(string memory _myName) public {
        uint _index = participantsCounter - 1;
        participant storage party = participantsList[_index];
            if (msg.sender != party.addr) { 
            uint _idCounter = participantsCounter -1;
            participantsList.push(participant(msg.sender, _myName, 0, _idCounter));
            participantsCounter++;
                 } else {
            require(msg.sender != party.addr, "Already registered");
            participantsCounter++;
                }
    }

// update participant's username
    function updateUsername(string memory _newName) public {
        uint _index = participantsCounter - 1;
        participant storage party = participantsList[_index];
        if (msg.sender == party.addr) { 
            party.username = _newName;
            } else {
            require(msg.sender == party.addr, "You haven't registered yet");
            }
    }

//get participant
    function participantId(uint _index) public view returns(address, string memory, uint, uint) {
        participant storage party = participantsList[_index];
       return (party.addr, party.username, party.counter, party.userId);
    }

// guess the number
    function guessNumber(uint _numberGuess) threeAttempts() ifGuessed() ifRegistered() public {
        userCounter[msg.sender] ++;
        uint _index = participantsCounter - 1;
        participant storage _party = participantsList[_index];
        _party.counter++;
        require(_numberGuess < 10, "One digit number only");

                if (_numberGuess == number) {
                (winnersAddr = msg.sender);
                } else {
                }
    }

//if not registered modifier
    modifier ifRegistered() {
        uint _index = participantsCounter -1;
        participant storage party = participantsList[_index];
        require(msg.sender == party.addr,"Not registered");
        _;
    }
// already guessed modifier
    modifier ifGuessed() {
            require(msg.sender != winnersAddr,"YOU already guessed it!");
            _;
    }

// 3 attempts modifier
    modifier threeAttempts() {
        require(userCounter[msg.sender] < 3, "Too many attemnpts");
        _;
    }

// set the number
    function setNumber(uint _newNumber) public winnerOnly() {
        require(_newNumber <= 9,"One digit number only");
        number = _newNumber;
 
    }

// winner only modifier
    modifier winnerOnly() {
        require(winnersAddr == msg.sender, "You haven't guessed it!");
        _;
    }

// function guessNumber shoudlnt be called after it being guessed and before setting new number, maybe
// user should get a timer to set up the new number and if not set to default.
}
