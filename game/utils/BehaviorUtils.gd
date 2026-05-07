extends Node2D

func is_player(node: Node2D):
	return node.get_groups().has('player');
