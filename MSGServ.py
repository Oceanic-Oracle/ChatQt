import json
import socket
import threading
import select

HOST = '127.0.0.1'  
PORT = 1234         

clients = []

def broadcast_message(message, source_socket=None):

    for client in clients:
        if client != source_socket:
            try:
                client.send(message)
            except Exception as e:
                print(f"Error sending message to client: {e}")
                client.close()
                clients.remove(client)

def handle_client(client_socket):
    while True:
        try:
            data = client_socket.recv(1024)
            if not data:
                break

            print(f"Broadcasting message from client: {data.decode()}")
            broadcast_message(data, client_socket)
        except socket.error as e:
            print(f"Client connection error: {e}")
            break

    client_socket.close()
    clients.remove(client_socket)
    print("Client disconnected")

def server_listen():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind((HOST, PORT))
    server_socket.listen()

    print(f"Server is listening on {HOST}:{PORT}")

    while True:
        client_socket, client_address = server_socket.accept()
        
        print(f"Accepted new connection from {client_address}")
        clients.append(client_socket)

        client_thread = threading.Thread(target=handle_client, args=(client_socket,))
        client_thread.start()
        
    server_socket.close()

if __name__ == '__main__':
    try:
        server_listen()
    except KeyboardInterrupt:
        print("Server shutdown requested. Exiting...")
