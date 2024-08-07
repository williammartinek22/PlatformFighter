extends Area2D

func _ready():
	$AudioStreamPlayer.play(0)
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.3).timeout
	queue_free()
