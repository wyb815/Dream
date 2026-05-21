extends Node2D

func is_player(node: Node2D) -> bool:
	return node.get_groups().has('player')
	
func find_player() -> Player:
	var array =  get_tree().get_nodes_in_group('player')
	
	if array:
		return get_tree().get_nodes_in_group('player')[0] as Player
	return null
	
func can_die(node: Node2D):
	return node.has_method('die')
