extends CharacterBody2D

class_name Ball

@export var speed_increase_on_paddel_bounce = 50.0

const START_SPEED = 500.0
const MAX_SPEED = 1000.0

var active = false
var speed = START_SPEED
var move_dir = Vector2(1 if randi() % 2 == 0 else -1, 0.0)

func _physics_process(delta: float) -> void:
	if !active: return
	
	velocity = move_dir * speed
	
	var collided = move_and_slide()
	
	if collided:
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())

func bounce_from_paddel(	 paddel_y: float, paddel_height: float):
	var new_move_dir_y = (global_position.y - paddel_y) / (paddel_height / 2.0)
	move_dir.y = new_move_dir_y
	move_dir.x *= -1

	var new_speed = speed + speed_increase_on_paddel_bounce
	speed = clampf(new_speed, 0.0, MAX_SPEED)
	
func reset(reset_pos: Vector2) -> void:
	global_position = reset_pos
	speed = START_SPEED
	active = false
	
	move_dir.x = 1 if randi() % 2 == 0 else -1
	move_dir.y = randf() * 1 if randi() % 2 == 0 else -1
