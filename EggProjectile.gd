extends Area2D

var shooter

@export var direction = 1:
	set(dir):
		if dir != 0:
			direction = dir
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()

#move right, delete upon reaching the edge of the screen
func _process(delta):
	scale.x = direction
	position.x += 200 * delta * direction
