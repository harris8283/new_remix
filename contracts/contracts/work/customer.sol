// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.22;

contract Owner{             
    address private owner;
    address [] private manager;                                     //新增一個array來記錄所有可以使用特定合約的address作為合約管理權限設置
    mapping (address => Manager) private manager_map;      //利用address指向管理者物件(address為key Manager物件為value)
    uint private id = 1;

    struct Manager{
        address manager_address;
        uint manager_id;
    }

    constructor(){              //合約部屬時會執行constructor的內容
        owner = msg.sender;     //設定合約擁有人 msg.sender為執行合約的人的位址
        manager_map[msg.sender] = Manager(msg.sender,0);
        manager.push(msg.sender);
    }

    modifier onlyOwner(){       //限制合約擁有人才能使用
        require(owner == msg.sender,"This address is not contract Owner");
        _;          //繼續執行程式
    }

    modifier onlyManager(){
        require(manager_map[msg.sender].manager_address != address(0),"This address has insufficient permissions");
        _;          //繼續執行程式
    }

    function change_owner(address _address) onlyOwner public{           //更改合約擁有人
        owner = _address;
    }

    function add_manager(address _address) onlyManager public{
        manager_map[_address] = Manager(_address,id);
        manager.push(_address);
        id += 1;
    }

    function delete_manager(address _address) onlyManager public{
        delete manager[manager_map[_address].manager_id];
        delete manager_map[_address];
    }

    function getOwner() view public returns(address){
        return owner;
    }
}

/*
藉由智能合約紀錄客戶資訊以及發放獎勵
優點：
1.方便(公司不用另外利用資料庫紀錄質押金額全由智能合約處理)
缺點：
1.智能合約無法計算小數透過智能合約計算獎勵可能出錯或遺留部分ETH於智能合約中
2.利用智能合約計算獎勵會增加消耗的gas fee
3.資料暴露在區塊鏈上不可放置機密資料(可透過Hash值替換掉部分內容，然而這樣就需要另外用資料庫紀錄)
*/
contract customer is Owner{
    uint amount = 0;        //客戶id(同時記錄位址在陣列中的位置)
    uint reward_time;            //部屬合約的時間
    address[] private account;      //儲存客戶位址
    mapping (address => Customer) private customer_map;      //利用address指向客戶資訊(address為key Customer物件為value)
    //uint[] aa = [1,2,3,4,5,6,7,8,9];            //測試用 沒意義

    event Give_Reward(address customer_address,uint reward_value,uint staking_value);       //紀錄有發放獎勵的每個客戶的位址、發放的獎勵、獎勵對應的質押的總金額

    constructor(){
        reward_time = block.timestamp;
    }

    struct Customer{        //客戶資訊的物件(建議可以使用Hash儲存)
        address customer_address;       //客戶位址
        uint value;         //客戶質押數量
        uint add_value;      //新增的質押數量
        uint time;          //客戶質押時間
        uint newtime;        //新增的質押時間
        uint id;             //客戶在陣列中的位置
    }

    function add_customer(address _customer_address , uint _value) onlyOwner public{       //新增客戶資訊 建議可用hash替換位址
        require(customer_map[_customer_address].customer_address == address(0),"This account is already exist");        //若是發現位址(address)為空位址address(0)=0x00 則放棄執行還原原本的狀態 並且提供錯誤訊息
        Customer memory new_customer = Customer({           //建立一個Customer物件命名為new_customer儲存客戶資訊
            customer_address : _customer_address,
            value : _value,
            add_value : 0,
            time : block.timestamp - 2592000,                         //block.timestamp是從UTC1970年1月1日0時0分0秒起至現在的總秒數
            newtime : block.timestamp,
            id : amount
        });
        customer_map[_customer_address] = new_customer;     //利用位址作為key 將剛剛新增的customer作為value儲存
        account.push(_customer_address);                    //將客戶的address放進array的最後面
        amount += 1;
    } 

    function change_customer_data(address _customer_address , uint _value, uint _add_value, uint _time, uint _newtime) onlyOwner public{       //更改客戶資訊 建議可用hash替換位址
        require(customer_map[_customer_address].customer_address != address(0),"This account isn't exist");
        Customer memory change_customer = Customer({
            customer_address : _customer_address,
            value : _value,
            add_value : _add_value,
            time : _time,
            newtime : _newtime,
            id : amount
        });
        customer_map[_customer_address] = change_customer;      //覆蓋掉之前的資訊
        account[customer_map[_customer_address].id] = _customer_address;        //覆蓋之前的位址
    } 

    function delete_customer(address _customer_address) onlyOwner public{       //刪除客戶資訊
        require(customer_map[_customer_address].customer_address != address(0),"This account isn't exist");
        delete account[customer_map[_customer_address].id];
        delete customer_map[_customer_address];
    }

    function change_staking_value(address _customer_address, uint _value) onlyOwner public{
        customer_map[_customer_address].value = _value;          //更改原本的質押金額
    }  

    function change_staking_add_value(address _customer_address, uint _value) onlyOwner public{
        customer_map[_customer_address].add_value = _value;          //更改新增的質押金額
    }  

    function increase_staking_value(address _customer_address, uint _value) onlyOwner public{           //增加質押金額
        customer_map[_customer_address].add_value += _value;                                         //置換為新的質押金額
        customer_map[_customer_address].newtime = block.timestamp;
    }

    function reduce_staking_value(address _customer_address, uint _value) onlyOwner public{         //減少質押金額
        require(_value <= customer_map[_customer_address].value + customer_map[_customer_address].add_value , "Staking value is not enough");       //確定是否位址已存在
        if (_value > customer_map[_customer_address].add_value){
            customer_map[_customer_address].add_value = 0;
            _value -= customer_map[_customer_address].add_value;
            customer_map[_customer_address].value -= _value;
        }else{
            customer_map[_customer_address].add_value -= _value;
        }
    }

    function increase_staking_time(address _customer_address, uint _time) onlyOwner public {     //將未入帳質押日期延後(以天為單位)
        require(customer_map[_customer_address].customer_address != address(0),"This account isn't exist");
        customer_map[_customer_address].time += _time * 86400;
    }

    function reduce_staking_time(address _customer_address, uint _time) onlyOwner public {     //將未入帳質押日期提前(以天為單位)
        require(customer_map[_customer_address].customer_address != address(0),"This account isn't exist");
        customer_map[_customer_address].time -= _time * 86400;
    }

    function get_customer_data(address _address) view public returns(Customer memory){
        require(customer_map[_address].customer_address != address(0),"This account isn't exist");
        return customer_map[_address];
    }

    function get_customer_address(address _address) view public returns(address){
        require(customer_map[_address].customer_address != address(0),"This account isn't exist");
        return customer_map[_address].customer_address;
    }

    function get_staking_value(address _address) view public returns(uint){
        require(customer_map[_address].customer_address != address(0),"This account isn't exist");
        return (customer_map[_address].value + customer_map[_address].add_value);
    }

    function get_customer_id(address _address) view public returns(uint){
        require(customer_map[_address].customer_address != address(0),"This account isn't exist");
        return customer_map[_address].id;
    }

    function get_allcustomer_reward() view onlyOwner public returns(uint){          //取得目前可分配獎勵之總質押金額
        uint all_staking=0;
        for (uint i = 0 ; i < amount ; i++){
            if(customer_map[account[i]].value != 0 && reward_time >= customer_map[account[i]].time){      //條件要滿足有質押金額且質押超過一個月(2592000秒)
                all_staking += customer_map[account[i]].value;
            }
        }
        return all_staking;
    }

/*
無法運算小數需修改
假設最低投資1NTD，總投資金額為一億USD
設1USD=30NTD
投資比例為1:1.5e10
1ETH=1e18wei
只要發放金額不低於1.5e-8ETH基本上不會出錯
*/

//每次發放獎勵會將add_value中新增的質押金額轉入可發放獎勵的value中
    function give_all_reward() onlyOwner payable public{            //按照比例分配獎勵給全部客戶
        require(msg.value > 0,"You don't give ETH");
        uint all_stakling_value = get_allcustomer_reward();
        for (uint i = 0 ; i < amount ; i++){
            uint reward = 0;
            if(customer_map[account[i]].value != 0 && reward_time >= customer_map[account[i]].time){      //條件要滿足有質押金額且質押時間為上次發放獎勵前
                reward = customer_map[account[i]].value;
            }
            if(customer_map[account[i]].add_value != 0){      //要有新增的質押金額才執行
                customer_map[account[i]].value += customer_map[account[i]].add_value;       //將上次發放獎勵到這次發放獎勵之間所新增的質押加入可收領獎勵之質押中
                customer_map[account[i]].add_value = 0;         //清空新增的質押
            }
            if(reward == 0){
                continue ;
            }
            uint give_reward = reward * msg.value / all_stakling_value;
            address payable _address = payable(customer_map[account[i]].customer_address);          //要支付ETH的位址必須設置為payable
            _address.transfer(give_reward);
            emit Give_Reward(_address, give_reward, reward);            //紀錄發放獎勵的內容
        }
        reward_time = block.timestamp;              //將發放獎勵時間改為現在
    } 
    

    function take_out_ETH(address payable _address) onlyOwner public {
        _address.transfer(address(this).balance);
    }

    /*
    測試用的程式碼 不用理
    function test() view public returns(uint){
        uint tt = 0;
        for (uint i=0; i < aa.length; i++){
            if(i==3){
                continue ;
            }
            tt += aa[i];
        }
        return tt;
    }
    */
}