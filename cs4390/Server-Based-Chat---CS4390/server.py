import socket
import sys

from config import config

from engines.server.udp_server import udp_server
from helper import *

import threading
from collections import OrderedDict

auth_clients = [] # List of authenticated clients
auth_addr = [] # List of authenticated client addresses
acc_clients = [] # List of clients accepted for TCP connections

n_args = len(sys.argv)
if n_args != 2:
   print("You need only one argument - the number of clients the server\
   can support!\n")
   quit()

n_clients = int(sys.argv[1])
if (n_clients < 1 or n_clients > 10):
   print ("Only 1-10 clients can be supported.")
   quit()

for i in range(n_clients):
   client_addr = authenticate_once(udp_server, auth_clients)
   auth_addr.append(client_addr)

# client_directory1 = OrderedDict()
client_directory = OrderedDict()


if (len(auth_clients) == n_clients and len(auth_addr) == n_clients):
   for address in auth_addr:
      udp_server.send(config.AUTH_FINISH, address)

'''
for key, value in client_directory.items():
   print(key, value)
# udp_server.close()
'''

udp_server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
      if (rem_clients == 0):
         udp_server.close()
         break
udp_server.bind((config.HOST, config.PORT))
udp_server.listen()

def closeAll():
    for c in auth_clients:
       client_directory[c].close()

def sendTwo(clientA, clientB, msg): # msg is encoded with 'ascii'
    userA = client_directory[clientA]
    userB = client_directory[clientB]
    userA.send(msg)
    userB.send(msg)

def sendAll(msg):
    for user in acc_clients:
       user.send(msg)


def manage(user):
   while True:
      # Receive message from user
      msg = user.recv(1024)
      msg_decode = msg.decode('ascii')
      
      # Username manipulation
      for key, value in client_directory.items():
         if (value == user):
            cname = key

      # Find the client 'user' is talking to
      recv_client = getConnection(cname)
      
      # List of all other clients connected to server than receiving end
      rem_clients = len(auth_clients)
      other_cnames = auth_clients.copy() 
      other_cnames.remove(cname)

      # Case of no clients remaining
      if (rem_clients == 0):
         udp_server.close()
         quit()

      # Case of timeout
      if ('TCP connection closing' in msg_decode):
         sendAll('{} has disconnected due to timeout.'.format(cname)\
         .encode('ascii'))
         user.close()
         break

      # Case where receiving client and user are connected
      if (recv_client in other_cnames and
         not ('get history' in msg_decode.lower())):
         sendTwo(cname, recv_client, msg)
         add_msg_to_history(get_session_ID(cname), msg_decode) 
      
      # Case where one user wishes to end the chat but not log off
      if ('End Chat' in msg_decode and recv_client in other_cnames):
         rmvConnection(cname, recv_client)
         sendTwo(uname, cname,('\n' + config.END_NOTIF).encode('ascii'))

      # Case where a user will be logging off (starts at client end
      if ('logging off' in msg_decode):
         for c in auth_clients:
            if (c in msg_decode and auth_clients[0] == c):
	       closeAll()
               break
            if (c in msg_decode and not (auth_clients[0] == c)):
               sendAll('{} has left the chat.'.format(c).encode('ascii'))
               auth_clients.remove(c)
               acc_clients.remove(client_directory[c])
               if c in other_cnames:
                  other_cnames.remove(c)

               rem_clients = rem_clients - 1
               user.close()	       
         break
      
      if('History' in msg_decode and getConnection(cname) in msg_decode):
         hist = get_history(get_session_ID(cname))
         hist = str(hist)
         user.send(hist.encode('ascii'))

      if ('Chat ' in msg_decode):
         num_auth = 0
         for uname in auth_clients:

            if (uname in msg_decode and\
            not(uname in [key for key, value in client_directory.items() \
            if value == user]) and not(get_busy_status(uname))):
               conn_party = client_directory[uname]
               conn_party.send('{} wants to chat with you.Type "ACCEPT {}" or "REJECT {}"'.format(cname, cname, cname).encode('ascii'))
            
            if (uname in msg_decode and\
            not(uname in [key for key, value in client_directory.items() \
            if value == user]) and get_busy_status(uname)):
               user.send('{} is in a chat session. Please try again later!'\
	       .format(uname).encode('ascii'))
	    
            num_auth = num_auth + 1
	 

      if ('REJECT' in msg_decode.upper()):
         for uname in other_cnames:
            if (uname.lower() in msg_decode.lower()): 	 
               conn_party = client_directory[uname]
               conn_party.send('Your chat request has been denied!'\
	       .encode('ascii'))

      if ('ACCEPT' in msg_decode.upper()):
         for uname in other_cnames:
            if (uname.lower() in msg_decode.lower()):
               idNum = get_sessions_size() + 1
               conn_party = client_directory[uname]
               conn_party.send('Your chat request has been accepted!\n'\
	       .encode('ascii'))
               
               setBusy(uname)
               setBusy(cname)
               setConn(uname, cname)
               setSessionID(uname, cname, idNum)
               create_new_session_hist(uname, cname, idNum)
               sendTwo(cname, uname, 'Welcome to the chatroom {} and {}!'\
               .format(cname, uname).encode('ascii'))

      

def setUp():
   while True:
      # Accept a connection if client is authenticated (client side)
      conn, ar = udp_server.accept()
      print("Server: Connected with client {}".format(str(ar)))

      # Add client to accepted clients array
      acc_clients.append(conn)

      # Notify joining chat server
      conn.send("You have been connected to the server!".encode('ascii'))
      uname = conn.recv(1024).decode('ascii')
      client_directory[uname] = conn

      sendAll("{} has joined the chat.".format(uname).encode('ascii'))

      # Make a thread for each client
      th = threading.Thread(target=manage, args=(conn,))
      # idNum = idNum + 1
      th.start()

setUp()

