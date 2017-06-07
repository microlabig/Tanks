extends RigidBody2D

var input_states = preload("res://scripts/input_states.gd")
 
var move_left = input_states.new("ui_left")
var move_right = input_states.new("ui_right")
var move_up = input_states.new("ui_up")
var move_down = input_states.new("ui_down")       
 
export var run_speed = 100
export var acceleration = 1
export var deceleration = 2
export var rot_degree = 1

export (PackedScene) var bullet #сцена пули
var bullet_mg = preload("res://scenes/player_bullet_mg.tscn") #сцена пули минигана

onready var bullet_container = get_node("bullet_container")
onready var gun_timer = get_node("gun_timer")

onready var mg_container = get_node("mg_container")
onready var machinegun_timer = get_node("machinegun_timer")

#onready var shoot_sound = get_node("shoot")
var smoke = preload("res://scenes/smoke.tscn")

#следы от движения
var tracks = preload("res://scenes/track.tscn")
onready var tracks_timer = get_node("tracks_timer")
var track_offset = 0

var current_speed = 0
var current_rot = 0.0
var rot = 0.0
 
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------
func _ready():        
	set_fixed_process(true)
	pass


func _fixed_process( delta ):
	if Input.is_action_pressed("ui_shoot"):
		if gun_timer.get_time_left() == 0:
			shoot()
	
	if Input.is_action_pressed("ui_shoot_machinegun"):
		if machinegun_timer.get_time_left() == 0:
			shoot_mashinegun()

	# поворот танка
	if move_left.check() == 1 or move_right.check() == 1:
		rot = get_rot()
		current_rot = get_rot()
	if move_left.check() == 2:
		rotate_player(rot_degree,delta)
	elif move_right.check() == 2:
		rotate_player(-rot_degree,delta)
       
    # движение танка    
	if move_up.check() == 2:
		move(-run_speed,acceleration,delta)
		
	elif move_down.check() == 2:
		move(run_speed*0.5,acceleration,delta)
		
	elif move_up.check() == 0 and move_down.check() == 0:
		move(0,deceleration,delta)
	
	if Input.is_action_pressed("ui_up") or abs(current_speed)>1.0 or abs(current_rot)>0.5:
		if tracks_timer.get_time_left() == 0:
			tracks_timer.start()
	
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))		
	pass
#--------------------------------------------------
#--------------------------------------------------
#--------------------------------------------------   

#передвижение
func move(speed, acceleration, delta):		
	current_speed = lerp(current_speed, speed, acceleration*delta)	
	pass

#стрельба из пушки
func shoot():
	# старт таймера стрельбы
	gun_timer.start()
	# добавляем в контейнер пулю
	var b = bullet.instance()
	var pos = get_node("gun/muzzle").get_global_pos()
	var rot = get_node("gun/muzzle").get_global_rot()
	bullet_container.add_child(b)
	b.start_at(rot, pos)
	# добавляем эффект дыма после выстрела
	var sm = smoke.instance()
	bullet_container.add_child(sm)
	sm.set_pos(pos)
	sm.play()
	# отдача от стрельбы и установка скорости
	var impulse = -Vector2((get_node("gun/muzzle").get_global_pos()-get_global_pos())).rotated(-get_rot())		
	var ang = get_node("gun").current_rot 
	impulse *= cos(ang)
	current_speed += impulse.y*cos(ang)	
	apply_impulse(Vector2(0,0),impulse)	
	set_linear_velocity(Vector2(0,current_speed).rotated(get_rot()))	
#	shoot_sound.play("gun")
	pass

# стрельба из пулемета
func shoot_mashinegun():
	# старт таймера стрельбы
	machinegun_timer.start()
	# добавляем в контейнер пулю	
	var b = []		
	for j in range(2):	
		b.append(bullet_mg.instance())		
	var pos = [get_node("machine_gun_l/muzzle").get_global_pos(),get_node("machine_gun_r/muzzle").get_global_pos()]
	var rot = [get_node("machine_gun_l/muzzle").get_global_rot(),get_node("machine_gun_l/muzzle").get_global_rot()]
	var j = 0
	for i in b:
		mg_container.add_child(i)
		i.start_at(rot[j], pos[j])
		j += 1	
#	shoot_sound.play("gun")
	pass
	
#поворот игрока
func rotate_player(degree,delta):
	current_rot += deg2rad(degree)
	rot = lerp(rot,current_rot,delta)
	set_rot(rot)

#для следов от движения танка
func _on_tracks_timer_timeout():
	var track = tracks.instance()
	get_node("tracks_container").add_child(track)	
	tracks_timer.set_wait_time(0.25-abs(current_speed/run_speed)/10)	
	track.set_offset()
	track.start_at(get_rot(), get_pos()	)
	pass 
