// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./ERC165.sol";
import "./IERC721.sol";
import "./ContractOwner.sol";

contract ERC721token is ContractOwner, ERC165, IERC721, IERC721Enumerable, IERC721Metadata{

    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
    bytes4 private constant INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant INTERFACE_ID_ERC721_RECEIVED = 0x150b7a02;

    string private tokenName;
    string private tokenSymbol;

    uint256[] tokens;
    uint256 maxTokenID;
    mapping (uint256 => address) private tokenOwner;
    mapping (address => uint256[]) private ownerTokens;
    mapping (uint256 => address) private tokenURIs;
    mapping (address => mapping(address => bool)) private ownerOperatorApproval;

    constructor (string memory _name, string memory _symbol){
        tokenName = _name;
        tokenSymbol = _symbol;

        registerInterface(INTERFACE_ID_ERC721);
        registerInterface(INTERFACE_ID_ERC721_ENUMERABLE);
        registerInterface(INTERFACE_ID_ERC721_METADATA);
    }

    function name () external view returns(string memory){
        return tokenName;
    }

    function symbol () external view returns(string){
        return tokenSymbol;
    }

    function tokenURI (uint256 _tokenID) external view returns(string){
        return tokenURIs[_tokenID];
    }

    function totalSupply() external view returns(uint256){
        return tokens.length;
    }

    function tokenOfOwnerByIndex (address _owner, uint256 _index) external view returns(uint256){
        return ownerTokens[_owner][_index];
    }

    function tokenByIndex(uint256 _index) external view returns(uint256){
        return tokens[_index];
    }

    function balanceOf(address _owner) external view returns(uint256){
        return ownerTokens[_owner].length;
    }

    function ownerOf(uint256 _tokenID) external view returns(address){
        return tokenOwner[_tokenID];
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenID, bytes memory _data) external payable{       //從_from位址轉移NFT(_tokenID)到_to位址去，_data為附加的參數
        transfer(_from, _to, _tokenID, _data);
    }
    function safeTransferFrom(address _from, address _to, uint256 _tokenID) external payable{                   //與前一個一樣，不過若沒有輸入_data則使用本函數
        transfer(_from, _to, _tokenID, "");
    }

    function transfer(address _from, address _to, uint256 _tokenID, bytes memory _data) internal{
        address owner = tokenOwner[_tokenID];

        require( _to != address(0), "Transfer to the zero address");
        require( owner == from, "Token does not belong to the account");
        require( isOwnerOrOperator(msg.sender, _tokenID) == true, "Transfer caller is not owner nor approved");         //需理解

    }
    function transferFrom(address _from, address _to, uint256 _tokenID) external payable;                       //一樣是從_from位址轉移NFT(_tokenID)到_to位址，不過可能沒有安全機制需要傳輸者自行確定位址之有效性
    function approve(address _approved, uint256 _tokenID) external payable;                         //更改或確認NFT的授權位址，_approved 為0表示沒有授權的位址
    function setApprovalForAll(address _operator, bool _approved) external;                         //允許或關閉_operator位址的操控權限
    function getApproved(uint256 _tokenID) external view returns(address);                          //查詢NFT操作者的位址
    function isApprovedForAll(address _owner, address _operator) external view returns(bool);       //確認_owner的NFT操作者是否為_operator

}