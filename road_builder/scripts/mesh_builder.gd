extends Node2D
var planted = false
var child_count = 0
func _ready():
	pass
func get_input():
	if Input.is_action_just_pressed("ui_select"):
		
			#planted=true
			
		var nextRandNum = 0
		var nextBrickName = "res://mesh_"+str(nextRandNum)+".tscn"
		
		var scene = load(nextBrickName)
		var player = scene.instance()
		
		add_child(player)
		#add_child(placedFX)
		
		player.position = Vector2(get_child(0).position.x+50, get_child(0).position.y)
		child_count+=1
		
			#placedFX.position = Vector2(get_child(1).position.x-100,get_child(1).position.y)
		

func _physics_process(delta):
	get_input()
