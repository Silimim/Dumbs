extends CharacterBody2D

@export var speed = 100
@export var dir = 1
var v0: Vector2
const g = 9.81
var alpha

var spawnPos: Vector2

func _ready():
	$AnimatedSprite2D.play("firing")
	$AnimatedSprite2D.flip_h = dir == -1
	global_position = spawnPos
	alpha = get_angle_to(get_global_mouse_position())
	rotation = get_global_mouse_position().angle_to_point(spawnPos)
	v0 = Vector2(speed * cos(alpha), -abs(speed) * sin(alpha))
	
func _physics_process(delta):
	position.x += v0.x * dir * delta;
	v0.y -= g * delta * 50;
	
	if dir > 0:
		rotation = v0.angle_to(Vector2(1, 0))
	else:
		rotation = -v0.angle_to(Vector2(1, 0)) 
	
	position.y += -v0.y * delta;
	move_and_slide()
	
func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("flying")
