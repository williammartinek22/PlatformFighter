extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction
# Called when the node enters the scene tree for the first time.

func _ready():
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	
	input_direction = Input.get_axis("ui_left", "ui_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	input_direction = Input.get_axis("ui_left", "ui_right")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
		
	if Input.is_action_just_pressed("Z") and player.get_node("Attacks/Neutral").disabled == true:
		attack.rpc(Input.is_action_pressed("ui_down"),Input.is_action_pressed("ui_up"))
		
	if Input.is_action_just_pressed("X"):
		guard.rpc()
		
	if Input.is_action_just_pressed("ui_down"):
		crouch.rpc()
	elif Input.is_action_just_released("ui_down"):
		uncrouch.rpc()
		
@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true
		
@rpc("call_local")
func attack(attack_down,attack_up):
	if multiplayer.is_server():
		player.attack(attack_up,attack_down,false)

@rpc("call_local")
func crouch():
	if multiplayer.is_server():
		player.crouch()
		
@rpc("call_local")
func uncrouch():
	if multiplayer.is_server():
		player.do_crouch = false
		
@rpc("call_local")
func guard():
	if multiplayer.is_server():
		player.do_guard = true
