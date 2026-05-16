extends KinematicBody2D

var jump_apply_left_time := 0.0

# 冲击速度
var apply_vels := []
var is_in_apply_vel := false

var record_follow = false;

onready var move_rule := $move_rule as MoveRule

func _physics_process(delta: float) -> void:
	var last_follow = record_follow
	record_follow = move_rule.is_follow
	
	_check_collide()
	
	if move_rule.is_follow:
		move_rule.follow()
		if move_rule.is_follow:
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

func die():
	move_rule.release_catch(null)
	move_rule.reset_to_ready()
	
func get_ctrl_dir():
	var input_dir = Vector2()
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = -1.0 if Input.is_action_pressed("ui_accept") else 0.0
	return input_dir
	
