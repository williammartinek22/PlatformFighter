extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	MultiplayerManager.selectorOne = %BlueSelector
	MultiplayerManager.selectorTwo = %RedSelector
