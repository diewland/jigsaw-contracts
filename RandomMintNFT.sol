// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721r} from "@middlemarch/erc721r/contracts/ERC721r.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomMintNFT is ERC721r, Ownable {

    // collection config
    constructor() ERC721r("My Fun NFT v4", "MYFUNV4", 100) {}
    uint256 public MAX_MINT_PER_WALLET = 10;
    
    // metadata
    string private baseURI;
    function setBaseURI(string calldata _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    function tokenURI(uint tokenId) public view override returns (string memory) {
        return string.concat(baseURI, Strings.toString(tokenId), ".json");
    }
    
    // mint
    function mint(uint quantity) external {
        // ERC721r exposes a public numberMinted(address) that you can optionally use
        // to, e.g., enforce limits instead of using a separate mapping(address => uint)
        // which is more expensive
        require(numberMinted(msg.sender) + quantity <= MAX_MINT_PER_WALLET,
            string.concat("Limit ", Strings.toString(MAX_MINT_PER_WALLET), " per address"));
        
        // You do *not* need to do this. ERC721r handles it.
        // require(totalSupply() + quantity <= maxSupply())
        
        _mintRandom(msg.sender, quantity);
    }
    function adminMint(uint quantity) external onlyOwner {
        _mintRandom(msg.sender, quantity);
    }
}
