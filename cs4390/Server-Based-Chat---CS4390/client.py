from config import config
from engines.client.tcp_client import tcp_client
from engines.client.udp_client import udp_client
from helper import hash_rand, hash2_rand

import socket
import time
import threading
import hashlib
import os

while True:
    cmd = input("Command: ")

    while (cmd != 'Log On'):
       cmd = input("Command: ")
    
    uname = input("Username: ") # HELLO (Client-ID-A)
    udp_client.send(uname)

    rand = udp_client.receive_message()

    if rand == 'Invalid Username':
        udp_client.close()
        print(rand)
        quit()

    client_secret = input("Enter Secret Key: ")
    RES = hash_rand(client_secret, rand)
    udp_client.send(RES) # RESPONSE (client-id, Res) - missing client ID

    reply2 = udp_client.receive_message()
    
    if (reply2 == 'Begin encryption'):
       udp_client.send('Send rand')
       reply3 = udp_client.receive_message()
       CK_AC = hash2_rand(client_secret, reply3)
       udp_client.send(str(CK_AC))

     
    reply4 = udp_client.receive_message()

    if reply4 == config.AUTH_SUCCESS:
        # udp_client.close()
        print(reply4)

    if reply4 == config.AUTH_FAILURE:
        udp_client.close()
        print(reply4)
        print('Client: Closing due to authentication failure')
        quit()

    reply5 = udp_client.receive_message()

    if reply5 == config.AUTH_FINISH:
       # udp_client.close()
       print(config.CONNECTED)
       break

# with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as udp_client:
udp_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   
udp_client.connect((config.HOST, config.PORT))

'''
tcp_client.send('CONNECT')
connected_message = tcp_client.receive_message()

if connected_message:
    print(connected_message)
    # tcp_client.close()
'''

def recvFromServer():
   while True:
      try:
         msg = udp_client.recv(1024).decode('ascii')
         
         if (msg == "Log Off"):
            reply_end1 = udp_client.recv(1024).decode('ascii')
            if (reply_end1 == 'Log Off'):
               udp_client.send(uname.encode('ascii'))

         if (msg == 'You have been connected to the server!'):
            udp_client.send(uname.encode('ascii')) 
        
	 
         if ('[' in msg and (uname + ":") in msg):
            hist = eval(msg)
            for m in hist:
               print(m)

         else:
            print(msg)
      
      except:
         print("A connection error occured!")
         udp_client.close()
         break

def sendToServer():
   while True:
      start_time = time.time()
      type_m = input('')
      msg = '{}: {}'.format(uname, type_m)
      end_time = time.time()
	    
      if (end_time - start_time > 80):
         msg_timeout = 'Timeout! TCP connection closing.'
         udp_client.send(msg_timeout.encode('ascii'))
         udp_client.close()
         break

      if ('Log Off' in msg):
         udp_client.send('{} logging off'.format(uname).encode('ascii'))
         udp_client.close()
         break

      if ('Chat ' in msg and uname in type_m):
            print('Cannot chat with self')
            continue

      else:
         udp_client.send(msg.encode('ascii'))

# Threads for receiving and sending messages
recv_th = threading.Thread(target=recvFromServer)
recv_th.start()

send_th = threading.Thread(target=sendToServer)
send_th.start()
