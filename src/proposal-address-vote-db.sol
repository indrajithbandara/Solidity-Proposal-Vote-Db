pragma solidity ^0.4.0;

import "ds-auth/DSAuth.sol";
import "ds-base/base.sol";

contract ProposalVoteDb is DSAuth, DSBase {

  struct Vote {
    bool hasVoted,
    bool position
  }

  struct Proposal {
    uint eip,     // eip reference
    mapping (bytes32 => Vote) votes // map devcon 2 token ID to vote
    uint inFavor, // tally
    uint against, // tally
  }

  // Mapping eip number to proposal arrays
  mapping (uint => bytes32[]) eipIndex;

  // Mapping proposal ID to proposal struct
  mapping (bytes32 => Proposal) proposals;

  function addProposal auth (uint _eip, bytes32 _proposal) {
    eipIndex[_eip] = _proposal;
    proposals.push(Proposal({
      eip: _eip,
      inFavor: 0,
      against: 0,
    }));
  }

  function setVote auth (bytes32 _proposal, bytes32 _voter, bool _position) {
    Vote _vote = getVote(_proposal, _voter);
    _vote.position = _position;
  }

  function getVote (bytes32 _proposal, bytes32 _voter) returns (bool) {
    Vote _vote = proposals[_proposal].votes[_voter];
    if (!_vote.hasVoted) {
      throw;
    }
    return _vote.position;
  }

}