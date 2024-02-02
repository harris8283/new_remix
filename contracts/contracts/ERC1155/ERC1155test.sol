// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";


contract Marvel1155 is ERC1155PresetMinterPauser {
    
    uint256 public constant CAPTAIN_AMERICA = 0;
    uint256 public constant THOR = 1;
    uint256 public constant IRON_MAN = 2;
    uint256 public constant SPIDER_MAN = 3;
    
    constructor() ERC1155PresetMinterPauser( "https://api.frank.hk/api/nft/demo/1155/marvel/{id}.json") {
        _mint(msg.sender, CAPTAIN_AMERICA, 10**18, "");
        _mint(msg.sender, THOR, 1, "");
        _mint(msg.sender, IRON_MAN, 5, "");
        _mint(msg.sender, SPIDER_MAN, 10, "");
    }
    
}
