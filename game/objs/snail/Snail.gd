extends KinematicBody2D

export var move_to_left := true

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var rayCastL := $rayCastL as RayCast2D
onready var rayCastR := $rayCastR as RayCast2D
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
		if _check_on_cliff():
			# 遇到悬崖走反方向
			move_rule.direction = -move_rule.direction
	
	if is_on_wall():
		# 碰到墙
		move_rule.direction = -move_rule.direction;
		
	move_rule.handle_move_speed()
	move_rule.move()

func _check_on_cliff() -> bool:
	# --- 悬崖检测逻辑 ---
	var is_on_cliff = false
	# 如果玩家正要移动
	if move_rule.velocity.x != 0:
		# 判断移动方向的射线是否没有碰到地面
		if move_rule.velocity.x < 0:
			if not rayCastL.is_colliding():
				is_on_cliff = true
		else:
			if not rayCastR.is_colliding():
				is_on_cliff = true
	return is_on_cliff
	
func die():
	_reset_to_born()
