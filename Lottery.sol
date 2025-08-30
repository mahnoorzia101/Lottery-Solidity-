// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
contract Lottery{
    //entities - manager, players, and winner
    address public manager;
    address payable[] public players;
    /* Since we will have more than one player so we will dynamic array, and that dynamic need to be payble in nature, becuse when ever an address need to send or recieve ether than that address need to be paybe in nature*/
    address payable public winner;
    //constructor
    constructor(){
        manager = msg.sender; //Who ever will run this contract, that person's address will store as manger's address
    }

    function participate() public payable{
        require(msg.value==1 ether, "Please pay 1 ether");
        players.push(payable (msg.sender));
    }

    //Manaer want to check wether how much ether does contract have till now
    function getBalance() public view returns (uint){
        require(manager==msg.sender, "You are not the Manger");
        return address(this).balance;
    }

    function random() internal  view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length))); // Genrate a random number
    }
    
    function pickWinner() public{
        require(manager==msg.sender, "You are not the manager");
        require(players.length>=3, "Minimum 3 players are required");

        uint r=random();
        uint index = r%players.length;
        winner=players[index]; // winner address
        winner.transfer(getBalance());
        players=new address payable[](0); //reset the array
    }
}