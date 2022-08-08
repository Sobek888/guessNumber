// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract guessTheNumber{

// setting up original number and owner address
    constructor(uint _number, string memory _myName){
        number = _number;
        owner = msg.sender;
        participantList.push(participants(0x0000000000000000000000000000000000000000, _myName, 0, 0));
        participantsCounter = 1;
    }

// basic variables
    address private owner;
    uint private number;
    address public winnersAddr;
    uint public participantsCounter;
    mapping (address => uint) userCounter;
    
// struct for praticipants list
    struct participants {
        address addr;
        string username;
        uint counter;
        uint userId;
    }

    mapping (address => mapping (uint => participants[])) participant;
    participants[] participantList;

//register participant
    function username(string memory _myName) public {
        participantsCounter++;
        uint _idCounter = participantsCounter -1;
       participantList.push(participants(msg.sender, _myName, 0, _idCounter));
    }

//get participant
    function participantId(uint _index) public view returns(address, string memory, uint, uint) {
        participants storage party = participantList[_index];
       return (party.addr, party.username, party.counter, party.userId);
    }

// guess the number
    function guessNumber(uint _numberGuess) public {
        require(_numberGuess < 10, "One digit number only");
        require(userCounter[msg.sender] < 4, "Too many attemnpts");
            if (_numberGuess == number) {
                (winnersAddr = msg.sender);
            } else {
            userCounter[msg.sender] ++;
                }
        }
    }

// set the number
    function setNumber(uint _newNumber) public winnerOnly() {
        require(_newNumber <= 9,"One digit number only");
        number = _newNumber;
 
    }

// winner only modifier
    modifier winnerOnly() {
        require(winnersAddr == msg.sender);
        _;
    }

// function guessNumber shoudlnt be called after it being guessed and before setting new number, maybe
// user should get a timer to set up the new number, if not set to default.
// if the address has registered, shouldnt create another position and get an error when calling same function,
// but have possibility to update own usernam
}
