extends Node
signal friend
signal enemy
var cursorenemy = preload("res://enemysight.png")
var cursorfriend = preload("res://friendlysight.png")
var current = "friend"
var prev = "friend"
func _physics_process(delta: float) -> void:
	#if(Input.is_action_just_pressed("changesight") and current != "friend" ):
#		current="friend"
	#elif(Input.is_action_just_pressed("changesight") and current != "enemy" ):
		#current="enemy"
	#if(current=="friend"):
		#Input.set_custom_mouse_cursor(cursorfriend, Input.CURSOR_CROSS, Vector2(130, 130))
	
		
	#elif(current=="enemy"):
		#Input.set_custom_mouse_cursor(cursorenemy, Input.CURSOR_CROSS, Vector2(130, 130))
		
	if Input.is_action_just_released("changesight"):
		if current =="friend":
			current="enemy"
		else:
			current="friend"
			
	if(current=="friend"):
		Input.set_custom_mouse_cursor(cursorfriend, Input.CURSOR_CROSS, Vector2(130, 130))
		emit_signal("friend")
		
	elif(current=="enemy"):
		Input.set_custom_mouse_cursor(cursorenemy, Input.CURSOR_CROSS, Vector2(130, 130))
		emit_signal("enemy")
		
	
	
	
