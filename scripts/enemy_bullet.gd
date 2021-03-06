extends Area2D

var vel = Vector2()
export var speed = 500

func _ready():
	set_fixed_process(true)
	pass

func start_at(dir, pos):
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir + PI/2)
	pass
	
func _fixed_process(delta):
	set_pos(get_pos() + vel * delta)
	pass

func _on_lifetime_timeout():
	queue_free()
	pass
