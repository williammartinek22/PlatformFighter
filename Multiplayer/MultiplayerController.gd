extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100.0
var totalHealth = health
@export var healthBar: TextureProgressBar
@export var superBar: TextureProgressBar
@export var main = true
var throwFactor = 0.95

@export var frame = 0
var do_attack = false
var do_jump = false
var do_guard = false
var do_crouch = false
var _is_on_floor = true

var egg = preload("res://egg_projectile.tscn")

@export var player_id = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func _ready():
	if multiplayer.get_unique_id() == player_id:
		#$Camera2D.make_current()
		#else:
		#$Camera2D.enabled = false
		pass
	pass#set_deferred("$EggGuySpriteSheet.frame", 4)

func _apply_movement_from_input(delta):
	if not is_on_floor():
		#$EggGuySpriteSheet.frame = 2
		velocity.y += gravity * delta
	elif $EggGuySpriteSheet.frame == 2:
		frame = 0
	elif velocity.x != 0:
		velocity = velocity.lerp(Vector2.ZERO,throwFactor/10)
		
	if do_jump:
		do_jump = false
		if is_on_floor():
			frame = 2
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	$EggGuySpriteSheet.frame = frame
	
	var direction = %InputSynchronizer.input_direction
	if direction:
		if $EggGuySpriteSheet.frame != 1:
			velocity.x = direction * SPEED
			transform.x.x = direction
		elif $EggGuySpriteSheet.frame == 1:
			velocity.x = direction * SPEED/3
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if do_crouch and is_on_floor():#$EggGuySpriteSheet.frame == 0:
		frame = 1
		do_crouch = false
	if Input.is_action_just_released("ui_down"):
		do_crouch  = false
		frame = 0

	if do_attack:
		attack(false,false,false)
		do_attack = false
		
	if do_guard:
		do_guard = false
		frame = 4
		await get_tree().create_timer(0.5).timeout 
		frame = 0

	move_and_slide()

	
func _physics_process(delta):
	if multiplayer.is_server():
		_apply_movement_from_input(delta)
	
	$EggGuySpriteSheet.frame = frame
	
	var direction = %InputSynchronizer.input_direction
	if direction:
		if $EggGuySpriteSheet.frame != 1:
			velocity.x = direction * SPEED
			transform.x.x = direction

	if not multiplayer.is_server():
		#_apply_animations(delta)
		pass

func attack(input_up,input_down,input_c):
	$AudioStreamPlayer.play(0.0)
	if input_up:
		if input_c:
			frame = 7
			$Attacks/UpPower.disabled = false
		else:
			frame = 6
			$Attacks/UpAttack.disabled = false
	elif input_down:
		if input_c:
			frame = 9
			$Attacks/DownPower.disabled = false
		elif not is_on_floor():
			frame = 5
			$Attacks/DownAttack.disabled = false
	else:
		print("ATTACKA")
		if input_c:
			print("SHOOT EGG")
			#var eggInst = egg.instantiate()
			#get_tree().root.add_child(eggInst)
			#eggInst.direction = transform.x.x
			#eggInst.position = Vector2(position.x + (20 * eggInst.direction), position.y)
		else:
			frame = 3
			$Attacks/Neutral.disabled = false
	
	await get_tree().create_timer(0.5).timeout 
	frame = 0
	#disable any hitboxes
	var attacks = $Attacks.get_children()
	for attack in attacks:
		if attack is CollisionShape2D:
			attack.disabled = true

func crouch():
	if is_on_floor():
		frame = 1
	await get_tree().create_timer(0.5).timeout 
	do_crouch  = false
	frame = 0 

func _super():
	if superBar.value >= 100:
		$SuperSheet.show()
		$SuperSheet.play("default")
		$EggGuySpriteSheet.hide()
		await $SuperSheet.animation_finished
		$SuperSheet.hide()
		$Chacken.show()
		$Attacks/ChackenCollisionPolygon2D.disabled = false
		$AudioStreamPlayer3.play()
		superBar.value = 0
		await get_tree().create_timer(8.0).timeout
		$Chacken.hide()
		$Attacks/ChackenCollisionPolygon2D.disabled = true
		$EggGuySpriteSheet.show() 
		$AudioStreamPlayer3.stop()

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
		flingDirection.x *= 250
		#flingDirection.y *= 500 #/throwFactor
		flingDirection.y -= 100
		body.velocity = flingDirection

func take_damage(amount):
	if healthBar:#main:
		health = max(0,health-amount)	
		healthBar.value = health
		throwFactor = health/totalHealth
		
	if superBar:
		var superMeter = min(100,superBar.value+(amount*2))
		superBar.value = superMeter
		
	if health == 0:
		frame = 11
		set_process(false)
		$AudioStreamPlayer2.play()
		#await get_tree().create_timer(2.0).timeout
		#queue_free()
