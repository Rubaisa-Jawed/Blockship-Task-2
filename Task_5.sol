// SPDX-License-Identifier: MIT
pragma solidity =0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract task4 is ERC721{
    
    struct TokenSeller {
        address tokenOwner;
        uint256 tokenId;
        uint256 tokenSalePrice;
    }
    
    mapping(address => TokenSeller) OrderBook;
    
    function sellToken(uint _tokenId, uint _tokenprice) public {
        require(_tokenprice == TokenSeller.tokenSalePrice);
        _transfer(msg.sender, address(this), _tokenId);
        OrderBook[_tokenId] = TokenSeller(msg.sender, _tokenId, _tokenprice);
    }
    
    function buyToken(uint _tokenId) external payable {
        TokenSeller memory dataToken = TokenSeller[_tokenId];
        address newOwner = dataToken.newOwner;
        require(msg.sender != newOwner);
        uint tokenSalePrice = dataToken.tokenSalePrice;
        require(msg.value == tokenSalePrice);
        sendEther(newOwner, tokenSalePrice);
        transferFrom(address(this), msg.sender, _tokenId);
        delete TokenSeller[_tokenId];
    }
    
    function sendEther(address _NewOwner, uint _sendAmount) private {
        uint payableAmount = _sendAmount - TokenSeller.tokenSalePrice;
        (bool success, ) = _NewOwner.call{value: payableAmount}("");
        require(success, "Transaction failed");
    }
}