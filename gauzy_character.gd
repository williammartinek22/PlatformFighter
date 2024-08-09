extends MultiplayerController

@export var explosive: PackedScene
@export var crystal: PackedScene

var hornAttack = false
var coolDown = 0.0

func _physics_process(delta):
	$ProjectileSpawner.spawn_function = spawn_explosive
	coolDown -= delta * 10
	if frame < $GauzySpriteSheet.hframes:
		$GauzySpriteSheet.frame = frame
	super(delta)

func _super():
	if superBar.value >= 100:
		$SuperSheet.show()
		$SuperSheet.play("default")
		$GauzySpriteSheet.hide()
		await $SuperSheet.animation_finished
		$GauzySuperSpriteSheet.show()
		$SuperSheet.hide()
		hornAttack = true
		superBar.value = 0
		await get_tree().create_timer(8.0).timeout
		hornAttack = false
		$GauzySuperSpriteSheet.hide()
		$GauzySpriteSheet.show()

func attack(input_up,input_down,input_c):
	if input_up:
		if input_c:
			frame = 7#Parachute potion
			$Attacks/UpPower.disabled = false
			velocity = Vector2(0,-100)
		else:
			velocity = Vector2(0,-1000)
	elif input_down:
		if input_c and coolDown <= 0 and is_on_floor():
			var leftCrystal = crystal.instantiate()
			var rightCrystal = crystal.instantiate()
			get_tree().root.add_child(leftCrystal,true)
			get_tree().root.add_child(rightCrystal,true)
			var floorPosition = Vector2(position.x,position.y+85)
			leftCrystal.position = floorPosition
			rightCrystal.position = floorPosition
			leftCrystal.direction = -1
			rightCrystal.direction = 1
			leftCrystal.sender = self
			rightCrystal.sender = self
			coolDown = 5.0
		elif !input_c:
			frame = 5
			$Attacks/DownAttack.disabled = false
			velocity = Vector2(0,300)
	elif input_c:
		if coolDown <= 0:
			$ProjectileSpawner.spawn(1)
	else:
		pass
	if hornAttack:
		$Attacks/BeetleFormCollision.disabled = false
		$GauzySuperSpriteSheet.play("default")
	var attacks = $Attacks.get_children()
	for attack in attacks:
		if attack is CollisionShape2D:
			attack.disabled = true
	
func spawn_explosive(_x) -> Node:
	var explInst = explosive.instantiate()
	if explInst:
		explInst.dir = transform.x.x
		explInst.position = position
		explInst.sender = self
		coolDown = 10.0
		return explInst
	else:
		return null
