extends Label
var friends = 0;

func _physics_process(delta: float) -> void:
	if friends<5:
		hide()
	else:
		show()
		get_tree().paused = true


func _on_friend_incr_score() -> void:
	friends+=1
