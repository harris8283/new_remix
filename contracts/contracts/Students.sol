//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

contract StudentInfo {
    // 定義學生資料結構
    struct Student {
        uint id;
        address account;
        string phone;
        string email;
    }

    // 以 ETH 帳號為鍵，存儲對應的學生索引
    mapping (address => uint) private accountToIndex;
    // 以學生索引為鍵，存儲對應的學生資料
    mapping (uint => Student) private students;
    uint private numStudents; // 紀錄學生數量

    address private owner; // 合約擁有者

    constructor() {
        owner = msg.sender; // 設置合約擁有者為合約創建者
        numStudents = 0; // 初始學生數量為 0
    }

    // 限定只有合約擁有者才能呼叫的函數修飾器
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    // 新增一筆學生資料(onlyOwner)
    function addStudent(uint _id, address _account, string memory _phone, string memory _email) public onlyOwner {
        require(accountToIndex[_account] == 0, "Account already exists."); // 確保 ETH 帳號不存在
        numStudents++; // 增加學生數量
        students[numStudents] = Student(_id, _account, _phone, _email); // 存儲學生資料
        accountToIndex[_account] = numStudents; // 存儲 ETH 帳號對應的學生索引
    }

    // 根據 ETH 帳號查詢學生資料索引
    function getStudentIndexByAccount(address _account) public view returns (uint) {
        require(accountToIndex[_account] != 0, "Account does not exist."); // 確保 ETH 帳號存在
        return accountToIndex[_account]; // 返回 ETH 帳號對應的學生索引
    }

    // 根據學號查詢學生資料索引
    function getStudentIndexById(uint _id) public view returns (uint) {
        for (uint i = 1; i <= numStudents; i++) {
            if (students[i].id == _id) {
                return i; // 返回學號對應的學生索引
            }
        }
        revert("Student not found."); // 學生不存在，拋出異常
    }

    // 根據索引查詢學生資料
    function getStudent(uint _index) public view returns (uint, address, string memory, string memory) {
        require(_index > 0 && _index <= numStudents, "Invalid index.");
        return (students[_index].id, students[_index].account, students[_index].phone, students[_index].email);
    }

    // 根據學號查詢學生資料
    function getStudentById(uint _id) public view returns (uint, address, string memory, string memory) {
        uint index = getStudentIndexById(_id); // 獲取學號對應的學生索引
        return getStudent(index); // 返回學生資料
    }

    // 根據學號修改帳號、電話、Email(onlyOwner)
    function updateStudent(uint _id, address _account, string memory _phone, string memory _email) public onlyOwner {
        uint index = getStudentIndexById(_id); // 獲取學號對應的學生索引
        students[index].account = _account; // 更新 ETH 帳號
        students[index].phone = _phone; // 更新電話
        students[index].email = _email; // 更新 Email
    }

    // 根據學號刪除學生資料(onlyOwner)
    function deleteStudent(uint _id) public onlyOwner {
        uint index = getStudentIndexById(_id); // 獲取學號對應的學生索引
        for (uint i = index ; i<numStudents ; i++){
            accountToIndex[students[i+1].account] = i;
            students[i].id = students[i+1].id;
            students[i].account = students[i+1].account;
            students[i].phone = students[i+1].phone;
            students[i].email = students[i+1].email;
        }
        delete accountToIndex[students[numStudents].account]; // 刪除最後一個 ETH 帳號的學生索引
        delete students[numStudents]; // 刪除最後一筆學生資料
        numStudents--; // 減少學生數量
    }
}
