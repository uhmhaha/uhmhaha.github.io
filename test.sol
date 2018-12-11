pragma solidity 0.4.24;

contract EventTickets {

    uint public thisIsBalance = 0;
    bool public releaseEther = false;
    event CanPurchase(bool canPurchase);
    address public venueOwner;

    mapping(address => uint) shares;
    
    struct Buyer {
        string buyerName;
        uint ticketQuantity;
    }
    
    struct Ticket {
        uint costPerTicket;
        string description;
        string webSite;
        mapping(string => Buyer) buyers;
        string[] buyersAccts;

    }
    
    mapping(address => Ticket) tickets;
    address[] public eventAccts;

    function createEvent( uint cost, string des, string web, string nam, uint qua) public payable{
        
        var ticket = tickets[msg.sender];
        var buyer = ticket.buyers[nam];
        
        ticket.costPerTicket = cost;
        ticket.description = des;
        ticket.webSite = web;
        
        buyer.buyerName = nam;
        buyer.ticketQuantity = qua;
        
        ticket.buyersAccts.push(nam) -1;
        eventAccts.push(msg.sender) -1;
    }
    
    function getTickets() view public returns(address[]){
         return eventAccts;
    }
    
    function getEvent(string name) view public returns(uint, string, string, string, uint){
      return (tickets[msg.sender].costPerTicket, tickets[msg.sender].description, tickets[msg.sender].webSite, tickets[msg.sender].buyers[name].buyerName, tickets[msg.sender].buyers[name].ticketQuantity);
    }
    
    function buyTicket( string name, uint q) public payable {
        require(tickets[msg.sender].buyers[name].ticketQuantity > q);
        thisIsBalance += tickets[msg.sender].buyers[name].ticketQuantity * q;
        tickets[msg.sender].buyers[name].ticketQuantity -= q;
    }

    function refund(string name,uint q) public payable {
        require(thisIsBalance >= tickets[msg.sender].buyers[name].ticketQuantity * q);
        thisIsBalance += tickets[msg.sender].buyers[name].ticketQuantity * q;
        tickets[msg.sender].buyers[name].ticketQuantity += q;
        
        if(msg.sender.call.value(shares[msg.sender])())
            shares[msg.sender] = 0;
        
    }
    
    //use onlyOwner and check event( idont know what it means )
    function allowPurchase() onlyOwner {
        releaseEther = true;
        CanPurchase(releaseEther);
    }
    
    //check is 0
    modifier onlyOwner(){
        require(tickets[msg.sender].costPerTicket == 0);
        _;
    }

}
