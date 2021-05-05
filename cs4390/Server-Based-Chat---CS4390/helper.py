import hashlib
from random import randint
from config import config
from data import data, sessions
import json

def setBusy(uname):
    sz = 0
    for c in data['clients']:
        sz = sz + 1
    for i in range(sz):
        if data['clients'][i]['name'] == uname:
            data['clients'][i]['busy'] = True

def setConn(uname, cname):
    sz = 0
    for c in data['clients']:
       sz = sz + 1
    for i in range(sz):
       if data['clients'][i]['name'] == cname:
          data['clients'][i]['conn'] = uname
       if data['clients'][i]['name'] == uname:
          data['clients'][i]['conn'] = cname

def setSessionID(uname, cname, iD):
    sz = 0
    for c in data['clients']:
       sz = sz + 1
    for i in range(sz):
       if data['clients'][i]['name'] == cname:
          data['clients'][i]['session-id'] = iD
       if data['clients'][i]['name'] == uname:
          data['clients'][i]['session-id'] = iD

def rmvConnection(uname, cname):
    sz = 0
    for c in data['clients']:
        sz = sz + 1
    for i in range(sz):
        if data['clients'][i]['name'] == cname:
            data['clients'][i]['conn'] = '0'
            data['clients'][i]['session-id'] = 0
            data['clients'][i]['busy'] = False
        if data['clients'][i]['name'] == uname:
            data['clients'][i]['conn'] = '0'
            data['clients'][i]['session-id'] = 0
            data['clients'][i]['busy'] = False

def getConnection(client):
    sz = 0
    for c in data['clients']:
        sz = sz + 1	
    for i in range(sz):
        if data['clients'][i]['name'] == client:
            return data['clients'][i]['conn']

def get_busy_status(client): 
    sz = 0
    for c in data['clients']:
        sz = sz + 1	
    for i in range(sz):
        if data['clients'][i]['name'] == client:
            return data['clients'][i]['busy']

def get_session_ID(client):
    sz = 0
    for c in data['clients']:
        sz = sz + 1
    for i in range(sz):
        if data['clients'][i]['name'] == client:
            return data['clients'][i]['session-id']

def create_new_session_hist(uname, cname, iD):
    sessions['sessions'].append({
    'Client A': uname,
    'Client B': cname,
    'Session ID' : iD,
    'Messages' : []})

def add_msg_to_history(iD, msg): # msg must be decoded
    for s in sessions['sessions']:
        if s['Session ID'] == iD:
            s['Messages'].append(msg)

def get_history(iD):
    for s in sessions['sessions']:
        if s['Session ID'] == iD:
            return s['Messages']

def get_sessions_size():
    return len(sessions['sessions'])

def get_client_secret(client):
    for c in data['clients']:
        if c['name'] == client:
            return c['secret']

    return None

def is_accepted_client(client):
    for c in data['clients']:
        if c['name'] == client:
            return True

    return False

def get_cname(msg):
    for c in data['clients']:
        if c['name'] in msg:
            return c['name']

def check_uname_existence(msg):
    for c in data['clients']:
        if c['name'] in msg:
            return True
    return False	    

def send_rand(udp_server, client, client_addr):
    rand = str(randint(0, 51))
    client_secret = get_client_secret(client)
    XRES = hash_rand(client_secret, rand)
   # CK_A = hash2_rand(client_secret,rand)
    udp_server.send(rand, client_addr)
    return XRES


def hash_rand(client_secret, rand):
    return hashlib.sha256((client_secret + rand).encode()).hexdigest()


def hash2_rand(client_secret, rand):
    return hashlib.sha512((client_secret + rand).encode()).hexdigest()

def authenticate_once(udp_server, clients):  
    client, client_addr = udp_server.receive_message()
    print("Client's Username: " + client)

    if is_accepted_client(client) is False:
       udp_server.send('Invalid Username', client_addr)
       udp_server.close()
       print("Server: Closed due to invalid username")
       quit()

    #   udp_server.send('Begin encryption', client_addr)

    # CHALLENGE(rand) - sent if client has valid username
    XRES = send_rand(udp_server, client, client_addr)
    RES, client_addr = udp_server.receive_message()


    if XRES == RES:
        rand_encr = randint(0, 51)
        udp_server.send('Begin encryption', client_addr)
        CK_A = hash2_rand(get_client_secret(client),str(rand_encr))
        randMsg, client_addr = udp_server.receive_message()

        if (randMsg == 'Send rand'):
           udp_server.send(str(rand_encr), client_addr)
           CK_AC, client_addr = udp_server.receive_message()
        else:
           CK_AC = '0'
        
        if CK_A == CK_AC:
           udp_server.send(config.AUTH_SUCCESS, client_addr)
           clients.append(client)
           return client_addr
        else:
           udp_server.send('Encryption failure', client_addr)

    else:
        udp_server.send(config.AUTH_FAILURE, client_addr)
        print("Server: Closing due to wrong secret key")
        udp_server.close()
        quit()

