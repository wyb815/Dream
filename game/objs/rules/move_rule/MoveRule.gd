extends Node2D

class_name MoveRule

var velocity: Vector2
var gravity := 980
var up_dir := Vector2.UP
var init_dir: float
var born_pos: Vector2

export var direction := 0.0
export var move_speed := 200.0
export var jump_speed := 580.0

onready var body := get_parent() as KinematicBody2D
onready var ray_l := get_parent().get_node('ray_l')
onready var ray_r := get_parent().get_node('ray_r')

func _ready():
	init_dir = direction
	born_pos = body.global_position
	
func reset_to_ready():
	direction = init_dir
	velocity = Vector2.ZERO
	body.global_position = born_pos

func handle_gravity(delta: float):
	if velocity.y > 0 && body.is_on_floor():
		velocity.y = 0
	else:
		# 重力
		velocity.y += gravity * delta
		
func handle_move_speed():
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

func move():
	velocity = body.move_and_slide_with_snap(velocity, Vector2(0, -up_dir.y * 2.0), up_dir)

func is_on_cliff() -> bool:
	# --- 悬崖检测逻辑 ---
	var is_on_cliff = false
	# 如果玩家正要移动
	if velocity.x != 0:
		# 判断移动方向的射线是否没有碰到地面
		if velocity.x < 0:
			if not ray_l.is_colliding():
				is_on_cliff = true
		else:
			if not ray_r.is_colliding():
				is_on_cliff = true
	return is_on_cliff
