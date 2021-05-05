import socket

from config import config


class UDPClient:
    def __init__(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def send(self, message: str):
        self.client.sendto(message.encode(), (config.HOST, config.PORT))

    def receive_message(self):
        message, address = self.client.recvfrom(1024)

        return message.decode('utf-8')

    def close(self):
        self.client.close()


udp_client = UDPClient()
