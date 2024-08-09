extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = 1
var angle = 0
var mousePos
var bounce = false

var sender
var explosion = load("res://explosion.tscn")

func _ready():
	mousePos = position + Vector2(100,100)
	mousePos.x *= dir
	velocity = Vector2(500,-500)
	await get_tree().create_timer(1.5).timeout
	explode()

func _process(delta):
	velocity.y += gravity * delta * 2
	#velocity.x = 500 * dir
	rotation += 5 * delta
	if position != mousePos and !bounce:
		position = position.move_toward(mousePos, delta * 1000)
	#It moves kinda weird whenever it hits something
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.get_collider() is MultiplayerController and collision_info.get_collider() != sender:
			explode()
		bounce = true
		velocity = velocity.bounce(collision_info.get_normal())
		dir = collision_info.get_normal().x/abs(collision_info.get_normal().x + 0.0001)
		
func bust():
	pass#explode()	
	
func explode():
	var explInst = explosion.instantiate()
	explInst.global_position = global_position
	get_tree().root.call_deferred("add_child", explInst, true)
	queue_free()
