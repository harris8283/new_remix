pragma solidity 0.4.24;

contract ERC20token{
    string public constant name = "Rick Roll Token";        //回傳token的名稱為Rick Roll Token
    string public constant symbol = "RRT";      //回傳token的簡稱RRT
    uint8 public constant decimals = 0;         //回傳小數點位數為0
    uint public totalSupply = 10000000;         //發行一千萬個token
    address public owner;           //合約建構者
    mapping (address => uint) balances;         //帳戶持有的token數量
    mapping (address => mapping(address => uint)) allowed;      //授權的地址和金額
    mapping (address => uint) complete;     //紀錄已完成ICO的帳戶

    event Transfer (address indexed _from, address indexed _to, uint256 _value);        //Transfor事件負責實際轉移token
    event Approval (address indexed _owner, address indexed _spender, uint256 _value);      //Approval事件負責授權token

    modifier onlyOwner(){           //function modifier函數修飾子
        if(msg.sender != owner){    //僅限合約建構者使用
            revert();               //放棄執行，還原狀態
        }
        _;      //繼續執行後面的程式
    }

    constructor() public{
        owner=msg.sender;       //設定合約建構者
    }

    function () public payable {
        if(totalSupply > 0 && balances[msg.sender] ==0 && msg.value == 1 finney && complete[msg.sender] < 1000){
            totalSupply -= 1000;                //將尚可發行額減本次發行數量
            balances[msg.sender] = 1000;        //紀錄帳號內已經有1000個token
            complete[msg.sender] = 1000;        //紀錄帳號已經完成ico過了
        }else {
            revert();       ////放棄執行，還原狀態
        }
    }

    function balanceOf(address _owner) public view returns (uint256){
        return balances[_owner];        //回傳輸入位址的token數量
    }

    function transfer(address _to, uint _amount)public returns(bool){
        if(_amount > 0      //檢測發送數量>0
        && balances[msg.sender] >= _amount      //確定發送位址擁有之token數量大於等於要發行之數量 
        && balances[_to] + _amount > balances[_to]){        //確認是否有溢位錯誤
            balances[msg.sender] -= _amount;        //減少執行者_amount個token
            balances[_to] += _amount;               //增加_to位址_amount個token

            emit Transfer(msg.sender, _to, _amount);        //實際執行交易的事件
            return true;        //回傳程式執行成功但不代表交易成功
        }else{
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns(bool){
        if (_amount > 0         //檢測發送數量>0
        && balances[_from] >= _amount           //確定發送方的token數量足夠
        && allowed[_from][msg.sender] >= _amount        //確定發送方給予之token的允許操控數量不少於將要發送的數量
        && balances[_to] + _amount > balances[_to]){        //確認是否有溢位錯誤
            balances[_from] -= _amount;         //減少發送方的token
            allowed[_from][msg.sender] -= _amount;      //減少被授權的數量
            balances[_to] += _amount;           //增加接收方的token數量
            emit Transfer(_from, _to, _amount);     //實際將發送方的token轉給接收方
            return true;        //回傳程式執行成功但不代表交易成功
        }else{
            return false;
        }
    }

    function approve (address _spender, uint256 _amount) public returns(bool){
        allowed[msg.sender][_spender] = _amount;        //執行者授權_spender位址可以使用多少token
        emit Approval(msg.sender, _spender, _amount);   //執行Approval事件許可對方位址使用特定數量的token
        return true;
    }

    function allowance (address _owner, address _spender) public view returns(uint256){
        return allowed[_owner][_spender];       //回傳被授權使用多少token
    }

    function contractETH() public view returns (uint256){
        return address(this).balance;       //查詢合約中尚有多少token
    }

    function icoEnding() public onlyOwner{          //結束ico
        owner.transfer(address(this).balance);      //將合約的ETH轉至合約建構者帳戶
    }

    function burn(uint256 _amount) public onlyOwner returns(bool){
        if(_amount > 0     //確定銷毀數量>0
        && balances[msg.sender] >= _amount             //確定合約部屬者擁有足夠多的token
        && balances[msg.sender] - _amount < balances[msg.sender]){      //避免溢位
            balances[msg.sender] -= _amount;         //減少位址中要銷毀的token數量
            emit Transfer(msg.sender, address(0), _amount);     //將token送至位址為0(不存在)的地方銷毀
            return true;
        }else{
            return false;
        }
    }
}


