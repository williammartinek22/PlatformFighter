extends Node

const SERVER_PORT = 8080
const SERVER_IP = "192.168.1.220"

var multiplayer_scene = preload("res://Multiplayer/multiplayer_player.tscn")

var _players_spawn_node


func become_host():
	print("Becoming host")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer #establish as server
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)

	_remove_single_player()
	
	if not OS.has_feature("dedicated_server"):
		_add_player_to_game(1)
	
func join_as_player_2():
	print("Joining as player 2")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer
	
	_remove_single_player()

func _add_player_to_game(id: int):
	print("Added player %s to the game" % id)
	
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)
	
	
func _del_player(id: int):
	print("Player %s left the game" % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()

func _remove_single_player():
	print("Remove single player")
	var player_to_remove = get_tree().get_current_scene().get_node("EggGuy")
	player_to_remove.queue_free()
