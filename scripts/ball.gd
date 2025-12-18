extends CharacterBody2D

class_name Ball

@export var speed_increase_on_paddel_bounce = 50.0

@onready var cShape = $CollisionShape2D
@onready var wall_sound = $WallSound
@onready var paddel_sound = $PaddelSound

signal bounced

const START_SPEED = 400.0
const MAX_SPEED = 800.0

var active = false
var speed = START_SPEED
var move_dir = Vector2(1 if randi() % 2 == 0 else -1, 0.0)

func _physics_process(_delta: float) -> void:
	if !active: return
	
	velocity = move_dir * speed
	
	var collided = move_and_slide()
	
	if collided:
		move_dir = move_dir.bounce(get_last_slide_collision().get_normal())
		wall_sound.play()

func bounce_from_paddel(	 paddel_y: float, paddel_height: float):
	var new_move_dir_y = (global_position.y - paddel_y) / (paddel_height / 2.0)
	move_dir.y = new_move_dir_y
	move_dir.x *= -1

	var new_speed = speed + speed_increase_on_paddel_bounce
	speed = clampf(new_speed, 0.0, MAX_SPEED)
	
	paddel_sound.play()
	
	bounced.emit()
	
func reset(reset_pos: Vector2) -> void:
	global_position = reset_pos
	speed = START_SPEED
	active = false
	
	move_dir.x = 1 if randi() % 2 == 0 else -1
	move_dir.y = randf() * 1.0 if randi() % 2 == 0 else -1.0

func get_size() -> Vector2:
	return cShape.shape.get_rect().size
