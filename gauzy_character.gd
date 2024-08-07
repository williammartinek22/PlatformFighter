extends MultiplayerController

@export var explosive: PackedScene

var hornAttack = false
var coolDown = 0.0

func _physics_process(delta):
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
			pass
		else:
			pass
	elif input_down:
		if input_c:
			pass
		else:
			pass
	elif input_c:
		if coolDown <= 0:
			$ProjectileSpawner.spawn_function = spawn_explosive
			$ProjectileSpawner.spawn(1)
	else:
		pass
	if hornAttack:
		$Attacks/BeetleFormCollision.disabled = false
		$GauzySuperSpriteSheet.play("default")
	#super(input_up,input_down,input_c)
	
func spawn_explosive(_x) -> Node:
	var explInst = explosive.instantiate()
	if explInst:
		get_tree().current_scene.add_child(explInst)
		explInst.position = position
		coolDown = 10.0
		return explInst
	else:
		return null
