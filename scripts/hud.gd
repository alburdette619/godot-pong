extends Control

@onready var left_score = $LeftScore
@onready var right_score = $RightScore

func set_new_score(score: Vector2i) -> void:
	left_score.text = str(score.x)
	right_score.text = str(score.y)

func reset_score() -> void:
	left_score.text = "0"
	right_score.text = "0"
