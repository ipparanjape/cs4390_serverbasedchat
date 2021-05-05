import socket

from config import config


class UDPServer:
    def __init__(self):
        self.server = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.server.bind((config.HOST, config.PORT))

    def send(self, message: str, client_address):
        self.server.sendto(message.encode(), client_address)

    def receive_message(self):
        message, client_address = self.server.recvfrom(1024)

        return message.decode('utf-8'), client_address

    def close(self):
        self.server.close()
	
udp_server = UDPServer()
