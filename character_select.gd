extends Control

var Characters = [
	preload("res://egg_guy_character.tscn"),
	preload("res://gauzy_character.tscn")
]

var blueSelector
var redSelector

# Called when the node enters the scene tree for the first time.
func _ready():
	MultiplayerManager.selectorOne = %BlueSelector
	MultiplayerManager.selectorTwo = %RedSelector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("X"):
		get_tree().change_scene_to_file("res://main_scene.tscn")

func _button_pressed(selector, index):
	print($ColorRect/GridContainer.get_child(index).name)
	if selector.name == "BlueSelector":
		MultiplayerManager.characterOne = Characters[selector.index]
	else:
		MultiplayerManager.characterTwo = Characters[selector.index]


func update_position(selector, index):
	if index < 0 or index >= $ColorRect/GridContainer.get_child_count():
		return
	selector.global_position = $ColorRect/GridContainer.get_child(index).global_position
	selector.index = index
