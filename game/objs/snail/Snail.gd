extends KinematicBody2D

export var move_to_left := true

onready var move_rule := $move_rule as MoveRule

func _ready():
	_reset_to_born()
	
func _reset_to_born():
	move_rule.reset_to_ready()
	if move_to_left:
		move_rule.direction = -1.0
	else:
		move_rule.direction = 1.0

func _physics_process(delta: float) -> void:	
	move_rule.handle_gravity(delta)
	
	if is_on_floor():
		if move_rule.is_on_cliff():
			# 遇到悬崖走反方向
			move_rule.direction = -move_rule.direction
	
	if is_on_wall():
		# 碰到墙
		move_rule.direction = -move_rule.direction;
		
	move_rule.handle_move_speed()
	move_rule.move()

func die():
	_reset_to_born()
