extends Node2D
var cursorenemy = preload("res://enemysight.png")
var cursorfriend = preload("res://friendlysight.png")
var current = "friend"
var prev = "friend"

var bullet_scene = preload("res://Bullet.tscn")  # Adjust path

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = get_viewport().get_mouse_position()
	bullet.rotation = 0  # Point right; adjust if you want direction
	get_tree().current_scene.add_child(bullet)
	
func _ready() -> void:
	spawn_enemy()
	
func _physics_process(_delta: float) -> void:
	if(Input.is_action_just_pressed("changesight") and current != "friend" ):
		current="friend"
	elif(Input.is_action_just_pressed("changesight") and current != "enemy" ):
		current="enemy"
	if(current=="friend"):
		Input.set_custom_mouse_cursor(cursorfriend, Input.CURSOR_CROSS, Vector2(130, 130))
	
		
	if(current=="enemy"):
		Input.set_custom_mouse_cursor(cursorenemy, Input.CURSOR_CROSS, Vector2(130, 130))
		
		
	
func spawn_enemy():
	var new_mob = preload("res://enemy.tscn").instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_mob.global_position=%PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_friend():
	var new_friend = preload("res://friend.tscn").instantiate()
	%PathFollow2D.progress_ratio=randf()
	new_friend.global_position=%PathFollow2D.global_position
	add_child(new_friend)
	


func _on_enemy_timer_timeout() -> void:
	spawn_enemy()
	



func _on_friend_timer_timeout() -> void:
	spawn_friend()
