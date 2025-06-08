extends Area2D
var cursorenemy = preload("res://enemysight.png")
var cursorfriend = preload("res://friendlysight.png")
var current = "friend"
var prev = "friend"
@export var shoot_button: String = "shoot"

const BULLET = preload("res://bullet_2d.tscn")
const BULLETF = preload("res://bullet_2_dfriendly.tscn")

func _process(_delta):

	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed(shoot_button):
		if(current=="enemy"):
			shootenemy()
		if(current=="friend"):
			shootfriend()

func shootenemy():
	var new_bullet = BULLET.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	get_tree().current_scene.add_child(new_bullet)
func shootfriend():
	var new_bullet = BULLETF.instantiate()
	new_bullet.global_transform = %ShootingPoint.global_transform
	get_tree().current_scene.add_child(new_bullet)
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("changesight") and current != "friend" ):
		current="friend"
	elif(Input.is_action_just_pressed("changesight") and current != "enemy" ):
		current="enemy"
	if(current=="friend"):
		Input.set_custom_mouse_cursor(cursorfriend, Input.CURSOR_CROSS, Vector2(130, 130))
	
		
	if(current=="enemy"):
		Input.set_custom_mouse_cursor(cursorenemy, Input.CURSOR_CROSS, Vector2(130, 130))
