// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

//ERC165標準：建立一個標準方法以發布和檢測智能合約實現了哪些介面Interface
interface IERC165{
    //此函式使用少於30,000gas
    //[input]interfaceID介面識別碼
    //[return]若智能合約實現了interfaceID且不為0xffffffff則回傳true，否則回傳false
    function supportsInterface(bytes4 interfaceID) external view returns(bool);
}