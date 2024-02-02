// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ContractOwner{
    address private contractOwner;      //合約管理者帳戶

    modifier onlyContractOwner(){       //function modifier函數修飾子僅限管理者使用
        if(msg.sender != contractOwner){        //判斷位址是否為合約管理者之位址
            revert();       //放棄執行，還原狀態
        }
        _;
    }

    constructor(){              //建構式於部屬時執行
        contractOwner = msg.sender;         //設定合約管理者為合約建構者
    }

    function getContractOwner() public view returns(address){
        return contractOwner;           //取得合約管理者位址
    }

    function setContractOwner(address _owner) public onlyContractOwner{         //僅有合約管理者可更改合約管理者位址
        contractOwner = _owner;         //修改合約管理者位址為輸入之位址
    }
}