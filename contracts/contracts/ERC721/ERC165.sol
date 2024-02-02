// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./IERC165.sol";

contract ERC165 is IERC165{         //ERC165合約繼承IERC165介面
    bytes4 private constant INTERFACE_ID_ERC165 = 0x01ffc9a7;        //byte4(keccak256('supportsInterface(bytes4)'))
    mapping(bytes4 => bool) private supportsInterfaces;         //紀錄有支援的interfaceID，interfaceID => true支援，false不支援

    constructor(){          //建構式於部屬時執行
        registerInterface(INTERFACE_ID_ERC165);     //註冊對ERC165界面支援的interfaceID
    }
    
    //[input]interfaceID介面識別碼
    //[return]若智能合約實現了interfaceID且不為0xffffffff則回傳true，否則回傳false
    function supportsInterface(bytes4 interfaceID) public view virtual override returns(bool){      //實作IERC165中的supportsInterface，可用來查詢智能合約是否有實作指定之函數
        return supportsInterfaces[interfaceID];
    }

    function registerInterface(bytes4 interfaceID) internal virtual{
        require(interfaceID != 0xffffffff, "Invaild interface id");          //確定介面識別碼不是無效的(0xffffffff)
        supportsInterfaces[interfaceID] = true;                             //將合約以interfaceID註冊為介面的實作者
    }
}