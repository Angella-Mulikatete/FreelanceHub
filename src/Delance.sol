// SPDX-License-Identifier: MIT
pragma solidity >=0.3.2 <0.9.0;

contract Delance {

    address payable public freelancer;
    uint public deadline;
    address public employer;
    uint public price;
    bool locked = false;

    // function setFreelancer(address payable _freelancer) public{
    //     freelancer = _freelancer ;
    // }

    // function setDeadline (uint _deadline) public {
    //     deadline = _deadline;
    // }

    constructor(address payable _freelancer, uint _deadline)  payable {
        deadline = _deadline;
        freelancer = _freelancer;
        employer = msg.sender;
        price = msg.value;
    }

    receive() external payable{
        price += msg.value;
    }

    struct Request{
        string title;
        uint amount;
        bool locked;
        bool paid;
    }

    Request[] public requests;

    modifier onlyFreelancer{
        require(freelancer == msg.sender, "ONLY FREELANCER");
        _;
    }

    modifier onlyEmployer{
        require( msg.sender == employer, "Only Employer");
        _;
    }

    event RequestUnlocked(bool locked);
    event RequestCreated(string title, uint256 amount, bool locked, bool paid);
    event RequestPaid(address receiver, uint256 amount);

    function createRequest(string memory _title, uint _amount) public onlyFreelancer{
        Request memory newRequest = Request({
            title : _title,
        amount: _amount,
        locked: true,
        paid: false
        });

        requests.push(newRequest);

        emit RequestCreated(_title, _amount, newRequest.locked, newRequest.paid);
    }

    function getAllRequests() public onlyEmployer view returns(Request[] memory){
        return requests;
    } 

    function unlockRequest(uint256 _index) public onlyEmployer{
        Request storage _request = requests[_index];
        require(_request.locked  , "Already unlocked");
        _request.locked = false;

        emit RequestUnlocked(_request.locked);
    }

    function payRequest(uint256 _index) public onlyFreelancer{
        require(!locked, 'Reentrant detected');

        Request storage request = requests[_index];
        require(!request.locked, "Request is locked");
        require(!request.paid, "Already paid");

        locked = true;
        // bool sent = freelancer.call{value: request.amount}('');
         bool sent = freelancer.send(request.amount);

        require(sent, "Transfer failed");

        // locked = false;
        emit RequestPaid(msg.sender, request.amount);
    }

      // Add a fallback function to receive Ether
    // receive() external payable {}

    // Add a function to withdraw excess funds
    // function withdraw() public onlyFreelancer {
    //     payable(owner()).transfer(address(this).balance);
    // }
    
}