extends Node2D

class_name MoveRule

var velocity: Vector2
var gravity := 980
var up_dir := Vector2.UP
var init_dir: float
var born_pos: Vector2

var is_follow := false
var follow_v := Vector2(0, 0)
var catch_by: Node2D

export var direction := 0.0
export var move_speed := 200.0
export var jump_speed := 580.0

onready var body := get_parent() as KinematicBody2D
onready var ray_l := get_parent().get_node('ray_l') as RayCast2D
onready var ray_r := get_parent().get_node('ray_r') as RayCast2D
onready var platform := get_parent().get_node('platform') as KinematicBody2D

func _ready():
	init_dir = direction
	born_pos = body.global_position
	if platform:
		body.get_parent().add_child(platform)
		platform.add_collision_exception_with(body)
	
func reset_to_ready():
	direction = init_dir
	velocity = Vector2.ZERO
	body.global_position = born_pos

func handle_gravity(delta: float):
	# 重力
	if body.is_on_floor():
		if velocity.y > 0:
			velocity.y = 0
	else:
		velocity.y += gravity * delta
		
func handle_move_speed():
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

func sync_platform_pos():
	if platform:
		platform.global_position = body.global_position

func move():
	velocity = body.move_and_slide_with_snap(velocity, Vector2(0, -up_dir.y * 2.0), up_dir)
	sync_platform_pos()
	
func follow():
	velocity = follow_v
	if velocity.y > 0 && body.is_on_floor():
		velocity.y = 0
	velocity = body.move_and_slide(velocity, up_dir)
	sync_platform_pos()

func is_on_cliff_l() -> bool:
	# --- 悬崖检测逻辑 ---
	return not ray_l.is_colliding()
	
func is_on_cliff_r() -> bool:
	# --- 悬崖检测逻辑 ---
	return not ray_r.is_colliding()

func try_to_catch(_catch_by: Node2D):
	set_catch(_catch_by)
	return true
	
func set_catch(_catch_by: Node2D):
	if catch_by != _catch_by:
		if catch_by:
			catch_by.on_release_catch()
		catch_by = _catch_by
	is_follow = true
	
func release_catch(_catch_by: Node2D):
	var self_catch_by = catch_by
	if self_catch_by && (!_catch_by || self_catch_by == _catch_by):
		is_follow = false
		catch_by = null
		self_catch_by.on_release_catch()
	
