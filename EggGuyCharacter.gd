extends MultiplayerController

func _physics_process(delta):
	$EggGuySpriteSheet.frame = frame
	super(delta)

func _super():
	if superBar.value >= 100:
		$SuperSheet.show()
		$SuperSheet.play("default")
		$EggGuySpriteSheet.hide()
		await $SuperSheet.animation_finished
		$SuperSheet.hide()
		$Chacken.show()
		$Attacks/ChackenCollisionPolygon2D.disabled = false
		$AudioStreamPlayer3.play()
		superBar.value = 0
		await get_tree().create_timer(8.0).timeout
		$Chacken.hide()
		$Attacks/ChackenCollisionPolygon2D.disabled = true
		$EggGuySpriteSheet.show() 
		$AudioStreamPlayer3.stop()
