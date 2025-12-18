extends Area2D

@export var is_player_one = false
@export var is_ai = false

@onready var paddel = $CollisionShape2D

var up_input = "paddel_up"
var down_input = "paddel_down"

const MAX_VELOCITY = 10.0
var velocity = 0.0
var acceleration = 50.0
var deceleration_delta = 2.0

var ai_target_pos_y = 360.0
var ai_accuracy = 30.0

func _ready() -> void:
	if is_player_one == false:
		up_input += "_two"
		down_input += "_two"

func _physics_process(delta: float) -> void:
	var move_dir = 0.0
	
	if is_ai:
		move_dir = get_ai_move_dir()
	else:
		move_dir = Input.get_axis(up_input, down_input)
	
	velocity += move_dir * acceleration * delta
	
	if move_dir == 0.0:
		velocity = move_toward(velocity, 0.0, deceleration_delta)
		
	velocity = clampf(velocity, -MAX_VELOCITY, MAX_VELOCITY)
	
	var new_position = global_position.y + velocity
	var paddel_height = paddel.shape.size.y
	var min_position = paddel_height/2
	var max_position = get_viewport().get_visible_rect().size.y - paddel_height/2
	
	global_position.y = clampf(new_position, min_position, max_position)


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddel(global_position.y, paddel.shape.size.y)

func get_ai_move_dir() -> int:
	var distance_to_target = abs(ai_target_pos_y - global_position.y)
	var accuracy_distance = randf_range(25.0, paddel.shape.get_rect().size.y * 1.5)
	
	if distance_to_target > accuracy_distance:
		return 1 if ai_target_pos_y > global_position.y else -1
	else:
		return 0
 
