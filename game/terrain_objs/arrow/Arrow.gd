extends Area2D


func _ready():
	pass # Replace with function body.


func _on_arrow_body_entered(body: Node2D):
	if body.get_groups().has('player'):
		body.global_position = body.born_pos
