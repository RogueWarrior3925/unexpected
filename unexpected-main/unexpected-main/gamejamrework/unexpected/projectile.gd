extends Area2D

@export var speed: float = 5000.0
@export var velocity: Vector2 = Vector2(1, 0) # Renamed 'direction' to 'velocity'
@export var damage_amount: int = 10
@onready var animated_sprite = $AnimatedSprite2D

# --- Ready ---
func _ready():
	# Optional: You can add a timer to auto-destroy after a while if needed
	# var timer = Timer.new()
	# timer.wait_time = 5.0
	# timer.one_shot = true
	# timer.timeout.connect(_on_timeout)
	# add_child(timer)
	# timer.start()
	
	# Connect signal for body collision detection
	body_entered.connect(_on_body_entered) # Changed to `body_entered.connect` for clarity

# --- Physics Process ---
func _physics_process(delta):
	position += velocity.normalized() * speed * delta # Using 'velocity' now

# --- Return damage amount when asked ---
func get_damage_amount() -> int:
	return damage_amount

# --- Handle collisions ---
func _on_body_entered(body: Node):
	if body.is_in_group("pp"):
		if body.has_method("take_damage_from_attacker"):
			body.take_damage_from_attacker(damage_amount, self)
		queue_free()
		# NOTE: Calling play("default") *after* queue_free() might not always work as expected
		# because the node is about to be removed.
		# If you want an animation before it disappears, consider creating an "explosion"
		# or "impact" scene that instances at this location and then frees itself.
		# For now, I've commented out the play() line to prevent potential issues.
		# animated_sprite.play("default")

# --- Optional timeout handler ---
func _on_timeout():
	queue_free()

func _on_timer_timeout() -> void:
	# This function seems unrelated to the projectile's typical lifecycle.
	# It reloads the entire scene, which is usually not what you want a projectile to do on its own.
	# I'm commenting it out as it's likely a leftover or intended for a different context.
	# get_tree().reload_current_scene()
	pass
