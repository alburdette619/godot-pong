extends Node2D

@onready var detector_left = $Environment/ScoreDetectorLeft
@onready var detector_right = $Environment/ScoreDetectorRight
@onready var ball = $Ball/Ball
@onready var start_delay = $StartDelay
@onready var hud = $CanvasLayer/Hud
@onready var left_paddel = $Paddels/PaddelOne
@onready var right_paddel = $Paddels/PaddelTwo
@onready var ball_sound = $Ball/BallSound

var game_area_size = Constants.game_area_size
var score = Vector2i.ZERO
@export var final_score = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	ball.bounced.connect(_on_ball_bounced)
	
	game_area_size = get_viewport().get_visible_rect().size
	
	randomize()
	
	reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _draw() -> void:
	var line_start = Vector2(game_area_size.x/2, 0)
	var line_end = Vector2(game_area_size.x/2, game_area_size.y)
	draw_dashed_line(line_start, line_end, Color.WHITE, 8, 12, false)

func reset_game() -> void:
	score = Vector2i.ZERO
	hud.reset_score()
	reset_round()

func reset_round() -> void:
	ball.reset(game_area_size / 2.0)
	start_delay.start()
	await start_delay.timeout
	ball.active = true
	_simulate_ball_movements()

func _on_detector_ball_out(is_left: bool) -> void:
	if is_left:
		score.y += 1
	else:
		score.x += 1
	
	ball_sound.play()
	
	hud.set_new_score(score)
	
	if score.x >= final_score || score.y >= final_score:
		reset_game()
	else:	
		reset_round()

func _on_ball_bounced() -> void:
	_simulate_ball_movements()

func _simulate_ball_movements(seconds: float = 3.0) -> void:
	var ball_position = ball.global_position
	var move_dir = ball.move_dir
	var ball_size = ball.get_size()
	
	var top_limit = ball_size.y / 2.0
	var bottom_limit = game_area_size.y - (ball_size.y / 2.0)
	var left_limit = left_paddel.global_position.x + (ball_size.y / 2.0)
	var right_limit = right_paddel.global_position.x - (ball_size.y / 2.0)
	
	var points = [ball_position]
	var delta_time = get_physics_process_delta_time()
	
	for i in range(0, 60 * seconds):
		ball_position += move_dir * ball.speed * delta_time
		
		if ball_position.x <= left_limit || ball_position.x >= right_limit:
			if ball_position.x <= left_limit && move_dir.x > 0:
				pass
			elif ball_position.x >= right_limit && move_dir.x < 0:
				pass
			else:
				break
		
		if ball_position.y <= top_limit || ball_position.y >= bottom_limit:
			move_dir.y *= -1
			points.append(ball_position)
		
	points.append(ball_position)
	
	var delay = randf()
	
	await get_tree().create_timer(delay, false, false, true).timeout
	
	if left_paddel.is_ai && move_dir.x < 0:
		left_paddel.ai_target_pos_y = ball_position.y
	if right_paddel.is_ai && move_dir.x > 0:
		right_paddel.ai_target_pos_y = ball_position.y
	
