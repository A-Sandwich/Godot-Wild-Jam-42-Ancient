extends CanvasLayer


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Timer_timeout():
	$AnimationPlayer.play("fade")
