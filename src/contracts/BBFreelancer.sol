/**
 * Created on 2018-08-13 10:20
 * @summary: 
 * @author: Chris Nguyen
 */
pragma solidity ^0.4.24;

import './BBStorage.sol';
import './zeppelin/ownership/Ownable.sol';
import './zeppelin/math/SafeMath.sol';
import './zeppelin/token/ERC20/ERC20.sol';


/**
 * @title Freelancer contract 
 */
contract BBFreelancer is Ownable{
  using SafeMath for uint256;
  BBStorage bbs = BBStorage(0x0);
  ERC20 public bbo = ERC20(0x0);
  // global constant key
  bytes constant public PAYMENT_LIMIT_TIMESTAMP = 'PaymentLimitTimestamp';
  bytes constant public FREELANCER_VOTING_STACK_TOKENS = 'FreelancerVotingStackTokens';
  // per job constant key
  bytes constant public FREELANCER = 'freelancer';
  bytes constant public STATUS = 'status';
  bytes constant public CANCEL = 'cancel';
  bytes constant public BUDGET = 'budget';
  bytes constant public BID = 'bid';
  bytes constant public BID_COUNTER = 'bidCount';
  bytes constant public EXPIRED = 'expired';
  bytes constant public JOB_FINISHED_TIMESTAMP = 'finishedTimestamp';
  bytes constant public PAYMENT_FINALIZED = 'isFinalized';
  bytes constant public DISPUTE_WINNER = 'disputedWinner';
  /**
   * @dev set storage contract address
   * @param storageAddress Address of the Storage Contract
   */
  function setStorage(address storageAddress) onlyOwner public {
    bbs = BBStorage(storageAddress);
  }
  /**
   * @dev get storage contract address
   */
  function getStorage() onlyOwner public returns(address){
    return bbs;
  }

  /**
   * @dev set BBO contract address
   * @param BBOAddress Address of the BBO token
   */
  function setBBO(address BBOAddress) onlyOwner public {
    bbo = ERC20(BBOAddress);
  }

  modifier jobNotExist(bytes jobHash){
    require(bbs.getAddress(keccak256(jobHash)) == 0x0);
    _;
  }
  modifier isFreelancerOfJob(bytes jobHash){
    require(bbs.getAddress(keccak256(abi.encodePacked(jobHash,FREELANCER))) == msg.sender);
    _;
  }
  modifier isNotOwnerJob(bytes jobHash){
    address jobOwner = bbs.getAddress(keccak256(jobHash));
    // not owner
    require(jobOwner!=0x0);
    // not owner
    require(msg.sender != jobOwner);
    _;
  }
  modifier isOwnerJob(bytes jobHash){
    require(bbs.getAddress(keccak256(jobHash))==msg.sender);
    _;
  }

  modifier jobNotStarted(bytes jobHash){
    require(bbs.getUint(keccak256(abi.encodePacked(jobHash, STATUS))) == 0x0);
    _;
  }
  modifier isNotCanceled(bytes jobHash){
    require(bbs.getBool(keccak256(abi.encodePacked(jobHash, CANCEL))) !=true);
    _;
  }
}