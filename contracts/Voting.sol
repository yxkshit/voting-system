// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        string party;
        uint voteCount;
    }

    address public admin;
    bool public votingActive;
    uint public totalVotes;

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    mapping(address => bool) public registeredVoters;

    uint public candidateCount;

    event VoterRegistered(address voter);
    event VoteCast(address voter, uint candidateId);
    event VotingStarted();
    event VotingEnded();
    event CandidateAdded(uint id, string name, string party);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin");
        _;
    }

    modifier onlyActive() {
        require(votingActive, "Voting not active");
        _;
    }

    modifier onlyRegistered() {
        require(registeredVoters[msg.sender], "Not registered");
        _;
    }

    constructor() {
        admin = msg.sender;
        votingActive = false;
        totalVotes = 0;
    }

    function addCandidate(string memory _name, string memory _party) public onlyAdmin {
        require(!votingActive, "Cannot add candidate during voting");
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, _party, 0);
        emit CandidateAdded(candidateCount, _name, _party);
    }

    function registerVoter(address _voter) public onlyAdmin {
        require(!registeredVoters[_voter], "Already registered");
        registeredVoters[_voter] = true;
        emit VoterRegistered(_voter);
    }

    function startVoting() public onlyAdmin {
        require(candidateCount > 0, "No candidates");
        require(!votingActive, "Already active");
        votingActive = true;
        emit VotingStarted();
    }

    function endVoting() public onlyAdmin {
        require(votingActive, "Not active");
        votingActive = false;
        emit VotingEnded();
    }

    function castVote(uint _candidateId) public onlyActive onlyRegistered {
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        totalVotes++;

        emit VoteCast(msg.sender, _candidateId);
    }

    function getCandidate(uint _id) public view returns (
        uint, string memory, string memory, uint
    ) {
        Candidate memory c = candidates[_id];
        return (c.id, c.name, c.party, c.voteCount);
    }

    function getWinner() public view returns (string memory name, string memory party, uint voteCount) {
        require(!votingActive, "Voting still active");
        require(totalVotes > 0, "No votes cast");

        uint maxVotes = 0;
        uint winnerId = 0;
        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        Candidate memory w = candidates[winnerId];
        return (w.name, w.party, w.voteCount);
    }

    function isRegistered(address _voter) public view returns (bool) {
        return registeredVoters[_voter];
    }

    function hasVotedAlready(address _voter) public view returns (bool) {
        return hasVoted[_voter];
    }
}
