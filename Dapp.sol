//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dapp {
    
	// Network: Rinkeby
	// https://docs.chain.link/docs/link-token-contracts/
	address constant LINK_ADDRESS = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    address constant USDT_ADDRESS = 0x3B00Ef435fA4FcFF5C209a37d1f3dcff37c705aD;


	AggregatorV3Interface internal ethPriceFeed;
	AggregatorV3Interface internal linkPriceFeed;
  AggregatorV3Interface internal usdtPriceFeed;

    struct Balance {
        uint256 ethbal;
        uint256 lnkbal;
        
    }

    mapping(address => Balance) public users;


	/**
     * Network: Rinkeby
	 * https://docs.chain.link/docs/ethereum-addresses/
     */
    constructor() {
        ethPriceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
		linkPriceFeed = AggregatorV3Interface(0xd8bD0a1cB028a31AA859A21A3758685a95dE4623);
    
    }


   

	function getlatestEthPrice() public view returns (int)
	{
		(
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = ethPriceFeed.latestRoundData();
       
        return price;
	}

	function getlatestLinkPrice() public view returns (int)
	{
		(
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = linkPriceFeed.latestRoundData();
        
        return price;
	}
    
    
 

    //Deposit function


	function depositLink(uint256 amount) public{
		IERC20 lnk = IERC20(LINK_ADDRESS);

		require(lnk.balanceOf(msg.sender) >= amount, "Insufficient LINK balance");

		lnk.transferFrom(msg.sender, address(this), amount);
	

		Balance storage user = users[msg.sender];
        user.lnkbal += amount;


	}

	function depositETH() public payable{
		

        Balance storage user = users[msg.sender];
         user.ethbal += msg.value;
	}



    //Withdrawal function

	function withdrawETH(uint256 amount) public {
       
	   Balance storage user = users[msg.sender];
	   require(user.ethbal >= amount, "Insufficient ETH");
	   user.ethbal -= amount;

       //require(EthBalance[msg.sender] >= amount, "Not enough ETH balance");
		// EthBalance[msg.sender] -= amount;

		payable(msg.sender).transfer(amount);
	}


	function withdrawLink(uint256 amount) public {

		IERC20 lnk = IERC20(LINK_ADDRESS);

		Balance storage user = users[msg.sender];
		require(user.lnkbal >= amount, "Insufficient LINK");
		user.lnkbal -= amount;
		//require(LinkBalance[msg.sender] >= amount, "Not enough LINK balance");
		//LinkBalance[msg.sender] -= amount;
		lnk.transfer(msg.sender, amount);
	}
	


}
