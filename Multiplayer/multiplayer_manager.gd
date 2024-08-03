extends Node

const SERVER_PORT = 8081
const SERVER_IP = "192.168.1.176"

var multiplayer_scene = preload("res://gauzy_character.tscn")

var characterOne
var characterTwo
var selectorOne
var selectorTwo

var _players_spawn_node
var _multiplayer_synchronizer

func become_host():
	print("Becoming host")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Selectors")
	#_multiplayer_synchronizer = get_tree().get_current_scene().get_node("MultiplayerSynchronizer")
	
	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = server_peer #establish as server
	
	multiplayer.peer_connected.connect(_control_selector)
	#multiplayer.peer_connected.connect(_add_player_to_game)
	#multiplayer.peer_disconnected.connect(_del_player)

	#_remove_single_player()
	
	if not OS.has_feature("dedicated_server"):
		_control_selector(1)
		#_add_player_to_game(1)
	
func join_as_player_2():
	print("Joining as player 2")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer
	
	_remove_single_player()

func _control_selector(id: int):
	print("Added selector %s to the game" % id)
	if id == 1:
		selectorOne.player_id = id
	else:
		selectorTwo.player_id = id

func _add_player_to_game(id: int):
	print("Added player %s to the game" % id)
	
	var player_to_add
	if characterOne and id == 1:
		player_to_add = characterOne.instantiate()
	elif characterTwo and id != 1:
		player_to_add = characterTwo.instantiate()
	else:
		player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	
	_players_spawn_node.add_child(player_to_add, true)
	
	if player_to_add.player_id == 1:
		player_to_add.healthBar = _multiplayer_synchronizer.get_child(0).get_child(0)
		player_to_add.superBar = _multiplayer_synchronizer.get_child(2).get_child(0)
		player_to_add.position = _multiplayer_synchronizer.get_child(4).get_child(0).position
	else:
		player_to_add.healthBar = _multiplayer_synchronizer.get_child(1).get_child(0)
		player_to_add.superBar = _multiplayer_synchronizer.get_child(3).get_child(0)
		player_to_add.position = _multiplayer_synchronizer.get_child(4).get_child(1).position
		player_to_add.transform.x.x = -1
	
func _del_player(id: int):
	print("Player %s left the game" % id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()

func _remove_single_player():
	return
	print("Remove single player")
	var player_to_remove = get_tree().get_current_scene().get_node("EggGuy")
	player_to_remove.queue_free()
