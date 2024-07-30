extends Node

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		MultiplayerManager.become_host()

func become_host():
	print("Becoming hsot")
	MultiplayerManager.become_host()
	queue_free()
	
func join_as_player_2():
	print("Joined as player 2")
	MultiplayerManager.join_as_player_2()
	queue_free()
