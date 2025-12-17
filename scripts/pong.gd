extends Node2D

@onready var detector_left = $ScoreDetectorLeft
@onready var detector_right = $ScoreDetectorRight
@onready var ball = $Ball
@onready var start_delay = $StartDelay
@onready var hud = $CanvasLayer/Hud

var game_area_size = Constants.game_area_size
var score = Vector2i.ZERO
@export var final_score = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detector_left.ball_out.connect(_on_detector_ball_out)
	detector_right.ball_out.connect(_on_detector_ball_out)
	
	randomize()
	
	reset_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

func _on_detector_ball_out(is_left: bool) -> void:
	if is_left:
		score.y += 1
	else:
		score.x += 1
		
	hud.set_new_score(score)
	
	if score.x >= final_score || score.y >= final_score:
		reset_game()
	else:	
		reset_round()
