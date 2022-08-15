// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract guessTheNumber {
    // setting up original nparticipant
    constructor(uint _number, uint _joiningFee, uint _winnerAmount) {
        number = _number;
        participantsCounter = 1;
        joiningFee = _joiningFee;
        winnerAmount = _winnerAmount;
    }

    // basic variables
    uint private number;
    address payable public winnersAddr;
    bool public won;
    uint public participantsCounter;
    uint public joiningFee;
    uint public winnerAmount;

    mapping(address => bool) public registered;

    // struct for praticipants list
    struct Participant {
        address addr;
        string username;
        uint guessCounter;
    }
    mapping(uint => Participant) public participantsList;
    mapping(address => uint) public participantId;

    modifier checkName(string calldata _name) {
        require(bytes(_name).length > 0, "Empty name");
        _;
    }

    /// @dev register participant
    function register(string calldata _myName) external payable checkName(_myName) {
        require(!registered[msg.sender], "Already registered");
        require( msg.value >= joiningFee, "insufficient joining fee");       
        participantsList[participantsCounter] = Participant(
            msg.sender,
            _myName,
            0
        );
        participantId[msg.sender] = participantsCounter;
        participantsCounter++;
    }

    /// @dev update participant's username
    function updateUsername(string calldata _newName)
        public
        checkName(_newName)
    {
        Participant storage currentParticipant = participantsList[
            participantId[msg.sender]
        ];
        require(
            currentParticipant.addr == msg.sender,
            "You're not the owner of this profile"
        );
        currentParticipant.username = _newName;
    }

    /// @dev get participant
    function getParticipant(uint _index)
        public
        view
        returns (
            address,
            string memory,
            uint
        )
    {
        Participant storage party = participantsList[_index];
        return (party.addr, party.username, party.guessCounter);
    }

    /// @dev guess the number
    function guessNumber(uint _numberGuess)
        public
    {
        require(!won, "Number has already been guessed!");
        require(
            participantsList[participantId[msg.sender]].guessCounter < 3,
            "Too many attemnpts"
        );
        uint _index = participantId[msg.sender];
        require(msg.sender == participantsList[_index].addr, "Not registered"); 
              
        Participant storage currentParticipant = participantsList[_index];
        currentParticipant.guessCounter++;
        require(_numberGuess < 10, "One digit number only");

        if (_numberGuess == number) {
            winnersAddr = payable(msg.sender);
            won = true;
            bool sent = winnersAddr.send(winnerAmount);
            require(sent, "Failed to send Ether");
        }
    }

    // set the number
    function setNumber(uint _newNumber) public  {
        require(_newNumber <= 9, "One digit number only");
        require(winnersAddr == msg.sender, "You haven't guessed it!");
        number = _newNumber;
        won = false;
    }
}

