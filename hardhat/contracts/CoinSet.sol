// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CoinDex is ERC20 {

    address owner;
    uint _totalCoinSets;

    struct CoinSet{
        string name;
        address[] coins;
    }

    struct CSet{
        uint index;
        address[] tokens;
        uint[] value;
    }

    mapping(uint=>CoinSet) public coinSets;

    mapping(address=>uint) public reedemed;

    mapping(address => mapping(uint => mapping(address => uint))) holders;

    mapping(address => uint[]) holdings;
 
    modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }

    constructor() ERC20("CoinDex LP Token", "CDLP") {
        owner=msg.sender;
        _totalCoinSets=0;
    }

    function getTokenNameAndSymbol(address _tokenAddress) public view returns (string memory,string memory){
        return (ERC20(_tokenAddress).name(),ERC20(_tokenAddress).symbol());
    }

    function getAllCoinSets() public view returns(CoinSet[] memory){

        CoinSet[] memory allCoinSets = new CoinSet[](_totalCoinSets);
        for(uint i=0;i<_totalCoinSets;i++){
            allCoinSets[i] = CoinSet(coinSets[i].name,coinSets[i].coins);
        }
        return allCoinSets;
    }

    function getPortfolioValue() public view returns(CSet[] memory){
        CSet[] memory cs = new CSet[](holdings[msg.sender].length);
        //uint amount = 0;
        for(uint i=0;i<holdings[msg.sender].length;i++){
            uint csIndex = holdings[msg.sender][i];
            uint[] memory tokens = new uint[](coinSets[csIndex].coins.length);
            address[] memory add = coinSets[csIndex].coins;
            for(uint j=0;j<coinSets[csIndex].coins.length;j++){
                tokens[j] = holders[msg.sender][csIndex][coinSets[csIndex].coins[j]];
            }   
            cs[i] = CSet(csIndex, add, tokens);
        }
        return cs;
    }

    function getInvestedCoin() public view returns(uint[] memory){
        return holdings[msg.sender];
    }
    
    function getReserve(address _tokenAddress) public view returns (uint) {
        return (ERC20(_tokenAddress).balanceOf(address(this))-reedemed[_tokenAddress]);
    }

    function addCoinSet(string memory _name, address[] memory _coins) public onlyOwner{
        coinSets[_totalCoinSets] = CoinSet(_name,_coins);
        _totalCoinSets++;
    }

    function addLiquidity(uint _amount, address _tokenAddress) public payable returns (uint) {
        uint liquidity;
        uint ethBalance = address(this).balance;
        uint tokenReserve = getReserve(_tokenAddress);
        ERC20 token = ERC20(_tokenAddress);
     
        if(tokenReserve == 0) {
            //token.approve(address(this), _amount);
            token.transferFrom(msg.sender, address(this), _amount);
            
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else {
            uint ethReserve =  ethBalance - msg.value;
            uint tokenAmount = (msg.value * tokenReserve)/(ethReserve);
            require(_amount >= tokenAmount, "Amount of tokens sent is less than the minimum tokens required");
            //token.approve(address(this), tokenAmount);
            token.transferFrom(msg.sender, address(this), tokenAmount);
            liquidity = (totalSupply() * msg.value)/ ethReserve;
            _mint(msg.sender, liquidity);
        }
         return liquidity;
    }

    function approveLiquidity(uint _amount, address _tokenAddress) public payable{
        ERC20 token = ERC20(_tokenAddress);
        token.approve(address(this), _amount);
    }

    function removeLiquidity(uint _amount, address _tokenAddress) public returns (uint , uint) {
        require(_amount > 0, "_amount should be greater than zero");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply();
        uint ethAmount = (ethReserve * _amount)/ _totalSupply;
        uint cryptoDevTokenAmount = (getReserve(_tokenAddress) * _amount)/ _totalSupply;
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        ERC20(_tokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
        return (ethAmount, cryptoDevTokenAmount);
    }
    
    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
        uint256 inputAmountWithFee = inputAmount * 97;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
        return numerator / denominator;
    }

    function search(uint index)internal view returns(uint){
        uint[] memory cs = holdings[msg.sender];
        for(uint i=0;i<cs.length;i++){
            if(cs[i]==index) return i;
        }
        return cs.length;
    }

    function deleteFromArray(uint ele) public returns(uint[] memory) {

        uint index=0;

        for(uint i=0;i<holdings[msg.sender].length;i++){
            if(holdings[msg.sender][i]==ele)
                index=i;
        }

        for (uint i = index; i<holdings[msg.sender].length-1; i++){
            holdings[msg.sender][i] = holdings[msg.sender][i+1];
        }
        holdings[msg.sender].pop();

        return holdings[msg.sender];
    }

    function investInCoinSet(uint index) public payable{
        CoinSet memory coinSet = coinSets[index];
        uint length = coinSet.coins.length;
        uint searchIndex = search(index);
        for(uint i=0;i<length;i++){
            uint256 tokenReserve = getReserve(coinSet.coins[i]);
            uint256 tokensBought = getAmountOfTokens(
                msg.value/length,
                address(this).balance - msg.value,
                tokenReserve
            );
            holders[msg.sender][index][coinSet.coins[i]]+=tokensBought;
            reedemed[coinSet.coins[i]]+=tokensBought;
        }
        if(searchIndex==holdings[msg.sender].length)
            holdings[msg.sender].push(index);
    }

    function sellCoinSet(uint index) public {
        CoinSet memory coinSet = coinSets[index];
        uint length = coinSet.coins.length;
        uint amount =0;
        for(uint i=0;i<length;i++){
            uint256 tokenReserve = getReserve(coinSet.coins[i]);
            uint256 tokensBought = getAmountOfTokens(
                holders[msg.sender][index][coinSet.coins[i]],
                address(this).balance,
                tokenReserve
            );
            reedemed[coinSet.coins[i]]-=holders[msg.sender][index][coinSet.coins[i]];
            amount+=tokensBought;
        }
        payable(msg.sender).transfer(amount);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}