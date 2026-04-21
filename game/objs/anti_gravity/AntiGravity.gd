extends Area2D

tool

export(Vector2) var size setget set_size,get_size

func set_size(val: Vector2):
	if !$col:
		return
	($col.shape as RectangleShape2D).extents = val
	
func get_size():
	if !$col:
		return Vector2.ZERO
	return ($col.shape as RectangleShape2D).extents

func _on_AntiGravity_body_entered(body):
	_on_AntiGravity_change(body, true)


func _on_AntiGravity_body_exited(body):
	_on_AntiGravity_change(body, false)

func _on_AntiGravity_change(body: Node, is_anti: bool):
	if 'gravity' in body and 'up_dir' in body:
		var pre_up_y = body.up_dir.y;
		if is_anti:
			body.gravity = -abs(body.gravity)
			body.up_dir.y = abs(body.up_dir.y)
		else:
			body.gravity = abs(body.gravity)
			body.up_dir.y = -abs(body.up_dir.y)
			
		if pre_up_y * body.up_dir.y < 0:
			# 有变化
			on_anti_gravity(body, is_anti)
		
func on_anti_gravity(body: Node2D, is_anti: bool):
	var height = body.height
	if is_anti:
		body.scale.y = -1
		body.position.y -= height
	else:
		body.scale.y = 1
		body.position.y += height
	body.move_and_slide(Vector2.ZERO, body.up_dir)
