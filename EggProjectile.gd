extends Area2D

@export var direction = 1:
	set(dir):
		if dir != 0:
			direction = dir
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


#move right, delete upon reaching the edge of the screen
func _process(delta):
	scale.x = direction
	position.x += 200 * delta * direction
