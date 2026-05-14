extends Node

func try_to_catch(body: Node2D, catch_by: Node2D):
	if 'is_follow' in body:
		if !is_instance_valid(body):
			return false;
		
		set_catch(body, catch_by)
		return true
	return false
		
			
func set_catch(body: Node2D, catch_by: Node2D):
	if body.catch_by != catch_by:
		if body.catch_by:
			body.catch_by.on_release_catch()
		body.catch_by = catch_by
	body.is_follow = true
	
func release_catch(body: Node2D, catch_by: Node2D):
	var body_catch_by = body.catch_by
	if body_catch_by && (!catch_by || body_catch_by == catch_by):
		body.is_follow = false
		body.catch_by = null
		body_catch_by.on_release_catch()
