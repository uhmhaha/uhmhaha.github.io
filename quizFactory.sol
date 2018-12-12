pragma solidity 0.4.24;

contract QuizFactory {
    
    address[] public quizfactory;
    uint creationTime = now;
    bytes32 playerCommit;
    uint playerReveal;

    function createQuiz( string _question, bytes32 _answer) public returns(address) {
        Quiz newQuiz = new Quiz(_question, _answer, msg.sender);
        quizfactory.push(newQuiz);
        return newQuiz;
    }
    
    modifier onlyOwner(){
        
        require(owner == msg.sender);
        _;
        
    }
    
    modifier onlyPeriod(uint fromDays, uint toDays){
        require( fromDays <= creationTime && toDays >= creationTime);
        _;
    }
    
    function compareStrings(string _a, string _b) internal returns(bool){
       
        if(bytes(_a).length != bytes(_b).length) {
            return false;
        }else {
            return keccak256(_a) == keccak256(_b);
        }
        
    }
    
    function CommitGuess(bytes32 _hash) internal {
        require(now  <= creationTime + 6 * 1 days);//From the contract creation time tothe 6th day,users should be able to ubmit their guesses
        require(factory[msg.sender] != 0x0);//Maximum 1 guess per user and we need to keep track of the number of guesses.
        
        //Any extra values should be returned to the sender address.
        if(msg.value > 1 ether){
            address(msg.sender).transfer(msg.value - 1 ether);
        }
        // The guesses must not be visible in the blockchain.
        if( msg.sender == owner && playerCommit == 0x0 ){
            playerCommit = _hash;
        }else{
            revert();
        }
    }
    
    function reveal(string _val) public {
        require(now  > creationTime + 6 * 1 days); //From 7th day to the 13th day, the owner of the contract should reveal the answer previously stored when the Quiz contract was created.
        
        if(msg.sender == owner && keccak256(_val) == playerCommit){
            playerReveal = uint(bytes(_val)[0]) - 48;   
        }else{
            revert();
        }
    }
    
}


contract Quiz {

    string question;
    bytes32 answer;
    address owner;

    constructor (string _question, bytes32 _answer, address _owner) public {
        
        question = _question;
        answer = _answer;
        owner = _owner;
    }
}
