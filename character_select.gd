extends Control

var Characters = [
	preload("res://egg_guy_character.tscn"),
	preload("res://gauzy_character.tscn")
]

var blueSelector
var redSelector

var columns = $ColorRect/GridContainer.columns

var blueIndex = 0
var redIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	blueSelector = %BlueSelector
	redSelector = %RedSelector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		update_position(blueSelector, blueIndex - 1)
	if Input.is_action_just_pressed("ui_right"):
		update_position(blueSelector, blueIndex + 1)
		
	if Input.is_action_just_pressed("Z"):
		_button_pressed(blueSelector, blueIndex)
	if Input.is_action_just_pressed("X"):
		get_tree().change_scene_to_file("res://main_scene.tscn")

func _button_pressed(selector, index):
	print($ColorRect/GridContainer.get_child(index).name)
	MultiplayerManager.characterOne = Characters[index]

func update_position(selector, index):
	if index < 0 or index >= $ColorRect/GridContainer.get_child_count():
		return
	selector.global_position = $ColorRect/GridContainer.get_child(index).global_position
	blueIndex = index
