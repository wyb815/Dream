extends KinematicBody2D

const SPEED := 50

var direction := 1.0
var velocity = Vector2()
var up_dir := Vector2(0, -1)
var height := 40;

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var rayCastL := $rayCastL as RayCast2D
onready var rayCastR := $rayCastR as RayCast2D

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if _check_on_cliff():
			# 遇到悬崖走反方向
			direction = -direction
			

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	velocity = move_and_slide(velocity, up_dir)
	
	if _is_touching_wall():
		# 碰到墙
		direction = -direction;

func _check_on_cliff() -> bool:
	# --- 悬崖检测逻辑 ---
	var is_on_cliff = false
	# 如果玩家正要移动
	if velocity.x != 0:
		# 判断移动方向的射线是否没有碰到地面
		if velocity.x < 0:
			if not rayCastL.is_colliding():
				is_on_cliff = true
		else:
			if not rayCastR.is_colliding():
				is_on_cliff = true
	return is_on_cliff
	
func _is_touching_wall() -> bool:
	for i in range(get_slide_count()):
		var normal = get_slide_collision(i).get_normal()
		if abs(normal.x) > 0.5:  # 水平方向
			return true
	return false
	
func on_anti_gravity(is_anti: bool):
	var height = 40
	if is_anti:
		scale.y = -1
		position.y -= height
	else:
		scale.y = 1
		position.y += height
	move_and_slide(Vector2.ZERO, up_dir)
