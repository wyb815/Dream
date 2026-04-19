extends KinematicBody2D

export(NodePath) var balloon_end

var catched_by_area: Area2D
var move_speed := 200.0
var vel := Vector2()
var end_pos := Vector2()

onready var handle := $handle

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_priority(ProcessPriority.BALLON)
	if balloon_end:
		end_pos = (get_node(balloon_end) as Node2D).global_position

func _physics_process(delta):
	if not balloon_end:
		return
		
	if catched_by_area:
		if catched_by_area.get_parent().is_follow:
			var target_pos = get_parent().to_local(end_pos)
			
			if target_pos == position:
				catched_by_area.get_parent().is_follow = false;
				catched_by_area = null
				return
			
			var calc_pos = position.move_toward(target_pos, move_speed * delta)
			var move_offset = target_pos - position
			var final_vel;
			
			if calc_pos != end_pos:
				final_vel = move_and_slide(move_offset.normalized() * move_speed, Vector2.UP)
			else:
				# 到达目的地
				final_vel = move_and_slide(move_offset / delta, Vector2.UP)
			
			# 拖着走
			catched_by_area.get_parent().follow_v = final_vel
		else:
			catched_by_area = null

func _on_Area2D_area_entered(area: Area2D):
	if catched_by_area:
		# 已经有被抓住了
		return
	
	if area.name == 'hand':
		catched_by_area = area
		catched_by_area.get_parent().is_follow = true
		_fix_body_pos()

func _on_Area2D_area_exited(area: Area2D):
	if catched_by_area == area:
		catched_by_area.get_parent().is_follow = false;
		catched_by_area = null

func _fix_body_pos():
	var global_offset = handle.global_position - catched_by_area.global_position
	
	catched_by_area.get_parent().global_position += global_offset
	
