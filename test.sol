pragma solidity 0.4.24;

contract EventTickets {
    
    struct Buyer {
        string buyerName;
        uint ticketQuantity;
    }
    
    struct Ticket {
        uint costPerTicket;
        string description;
        string webSite;
        mapping(address => Buyer) buyers;

    }
    
    uint public thisIsBalance = 0;
    mapping(address => Ticket) tickets;
    address[] public eventAccts;
    address[] public buyersAccts;

    function createEvent( uint cost, string des, string web, string nam, uint qua) public payable{
        
        var ticket = tickets[msg.sender];
        var buyer = Ticket.buyers[msg.sender];
        
        ticket.costPerTicket = cost;
        //ticket.buyers = msg.sender;
        ticket.description = des;
        ticket.webSite = web;
        
        buyer.buyerName = nam;
        buyer.ticketQuantity = qua;
        
        eventAccts.push(msg.sender) -1;
    }
    
    function getTickets() view public returns(address[]){
         return eventAccts;
    }
    
    function getEvent() view public returns(uint, string, string){
      return (tickets[msg.sender].costPerTicket, tickets[msg.sender].description, tickets[msg.sender].webSite, tickets[msg.sender].buyers[msg.sender].buyerName, tickets[msg.sender].buyers[msg.sender].ticketQuantity);
    }
    
    // function getEvent() view public returns(uint, string, string){
    //     return (myTicket.ticketQuantity, myTicket.description, myTicket.webSite);
    // }
    
    // function countTickets() view public returns(uint){
    //     return eventAccts.length;
    // }
    
    // function buyTicket(address _add, uint q) public payable {
    //     require(tickets[_add].ticketQuantity > q);
    //     thisIsBalance += tickets[_add].ticketQuantity * q;
    //     tickets[_add].ticketQuantity -= q;
    // }
    function buyTicket(uint q) public payable {
        require(myTicket.ticketQuantity > q);
        thisIsBalance += myTicket.ticketQuantity * q;
        myTicket.ticketQuantity -= q;
    }
    
    // function refund(address _add, uint q) public payable {
    //     require(thisIsBalance >= tickets[_add].ticketQuantity * q);
    //     thisIsBalance += tickets[_add].ticketQuantity * q;
    //     tickets[_add].ticketQuantity += q;
    // }
    function refund( uint q) public payable {
        require(thisIsBalance >= myTicket.ticketQuantity * q);
        thisIsBalance += myTicket.ticketQuantity * q;
        myTicket.ticketQuantity += q;
    }
}
