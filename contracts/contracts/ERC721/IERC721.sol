// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC721{      //先撰寫ERC721之標準
    
    event Transfer (address indexed _from, address indexed _to, uint256 indexed _tokenID);        //Transfor事件負責實際轉移NFT(從_from轉_tokenID到_to)
    event Approval (address indexed _owner, address indexed _approved, uint256 indexed _tokenID);      //Approval事件負責授權NFT(允許_approved有權限使用_owner的_tokenID)
    event ApprovalForAll (address indexed _owner, address indexed _operator, bool _approved);           //Approval事件授權NFT若為_approved為true則可以啟用、false則無權限

    function balanceOf(address _owner) external view returns(uint256);          //查詢使用者的token(NFT)的數量
    function ownerOf(uint256 _tokenID) external view returns(address);          //根據tokenID回傳擁有者位址
    function safeTransferFrom(address _from, address _to, uint256 _tokenID, bytes memory _data) external payable;       //從_from位址轉移NFT(_tokenID)到_to位址去，_data為附加的參數
    function safeTransferFrom(address _from, address _to, uint256 _tokenID) external payable;                   //與前一個一樣，不過若沒有輸入_data則使用本函數
    function transferFrom(address _from, address _to, uint256 _tokenID) external payable;                       //一樣是從_from位址轉移NFT(_tokenID)到_to位址，不過可能沒有安全機制需要傳輸者自行確定位址之有效性
    function approve(address _approved, uint256 _tokenID) external payable;                         //更改或確認NFT的授權位址，_approved 為0表示沒有授權的位址
    function setApprovalForAll(address _operator, bool _approved) external;                         //允許或關閉_operator位址的操控權限
    function getApproved(uint256 _tokenID) external view returns(address);                          //查詢NFT操作者的位址
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);       //確認_owner的NFT操作者是否為_operator

}

interface IERC721Metadata{

    function name () external view returns(string);           //回傳NFT名稱
    function symbol () external view returns(string);           //回傳NFT代稱
    function tokenURI (uint256 _tokenID) external view returns(string);         //回傳NFT(_tokenID)對應的URI

}

interface IERC721Enumerable{          //撰寫IERC721Enumerable的介面
    
    function totalSupply () external view returns(uint256);      //查詢代幣總發行量
    function tokenOfOwnerByIndex (address _owner, uint256 _index) external view returns(uint256);       //根據帳戶位址及索引值查詢TokenID
    function tokenByIndex(uint256 _index) external view returns(uint256);           //根據索引值查詢tokenID

}

interface IERC721TokenReceiver{         //撰寫IERC721TokenReceiver的介面

    function onERC721Received (address _operator, address _from, uint256 _tokenID, bytes memory _data) external returns(bytes4);            //收到NFT時的處理函式

}