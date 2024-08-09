extends Area2D

func _ready():
	$AudioStreamPlayer.play(0)
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(20)
