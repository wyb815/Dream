extends Node2D

class_name MoveRule

var velocity: Vector2
var last_vel: Vector2
var gravity := 980
var up_dir := Vector2.UP
var init_dir: float
var born_pos: Vector2

var is_follow := false
var follow_v := Vector2(0, 0)
var catch_by: Node2D
var stand_on_platforms := {}
var wall_dir_x := 0.0

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
		platform.add_collision_exception_with(body)
		platform.set_meta('move_rule', self)
	
func reset_to_ready():
	direction = init_dir
	velocity = Vector2.ZERO
	body.global_position = born_pos

func handle_gravity(delta: float):
	# 重力
	velocity.y += gravity * delta
		
func handle_move_speed():
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

func move():
	if !direction && body.is_on_floor():
		var floor_vel = body.get_floor_velocity()

		# 移动平台上和移动平台水平速度相反需要特殊处理
		if floor_vel.x != 0 && floor_vel.x * velocity.x < 0:
			if body.test_move(body.transform, Vector2(-floor_vel.x * get_physics_process_delta_time(), 0)):
				velocity.x = 0
	
	var snapY = -up_dir.y * 2.0 if body.is_on_floor() else 0
	
	last_vel = velocity
	velocity = body.move_and_slide_with_snap(velocity, Vector2(0, -up_dir.y * 2.0), up_dir)
	_check_collide()
	
func follow():
	velocity = follow_v
	last_vel = velocity
	velocity = body.move_and_slide(velocity, up_dir)

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
		
func _check_collide():
	for move_rule in stand_on_platforms:
		(move_rule as MoveRule).body.remove_collision_exception_with(body)
	
	for i in range(body.get_slide_count()):
		var collision = body.get_slide_collision(i)
		var collider := collision.collider as PhysicsBody2D
		
		if !is_instance_valid(collider):
			continue
		
		var groups = collider.get_groups()
	
		if collider.name == 'platform':
			if up_dir.y < 0 && collision.normal.y < -0.5 || up_dir.y > 0 && collision.normal.y > 0.5:
				var move_rule = collider.get_meta('move_rule') as MoveRule
				
				if move_rule:
					move_rule.body.add_collision_exception_with(body)
					stand_on_platforms.set(move_rule, true)
		
func is_on_wall():
	if body.is_on_floor():
		var floor_vel = body.get_floor_velocity()
		
		# 移动平台上和移动平台水平速度相反需要特殊处理
		if floor_vel.x != 0 and floor_vel.x * direction < 0:
			if body.test_move(body.transform, Vector2(-floor_vel.x * get_physics_process_delta_time(), 0)):
				wall_dir_x = -floor_vel.x
				return true
	
	wall_dir_x = last_vel.x
	if body.is_on_floor():
		wall_dir_x += body.get_floor_velocity().x
	return body.is_on_wall()		
