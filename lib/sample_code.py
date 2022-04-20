from typing import List
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
import traceback

app = FastAPI()
pings = {}

# Model having username and websocket
# may include more things in future
class ClientModel:
    def __init__(self, username: str, websocket: WebSocket):
        self.username: str = username
        self.websocket: WebSocket = websocket


class ConnectionManager:
    def __init__(self):
        self.active_connections: List[ClientModel] = []

    async def connect(self, username: str, websocket: WebSocket):
        await websocket.accept()
        client = ClientModel(username, websocket)
        self.active_connections.append(client)
        print(f"{username} added")

    async def disconnect_user(self, username: str):
        for client in self.active_connections:
            if client.username == username:
                await self.send_personal_message("disconnected", client.websocket)
                self.active_connections.remove(client)
                
        print(f"{username} disconnected")

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    # excluding sender (username) from the list and then sending the message
    async def broadcast(self, message: str, username: str):
        for client in self.active_connections:
            if client.username != username:
                await client.websocket.send_text(message)


manager = ConnectionManager()


@app.websocket("/ws/{username}")
async def websocket_endpoint(websocket: WebSocket, username: str):
    await manager.connect(username, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            print(data)
            # add a condition for pings
            # await manager.send_personal_message(f"{data}", websocket)
            # holds a dictionary

            # to differentiate broadcast and personal message
            obj = 0
            try:
                obj = eval(data)
                pings[username] = obj["ping"]
                obj["max_ping"] = max(pings.values());
                data = str(obj).replace("'", "\"")
                print("string after processing: " + data)
            except:
                print("exception in eval:\n")
                traceback.print_exc()

            if obj["func"] == "ping":
                await manager.send_personal_message(f"{data}", websocket)
            elif obj["func"] == "kick":
                user_to_kick = list(obj["arguments"])
                await manager.disconnect_user(user_to_kick[0])
                await manager.broadcast(f"Client #{user_to_kick} left the chat", username)
            else:
                await manager.broadcast(f"{data}", username)
    except WebSocketDisconnect:
        #manager.disconnect(websocket)
        await manager.disconnect_user(username)
        await manager.broadcast(f"Client #{username} left the chat", username)
        print(f"Client #{username} left the chat")




