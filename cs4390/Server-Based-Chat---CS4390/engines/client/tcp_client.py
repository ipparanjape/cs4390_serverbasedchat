import socket

from config import config


class TCPClient:
    def __init__(self):
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    def connect(self):
        self.client.bind((config.HOST, config.PORT))

    def send(self, message: str):
        self.client.send(message.encode())

    def receive_message(self):
        return self.client.recv(1024).decode()

    def close(self):
        self.client.close()


tcp_client = TCPClient()
