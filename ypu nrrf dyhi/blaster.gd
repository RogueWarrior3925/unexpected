extends CharacterBody2D



func _physics_process(delta: float) -> void:
	rotate(%rotation.rotation)
	var mouse = get_global_mouse_position()
	if (mouse.x>%rotation.global_position.x):
		%Blaster.flip_v = false
	if (mouse.x<%rotation.global_position.x):
		%Blaster.flip_v = true
	
