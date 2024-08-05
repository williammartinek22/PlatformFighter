extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%AudioStreamPlayer.play()
	MultiplayerManager._add_player_to_game(1)
	MultiplayerManager._add_player_to_game(multiplayer.peer_connected.get_object_id())
	
func _process(_delta):
	if Input.is_action_just_released("R"):
		get_tree().reload_current_scene()

func _on_ball_walls_body_entered(body):
	body.take_damage(100)
