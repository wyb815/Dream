extends KinematicBody2D

var is_follow := false
var follow_v := Vector2(0, 0)
var catch_by: Node2D

var jump_apply_left_time := 0.0


# 冲击速度
var apply_vels := []
var is_in_apply_vel := false

var record_follow = false;

onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var move_body = $move
onready var con = $con
onready var move_rule = $move_rule

func _physics_process(delta: float) -> void:
	var last_follow = record_follow
	record_follow = is_follow
	
	_check_collide()
	
	if is_follow:
		_handle_follow()
		if is_follow:
			return
	
	move_rule.handle_gravity(delta)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		is_in_apply_vel = false
		move_rule.velocity.x = direction * move_rule.move_speed
	else:
		if !is_in_apply_vel || is_on_floor():
			move_rule.velocity.x = move_toward(move_rule.velocity.x, 0, move_rule.move_speed)
		
	if Input.is_action_just_pressed("ui_accept"):
		if last_follow || is_on_floor():
			jump_apply_left_time = 0.5
			move_rule.velocity.y = move_rule.jump_speed * move_rule.up_dir.y
	else:
		if jump_apply_left_time > 0:
			if Input.is_action_pressed("ui_accept"):
				jump_apply_left_time -= delta
			else:
				#松开跳跃键，跳的近一些
				move_rule.velocity.y *= 0.3
				jump_apply_left_time = 0
				
	# 外部施加的速度
	if apply_vels.size() > 0:
		is_in_apply_vel = true;
		move_rule.velocity = Vector2.ZERO
		move_rule.velocity = apply_vels[0]
	apply_vels.clear();
	
	move_rule.move();

func _check_collide():
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		var collider := collision.collider as Node2D
		
		if !is_instance_valid(collider):
			continue
		
		var groups = collider.get_groups()
	
		if groups.has('arrow'):
			die()
		if groups.has('apply_vel'):
			apply_vels.append(collision.normal * collider.apply_speed)
	
func _handle_follow():
	move_rule.velocity = follow_v
	if move_rule.velocity.y > 0 && is_on_floor():
		move_rule.velocity.y = 0
	move_rule.velocity = move_and_slide(move_rule.velocity, move_rule.up_dir)

func die():
	move_rule.reset_to_ready()
	CatchRule.release_catch(self, null)
	
func get_ctrl_dir():
	var input_dir = Vector2()
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = -1.0 if Input.is_action_pressed("ui_accept") else 0.0
	return input_dir
	
