// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract reward{
    address payable private owner;
    event Received(address _sender, uint _value, string _message);

    modifier onlyOwner(){
        if(msg.sender != owner){
            revert();
        }
        _;
    }

    constructor(){
        owner=payable(msg.sender);
    }

    fallback() external payable{
        emit Received(msg.sender, msg.value, "fallback was called");
    }

    receive() external payable{
        emit Received(msg.sender, msg.value, "receive was called");
    }

    function change_owner(address payable _address) public onlyOwner returns(bool){
        owner = _address;
        return true;
    }

    function pay_reward(address payable[] memory _address, uint[] memory _value) payable public returns(bool){
        uint all_reward=0;
        for  (uint i=0 ; i < _value.length ; i++){
            all_reward += _value[i];
        }
        require(_address.length == _value.length,"Address and ETH are not match");
        require(all_reward <= msg.value,"ETH value was not enough");
        emit Received(msg.sender, msg.value, "reward are all received");
        for  (uint i=0 ; i < _address.length ; i++){
            _address[i].transfer(_value[i]);
        }
        return true;
    }

    function take_back_money() payable public onlyOwner returns(bool){
        owner.transfer(address(this).balance);
        return true;
    }

}