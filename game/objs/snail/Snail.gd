extends KinematicBody2D

export var move_to_left := true

onready var move_rule := $move_rule as MoveRule

func _ready():
	_reset_to_born()
	
func _reset_to_born():
	move_rule.reset_to_ready()
	_reset_direction()
	
func _reset_direction():
	if move_to_left:
		move_rule.direction = -1.0
	else:
		move_rule.direction = 1.0

func _physics_process(delta: float) -> void:	
	move_rule.handle_gravity(delta)
	
	if is_on_floor():
		var l = move_rule.is_on_cliff_l()
		var r = move_rule.is_on_cliff_r()
		
		if l || r:
			if !l || !r:
				move_rule.direction = -move_rule.direction
			else:
				move_rule.direction = 0
		else:
			if move_rule.direction == 0:
				_reset_direction()
				
	if is_on_wall() && move_rule.direction:
		# 碰到墙
		move_rule.direction = -move_rule.direction
		
	move_rule.handle_move_speed()
	move_rule.move()	

func die():
	_reset_to_born()
