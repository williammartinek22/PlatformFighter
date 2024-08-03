extends TextureRect

var columns

@export var player_id = 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)
		#name = str(id)
		
@export var index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	columns = 4#$ColorRect/GridContainer.columns


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_left"):
		#$"../../".update_position(self, index - 1)
	#if Input.is_action_just_pressed("ui_right"):
		#$"../../".update_position(self, index + 1)
		##We'll see if this works once there's more characters
	#if Input.is_action_just_pressed("ui_up"):
		#$"../../".update_position(self, index - columns)
	#if Input.is_action_just_pressed("ui_down"):
		#$"../../".update_position(self, index + columns)
		#
	#if Input.is_action_just_pressed("Z"):
		#$"../../"._button_pressed(self, index)
		
