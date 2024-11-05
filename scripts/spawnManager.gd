extends Node2D

var playerRed_scene: PackedScene = preload("res://scenes/playerRed.tscn")
var playerGreen_scene: PackedScene = preload("res://scenes/playerGreen.tscn")
const SERVER_PORT: int = 8080
const SERVER_IP: String = "127.0.0.1"

var player_index: int = 0

func _ready():
	if not multiplayer.is_server():
		return

func _on_host_pressed():
	$Menu.visible = false
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
		
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	add_player()

func _on_join_pressed():
	$Menu.visible = false
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
		
	multiplayer.multiplayer_peer = peer

func add_player(id: int = 1):
	var player: Node2D
	if (id == 1):
		player = playerRed_scene.instantiate()
		player.position.x = $"0".global_position.x
		player.position.y = $"0".global_position.y
	else:
		player = playerGreen_scene.instantiate()
		player.position.x = $"1".global_position.x
		player.position.y = $"1".global_position.y
	
	player.player_id = id
	player.name = str(id)

	$Network.add_child(player, true)
	

func del_player(id: int):
	rpc("_del_player", id)

@rpc("any_peer", "call_local") func _del_player(id):
	$Network.get_node(str(id)).queue_free()

func _on_area_2d_body_entered(body: Node2D):
	if body.has_meta("tag") && body.get_meta("tag") == "player":
		var randIdx = randi_range(0, 1)
		body.position.x = get_node(str(randIdx)).position.x
		body.position.y = get_node(str(randIdx)).position.y
