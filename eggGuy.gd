extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var totalHealth = health
@export var healthBar: TextureProgressBar
@export var main = true
var throwFactor = 0.95

@export var egg = preload("res://egg_projectile.tscn")

func _init():
	set_deferred("$EggGuySpriteSheet.frame", 4)

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		#$EggGuySpriteSheet.frame = 2
		velocity.y += gravity * delta
	elif $EggGuySpriteSheet.frame == 2:
		$EggGuySpriteSheet.frame = 0
	elif velocity.x != 0:
		velocity = velocity.lerp(Vector2.ZERO,throwFactor/10)
		
	if main:
	# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			$EggGuySpriteSheet.frame = 2
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			if $EggGuySpriteSheet.frame != 1:
				velocity.x = direction * SPEED
				transform.x.x = direction
			elif $EggGuySpriteSheet.frame == 1:
				velocity.x = direction * SPEED/3
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if Input.is_action_pressed("ui_down") and is_on_floor():#$EggGuySpriteSheet.frame == 0:
			$EggGuySpriteSheet.frame = 1
		if Input.is_action_just_released("ui_down"):
			$EggGuySpriteSheet.frame = 0

		if Input.is_action_just_pressed("Z") and $Attack/AttackCollision.disabled == true:
			attack()
		if Input.is_action_just_pressed("X"):
			$EggGuySpriteSheet.frame = 4
			await get_tree().create_timer(0.5).timeout 
			$EggGuySpriteSheet.frame = 0
		if Input.is_action_just_pressed("C"):
			var eggInst = egg.instantiate()
			get_tree().root.add_child(eggInst)
			eggInst.direction = transform.x.x
			eggInst.position = Vector2(position.x + (20 * eggInst.direction), position.y)

	move_and_slide()

func attack():
	if Input.is_action_pressed("ui_down") and not is_on_floor():
		$EggGuySpriteSheet.frame = 5
		$DownAttack/AttackCollision.disabled = false
	elif Input.is_action_pressed("ui_up"):
		$EggGuySpriteSheet.frame = 6
		$UpAttack/AttackCollision.disabled = false
	else:
		$EggGuySpriteSheet.frame = 3
		$Attack/AttackCollision.disabled = false
	await get_tree().create_timer(0.5).timeout 
	$EggGuySpriteSheet.frame = 0
	$Attack/AttackCollision.disabled = true
	$DownAttack/AttackCollision.disabled = true
	$UpAttack/AttackCollision.disabled = true


func _on_attack_body_entered(body):
	set_deferred('$Attack/AttackCollision.disabled', true)
	if not body == self and body.name == "FightBall" and main:
		if body.velocity.y < 1.0:
			body.velocity.y -= 50.0
		var direction = body.position.direction_to(self.position)
		body.velocity += (direction * -100.0)
		body.sender = self
	elif not body == self and main and $EggGuySpriteSheet.frame != 4:
		body.take_damage(10)
		var flingDirection = body.position.direction_to(position) * -10
		flingDirection.x *= 10
		flingDirection.y -= 500 #/throwFactor
		body.velocity = flingDirection

func take_damage(amount):
	if true:#main:
		health = max(0,health-amount)
		healthBar.value = health
		throwFactor = health/totalHealth
		
	if health == 0:
		queue_free()
