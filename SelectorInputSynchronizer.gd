extends MultiplayerSynchronizer


@onready var player = $".."
@onready var selector_position = player.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
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
		
@rpc("call_local")
func move(index):
	if multiplayer.is_server():
		update_position(index)
		
func update_position(index):
	var grid_container_inst = $"../../../ColorRect/GridContainer"
	var selector = $"../"
	if index < 0 or index >= grid_container_inst.get_child_count():
		return
	selector_position = grid_container_inst.get_child(index).global_position
	selector.index = index
