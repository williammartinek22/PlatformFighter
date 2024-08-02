extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	velocity.y += gravity * delta
