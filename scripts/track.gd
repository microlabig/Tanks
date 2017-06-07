extends Node2D

func _ready():
	set_process(true)	
	pass

func _process(delta):	
	pass
	
func start_at(dir, pos):
	set_rot(dir)
	set_pos(pos)	
	pass

# установить смещение текстуры
func set_offset():
	var off1 = get_node("sprite1").get_offset()
	var off2 = get_node("sprite2").get_offset()
	off1.y += 30
	off2.y -= 40
	get_node("sprite1").set_offset(off1)
	get_node("sprite2").set_offset(off2)
	pass

func _on_lifetime_timeout():
	queue_free()
	pass # replace with function body


func _on_Timer_timeout():	
	pass # replace with function body
