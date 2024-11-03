extends CharacterBody2D

@export var speed = 150
@export var gravity = 20
@export var jump_force = 400
@export var radius = 45
var gun: Node2D

@export var player_id := 1:
	set(id):
		player_id = id
		
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	set_label()
	
func _ready():
	gun = $Gun
	gun.get_node("Sprite2D").flip_h = true

func set_label():
	get_node("UI/Label").text = name

func _process(delta):
	if not is_multiplayer_authority():
		return
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_transform.origin 
	var distance = player_pos.distance_to(mouse_pos) 
	var mouse_dir = (mouse_pos - player_pos).normalized()
	if distance > radius:
		mouse_pos = player_pos + (mouse_dir * radius)
	gun.rotation = mouse_pos.angle_to_point(player_pos)
	
	if gun.position.x < 0:
		gun.get_node("Sprite2D").flip_v = false
	else:
		gun.get_node("Sprite2D").flip_v = true
	gun.global_transform.origin = mouse_pos

func _physics_process(_delta):
	
	if not is_multiplayer_authority():
		return
		
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 500:
			velocity.y = 300
			
	if is_on_floor() || is_on_wall():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
	
	var horizhontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = horizhontal_direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot"):
		gun.rpc("shoot")
