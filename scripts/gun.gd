extends Node2D

@onready var projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")
@export var SPEED = 100
@export var dir = 1

@rpc("any_peer", "call_local")
func shoot():
	var projectile = projectile_scene.instantiate()
	projectile.name = "Projectile_%s" % str(Time.get_ticks_msec())
	if position.x > 0:
		dir = 1
	else:
		dir = -1
		
	projectile.spawnPos = global_position
	projectile.speed = SPEED * dir
	projectile.dir = dir
	
	get_node("../../").call_deferred("add_child", projectile, true)
