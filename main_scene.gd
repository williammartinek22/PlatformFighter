extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%AudioStreamPlayer.play()
	_add_players()
	
func _add_players():
	MultiplayerManager._add_player_to_game(1)
	MultiplayerManager._add_player_to_game(multiplayer.peer_connected.get_object_id())
	
func _process(_delta):
	if Input.is_action_just_released("R"):
		get_tree().reload_current_scene()

func _on_ball_walls_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(100)
