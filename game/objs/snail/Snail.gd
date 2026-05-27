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
	
	if move_rule.direction == 0:
		_reset_direction()
	
	var cliff_change_to_dir := -2.0
	if is_on_floor():
		var l = move_rule.is_on_cliff_l()
		var r = move_rule.is_on_cliff_r()
		
		if l || r:
			if l && r:
				cliff_change_to_dir = 0
			elif l:
				cliff_change_to_dir = 1.0
			else:
				cliff_change_to_dir = -1.0
	
	var wall_change_to_dir := -2.0
	if move_rule.is_on_wall():
		# 碰到墙
		wall_change_to_dir = -1.0 if move_rule.wall_dir_x > 0 else 1.0
	
	# 综合考量移动方向
	if abs(wall_change_to_dir) == 1.0:
		move_rule.direction = wall_change_to_dir
	elif cliff_change_to_dir == 0.0 || wall_change_to_dir * cliff_change_to_dir == -1.0:
		move_rule.direction = 0
	elif abs(cliff_change_to_dir) == 1.0:
		move_rule.direction = cliff_change_to_dir

	move_rule.handle_move_speed()
	move_rule.move()	

func die():
	_reset_to_born()
