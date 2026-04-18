extends KinematicBody2D

var catched_by_area: Area2D
var move_speed := 200.0
var vel := Vector2()

onready var handle := $handle

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_priority(ProcessPriority.BALLON)


func _physics_process(delta):
	if catched_by_area:
		if catched_by_area.get_parent().is_follow:
			vel = Vector2(0, -move_speed)
		
			# 拖着走
			var final_vel = move_and_slide(vel, Vector2.UP);
			
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
	
