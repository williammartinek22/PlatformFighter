extends TextureRect

var columns

@export var player_id = 1:
	set(id):
		player_id = id
		$InputSynchronizer.set_multiplayer_authority(id)
		
@export var index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	columns = 4#$ColorRect/GridContainer.columns


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = $InputSynchronizer.selector_position
