extends Area2D

@export var is_player_one = false

@onready var paddel = $CollisionShape2D

var up_input = "paddel_up"
var down_input = "paddel_down"

const MAX_VELOCITY = 10.0
var velocity = 0.0
var acceleration = 50.0
var deceleration_delta = 2.0

func _ready() -> void:
	if is_player_one == false:
		up_input += "_two"
		down_input += "_two"

func _physics_process(delta: float) -> void:
	var move_dir = 0.0
	
	move_dir = Input.get_axis(up_input, down_input)
	velocity += move_dir * acceleration * delta
	
	if move_dir == 0.0:
		velocity = move_toward(velocity, 0.0, deceleration_delta)
		
	velocity = clampf(velocity, -MAX_VELOCITY, MAX_VELOCITY)
	
	var new_position = global_position.y + velocity
	var paddel_height = paddel.shape.size.y
	var min_position = paddel_height/2
	var max_position = Constants.game_area_size.y - paddel_height/2
	
	global_position.y = clampf(new_position, paddel_height/2, max_position)


func _on_body_entered(body: Node2D) -> void:
	if body is Ball:
		body.bounce_from_paddel(global_position.y, paddel.shape.size.y)
