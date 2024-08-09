extends Area2D

var sender
var direction

func _ready():
	await get_tree().create_timer(0.3).timeout
	transform.x.x = direction
	queue_free()
	
func _physics_process(delta):
	position += Vector2(10*direction,-3)

func _on_body_entered(body):
	if body.has_method("take_damage") and body != sender:
		body.take_damage(15)
		
	if not body == self and body.frame != 4:
		var flingDirection = body.position.direction_to(position) * -10
		flingDirection.x *= 250
		#flingDirection.y *= 500 #/throwFactor
		flingDirection.y -= 100
		body.velocity = flingDirection
