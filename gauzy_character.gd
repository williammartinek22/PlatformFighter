extends MultiplayerController


func _physics_process(delta):
	if frame < $GauzySpriteSheet.hframes:
		$GauzySpriteSheet.frame = frame
	super(delta)
