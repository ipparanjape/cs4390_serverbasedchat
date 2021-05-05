# Server-Based-Chat---CS4390

A simple chat program that can host a set number of clients (1-10), where clients can then
request to chat with specific clients. A 1 on 1 chat can then be started between two clients.
Clients can use commands to interact with the clients and server. Once connected with a client chat 
is private between the two clients connected.

##Prerequesite

This program requires the following:
`python3.7` or newer 
Terminal (Command Terminal to run)

### Installation/Run

This program was tested on windows command terminal and on apple (terminal app)
You will need python3 to run this program. (coded mostly on 3.9)
Open file location of program on terminal. 
To then run the program using terminal 
Server should be openend first with number of clients in chat
    python3 server.py # (1-10 users allowed)
Clients can now begin login (need amount entered in the first step.)
    python3 client.py (all clients must login for server to open)
    (i.e if 'python3 server.py 2' entered before both clients must login to run server)

#### Usage
* In order to begin client log in
    - enter command 'Log On'
    - enter the user name i.e 'Khiem'
        - currently only 10 clients authorized
        - Ivan, Chinh, Dang, Ishan, Khiem, Dhruv, Richard, DT, Stephanie, Inga)
    - enter secret id (for ease of use the secret keys are Last Name of client)
       - All secret keys are in data.py 
       - Client is notified if authorized or if the authorization was failed
      
* Usable Commands

    - Logging Off (used to log off client)
    
    - chat 'client' (specific client you wish to speak with i.e. Chat Khiem)
        - Client will be notified if desired client is busy or unavailable otherwise.
        - Accept 'Client' (i.e Accept Dhruv)
        - Reject 'Client' (i.e Reject Dhruv)
       
    - History 'client' (used to get the chat history of the session)
        -i.e Ivan chatting with Ishan (History Ishan)
    
    - End Chat (used to end client-to-client chat) 
        - client can then chat with other client if desired. 
        
#### Python virtualenvironment
`virtualenv venv -p python3.7`
`source venv/bin/activate`

#### Lib dependencies
`pip install -r requirements.txt`

This read me file explains how to compile and run the Server Based Chat
