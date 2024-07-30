extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("R"):
		get_tree().reload_current_scene()


func _on_ball_walls_body_entered(body):
	body.take_damage(100)
