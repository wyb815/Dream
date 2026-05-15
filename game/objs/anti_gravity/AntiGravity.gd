extends Area2D

tool

export(Vector2) var size setget set_size

func set_size(val: Vector2):
	size = val
	if !$col:
		return
	($col.shape as RectangleShape2D).extents = Vector2.ZERO if val == Vector2.ZERO else val / 2
	
func _ready():
	set_size(size)

func _on_AntiGravity_body_entered(body):
	_on_AntiGravity_change(body, true)


func _on_AntiGravity_body_exited(body):
	_on_AntiGravity_change(body, false)

func _on_AntiGravity_change(body: Node, is_anti: bool):
	if 'move_rule' in body:
		var move_rule = body.move_rule
		var pre_up_y = move_rule.up_dir.y;
		if is_anti:
			move_rule.gravity = -abs(move_rule.gravity)
			move_rule.up_dir.y = abs(move_rule.up_dir.y)
		else:
			move_rule.gravity = abs(move_rule.gravity)
			move_rule.up_dir.y = -abs(move_rule.up_dir.y)
			
		if pre_up_y * move_rule.up_dir.y < 0:
			# 有变化
			on_anti_gravity(move_rule, is_anti)
		
func on_anti_gravity(move_rule: MoveRule, is_anti: bool):
	if is_anti:
		move_rule.body.scale.y = -1
	else:
		move_rule.body.scale.y = 1 
	move_rule.body.move_and_slide(Vector2.ZERO, move_rule.up_dir)
