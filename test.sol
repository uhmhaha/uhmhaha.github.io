pragma solidity 0.4.24;

contract EventTickets {

    uint public thisIsBalance = 0;
    bool public releaseEther = false;
    event CanPurchase(bool canPurchase);
    address public venueOwner;

    mapping(address => uint) shares;
    
    struct Buyer {
        string buyerName;
        uint buyingQauntity;
    }
    
    struct Ticket {
        uint costPerTicket;
        string description;
        string webSite;
        uint ticketQuantity;
        mapping(string => Buyer) buyers;
        string[] buyersAccts;
        //Buyer[] buyers;

    }
    
    mapping(address => Ticket) tickets;
    address[] public eventAccts;

    function createEvent( uint cost, string des, string web, uint qua) public payable{
        
        var ticket = tickets[msg.sender];
        //var buyer = ticket.buyers[nam];
        
        ticket.costPerTicket = cost;
        ticket.description = des;
        ticket.webSite = web;
        ticket.ticketQuantity = qua;
        // ticket.buyers.push(Buyer ({
        //     buyerName = nam,
        //     ticketQuantity = qua
        // }));
       // buyer.buyerName = nam;
        //buyer.ticketQuantity = qua;
        
        //ticket.buyersAccts.push(nam) -1;
        //ticket.buyers[nam].buyerName = nam;
        //ticket.buyers[nam].ticketQuantity = qua;
        eventAccts.push(msg.sender) -1;
    }
    
    function getTickets() view public returns(address[]){
         return eventAccts;
    }
    
    function getEvents() view public returns(uint, string, string, uint){
      return (tickets[msg.sender].costPerTicket, tickets[msg.sender].description, tickets[msg.sender].webSite, tickets[msg.sender].ticketQuantity);
    }
    
    function buyTicket( string name, uint q) public payable {
        require(tickets[msg.sender].ticketQuantity > q);
        thisIsBalance += tickets[msg.sender].ticketQuantity * q;
        tickets[msg.sender].ticketQuantity -= q;
        var buyer = tickets[msg.sender].buyers[name];
        buyer.buyingQauntity = q;
        buyer.buyerName = name;
    }

    function refund(string name,uint q) public payable {
        require(thisIsBalance >= tickets[msg.sender].buyers[name].buyingQauntity * q);
        thisIsBalance += tickets[msg.sender].buyers[name].buyingQauntity * q;
        tickets[msg.sender].ticketQuantity += q;
        
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
