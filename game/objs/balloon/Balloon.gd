extends KinematicBody2D

export(NodePath) var balloon_end

var catched_by: MoveRule
var move_speed := 200.0
var vel := Vector2()
var end_pos: Vector2
var start_pos: Vector2
var is_start_move := false
var reach_stay_time := 0.0

onready var handle := $handle

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_priority(ProcessPriority.BALLON)
	start_pos = position
	if balloon_end:
		end_pos = (get_node(balloon_end) as Node2D).global_position

func _physics_process(delta):
	if not balloon_end:
		return
		
	if not is_start_move:
		return
		
	var target_pos = get_parent().to_local(end_pos)
			
	if target_pos == position:
		# 到达终点
		if reach_stay_time > 0:
			reach_stay_time -= delta
			if catched_by:
				catched_by.follow_v = Vector2.ZERO
		else:
			if catched_by:
				catched_by.release_catch(self)
				catched_by = null
			position = start_pos
			is_start_move = false
		return

	var calc_pos = position.move_toward(target_pos, move_speed * delta)
	var move_offset = target_pos - position
	var final_vel;

	if calc_pos != end_pos:
		final_vel = move_and_slide(move_offset.normalized() * move_speed, Vector2.UP)
	else:
		# 到达目的地
		final_vel = move_and_slide(move_offset / delta, Vector2.UP)
		reach_stay_time = 0.3
		
	if catched_by:
		catched_by.follow_v = final_vel
		if BehaviorUtils.is_player(catched_by.body):
			if Input.is_action_just_pressed("ui_accept"):
				on_release_catch()

func _on_Area2D_area_entered(area: Area2D):
	if catched_by:
		# 已经有被抓住了
		return
	
	if area.name == 'hand' && 'move_rule' in area.get_parent():
		var move_rule = area.get_parent().move_rule as MoveRule
		if move_rule.try_to_catch(self):
			move_rule.set_meta('hand', area)
			catched_by= move_rule
			_fix_body_pos()
			is_start_move = true

func _on_Area2D_area_exited(area: Area2D):
	if !catched_by:
		return
	if area.get_parent() == catched_by.body:
		on_release_catch()

func _fix_body_pos():
	var global_offset = handle.global_position - catched_by.get_meta('hand').global_position
	
	catched_by.get_meta('hand').get_parent().global_position += global_offset
	
func on_release_catch():
	if catched_by:
		catched_by.release_catch(self)
		catched_by = null
