pragma solidity ^0.5.11;
contract A {
	uint myState; 
	function set(uint val) public {
		myState = val;
	}
	function get() public view returns (uint v) {
		return myState;    
	}
}
contract B{    }
contract C is A, B{    }
