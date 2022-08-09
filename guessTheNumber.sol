// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract guessTheNumber {
    // setting up original nparticipant
    constructor(uint _number) {
        number = _number;
        participantsCounter = 1;
    }

    // basic variables
    uint private number;
    address public winnersAddr;
    bool public won;
    uint public participantsCounter;
    mapping(address => bool) public registered;

    // struct for praticipants list
    struct Participant {
        address addr;
        string username;
        uint guessCounter;
    }
    mapping(uint => Participant) public participantsList;
    mapping(address => uint) public participantId;

    /// @dev register participant
    function register(string calldata _myName) external checkName(_myName) {
        require(!registered[msg.sender], "Already registered");
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
        ifGuessed
        threeAttempts
        ifRegistered
    {
        uint _index = participantId[msg.sender];
        Participant storage currentParticipant = participantsList[_index];
        currentParticipant.guessCounter++;
        require(_numberGuess < 10, "One digit number only");

        if (_numberGuess == number) {
            winnersAddr = msg.sender;
            won = true;
        }
    }

    // if not registered modifier
    modifier ifRegistered() {
        uint _index = participantId[msg.sender];
        require(msg.sender == participantsList[_index].addr, "Not registered");
        _;
    }
    // already guessed modifier
    modifier ifGuessed() {
        require(!won, "Number has already been guessed!");
        _;
    }

    // 3 attempts modifier
    modifier threeAttempts() {
        require(
            participantsList[participantId[msg.sender]].guessCounter < 3,
            "Too many attemnpts"
        );
        _;
    }

    // set the number
    function setNumber(uint _newNumber) public winnerOnly {
        require(_newNumber <= 9, "One digit number only");
        number = _newNumber;
        won = false;
    }

    // winner only modifier
    modifier winnerOnly() {
        require(winnersAddr == msg.sender, "You haven't guessed it!");
        _;
    }

    modifier checkName(string calldata _name) {
        require(bytes(_name).length > 0, "Empty name");
        _;
    }

    // function guessNumber shoudlnt be called after it being guessed and before setting new number, maybe
    // user should get a timer to set up the new number and if not set to default.
}
