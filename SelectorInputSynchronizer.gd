extends MultiplayerSynchronizer

@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		move.rpc(player.index - 1)
	if Input.is_action_just_pressed("ui_right"):
		move.rpc(player.index + 1)
		#We'll see if this works once there's more characters
	if Input.is_action_just_pressed("ui_up"):
		move.rpc(player.index - player.columns)
	if Input.is_action_just_pressed("ui_down"):
		move.rpc(player.index + player.columns)
		
	if Input.is_action_just_pressed("Z"):
		$"../../../"._button_pressed(player, player.index)
		
@rpc("call_local","any_peer")
func move(index):
	if multiplayer.is_server() or get_multiplayer_authority() != multiplayer.get_unique_id():
		$"../../../".update_position(player, index)
