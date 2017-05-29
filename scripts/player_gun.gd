extends RigidBody2D

var ROTATION_SPEED = 1.0 #скорость поворота пушки
var current_rot = 0.0 #текущий поворот
var degree = 0.0 

func _ready():
	set_fixed_process(true) 
	pass
	
func _fixed_process(delta):	
	if Input.is_action_pressed("ui_page_up"):  #вверх
		degree += ROTATION_SPEED
	if Input.is_action_pressed("ui_page_down"): #вниз
		degree -= ROTATION_SPEED
	rotate(degree,delta)
	pass	
	
func rotate(degree,delta):		
	current_rot = lerp(current_rot, degree, ROTATION_SPEED*delta)	
	set_rot(-deg2rad(current_rot))
	pass


