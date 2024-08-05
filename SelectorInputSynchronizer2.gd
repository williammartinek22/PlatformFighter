extends MultiplayerSynchronizer


@onready var player = $".."
@onready var selector_position = player.global_position
var player_index = 0
var character

var Characters = [
	preload("res://egg_guy_character.tscn"),
	preload("res://gauzy_character.tscn")
]

func _physics_process(delta):
	if multiplayer.get_unique_id() != 1:
		set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.get_unique_id() == 1:
		set_process(false)
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
		press.rpc(player.index)
				
	if Input.is_action_just_pressed("X"):
		if MultiplayerManager.characterOne != null and MultiplayerManager.characterTwo != null:
			change_scene.rpc()
		else:
			print("ERROR: SELECT CHARACTERS FIRST WITH THE Z BUTTON")
		
@rpc("call_local","any_peer")
func change_scene():
	MultiplayerManager._load_game_scene()
	#get_tree().change_scene_to_file("res://main_scene.tscn")
		
@rpc("call_local")
func move(index):
	player_index= index
	update_position(index)
		
@rpc("call_local")
func press(index):
	#if multiplayer.is_server():
		character = Characters[index]
		MultiplayerManager.characterTwo = character
		
func update_position(index):
	var grid_container_inst = $"../../../ColorRect/GridContainer"
	var selector = $"../"
	if index < 0 or index >= grid_container_inst.get_child_count():
		return
	selector_position = grid_container_inst.get_child(index).global_position
	selector.index = index
