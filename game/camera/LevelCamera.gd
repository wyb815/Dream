extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var group := get_tree().get_nodes_in_group('player')
	
	if group.size() > 0:
		var player = group[0]
		global_position = lerp(global_position, player.global_position,delta * 2)
