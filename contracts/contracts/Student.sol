pragma solidity 0.4.22;

contract Student {
    address private owner;      //合約擁有者
    uint usercode=0;        //計算學生數量同時作為資料索引
    
    constructor() public {      //建構式(只有合約部屬時會執行)
        owner = msg.sender;     //將合約擁有者設定為合約創建者，也可以自行設定只要改為其他可自行輸入之地址不過在本部分因函數修飾子onlyOwner所以設定為創建者
    }

    struct students{   //設定學生之資料結構
        string ID;
        address addresscode;
        string phone;
        string email;
    }

    modifier onlyOwner(){           //function modifier函數修飾子
        require(msg.sender == owner, "not owner");      //需要msg.sender(執行交易的帳戶) == owner否則回傳"not owner"
        _;
    }

    mapping (address => uint) private addresstocode;        //以地址為key記錄資料索引
    mapping (string => uint) private IDtocode;              //以帳號為key記錄資料索引
    mapping (uint => students) private member;              //以資料索引為key紀錄students資料結構之學生資料

    function createmember(string _ID , address _addresscode , string _phone , string _email) public onlyOwner{        //新增學生
        require(addresstocode[_addresscode] == 0 && IDtocode[_ID] == 0,"this member already exist");        //確定地址與帳號都未重複才可執行，否則出現錯誤
        usercode++;         //每新增一個學生就+1作為學生之資料索引同時記錄人數
        addresstocode[_addresscode] = usercode;     //紀錄地址對應之資料索引
        IDtocode[_ID] = usercode;       //紀錄學號對應之資料索引

        member[usercode] = students({ID:_ID , addresscode:_addresscode , phone:_phone , email:_email});     //建立新的資料索引對應之學生資料
    }

    function IDfindcode (string _ID) public view returns(uint _usercode){       //ID查詢索引
        require(IDtocode[_ID] <= usercode && IDtocode[_ID] != 0,"Can't find your ID");      //確定ID存在
        return IDtocode[_ID];       //回傳ID對應之資料索引
    }

    function addressfindcode (address _addresscode) public view returns(uint _usercode){        //帳號查詢索引
        require(addresstocode[_addresscode] <= usercode && addresstocode[_addresscode] !=0,"Can't find your address");      //確認地址存在
        return addresstocode[_addresscode];     //會傳地址對應之資料索引

    }

    function codefindmember(uint _usercode) public view returns(string ID , address addresscode , string phone , string email){       //索引查詢資料
        require(_usercode <= usercode && _usercode != 0,"Can't find your usercode");        //確定資料索引存在
        return (member[_usercode].ID, member[_usercode].addresscode, member[_usercode].phone, member[_usercode].email);     //回傳資料索引所對應之學生資料
    }

    function IDfindmember(string _ID) public view returns(string ID , address addresscode , string phone , string email){     //ID查詢資料
        require(IDtocode[_ID] <= usercode && IDtocode[_ID] != 0,"Can't find your ID");      //確定帳號存在
        uint a=IDfindcode(_ID);
        return (_ID, member[a].addresscode, member[a].phone, member[a].email);     //回傳帳號對應之學生資料
    }

    function IDmodifymember(string _ID , address _addresscode , string _phone , string _email) public onlyOwner{      //利用帳號修改學生資料
        require(IDfindcode(_ID) != 0 ,"Can't find your ID");        //確定帳號存在
        uint a=IDfindcode(_ID);
        /*依照帳號修改帳號對應之學生新資料*/
        member[a].addresscode = _addresscode;
        member[a].phone = _phone;
        member[a].email = _email;
    }

    function deletemember(string _ID) public onlyOwner{         //根據帳號刪除對應學生資料
        require(IDfindcode(_ID) != 0 ,"Can't find your ID");    //確認帳號存在
        for (uint i=IDfindcode(_ID) ; i<usercode ; i++){        //利用迴圈從刪除的學生資料開始每一位學生往前移一位
            IDtocode[member[i+1].ID]=i;                         //修改帳號對應之資料索引
            addresstocode[member[i+1].addresscode]=i;           //修改地址對應之資料索引
            member[i].ID = member[i+1].ID;
            member[i].addresscode = member[i+1].addresscode;
            member[i].phone = member[i+1].phone;
            member[i].email = member[i+1].email;
        }
        delete IDtocode[member[usercode].ID];                   //刪除最後一筆帳號對應之資料索引
        delete addresstocode[member[usercode].addresscode];     //刪除最後一筆地址對應之資料索引
        delete member[usercode];                                //刪除最後一筆資料索引對應之學生資料
        usercode--;                                             //學生數量-1
    }
/*
address的比對require(_account == address(_account),"Invalid address")
solidity建議使用keccak256前要先使用abi.encodePacked
*/
    
}