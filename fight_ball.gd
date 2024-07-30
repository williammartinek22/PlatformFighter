extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")/2

var sender

var bounce_strength = 0.98

func _physics_process(delta):
	velocity.x = minf(velocity.x, 100.0)
	velocity.y = minf(velocity.y, 100.0)
	velocity.x = maxf(velocity.x, -100.0)
	velocity.y = maxf(velocity.y, -100.0)
	
	if velocity == Vector2.ZERO:
		sender = null
	
	rotation += velocity.x
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var collision_info = move_and_collide(velocity)
	if collision_info:
		velocity = (velocity.bounce(collision_info.get_normal()) * bounce_strength)/2
		var collider = collision_info.get_collider()
		if sender == collider:
			print("AJA")
		if collider is CharacterBody2D and collider != sender and sender != null:
			collider.velocity = (velocity - collider.velocity) * -5
			collider.take_damage(10)

