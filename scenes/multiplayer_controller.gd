extends Control

@export var address = "127.0.0.1"
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func peer_connected(id):
	print("Player connected " + str(id))

func peer_disconnected(id):
	print("Player disconnected " + str(id))

func connected_to_server():
	print("Player connected to server")

func connection_failed():
	print("Failed to connect")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_button_button_down():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 6)
	if error != OK:
		print("cannot host: " + error)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("waiting for players")

func _on_join_button_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	


func _on_start_button_button_down():
	pass # Replace with function body.
