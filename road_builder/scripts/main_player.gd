extends KinematicBody2D


onready var game_manager_node = find_parent("GameManager")
export (int) var rotation_speed = 5
var is_planted = false
var velocity = Vector2() 
var rand_num = RandomNumberGenerator.new()
var nextrand_num = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	rand_num.randomize()
	nextrand_num=rand_num.randi_range (1,3)
	game_manager_node.present_next_brick(nextrand_num)
	print("Brick created") # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_input():
	
	if Input.is_action_just_pressed("ui_select") && game_manager_node.canPlant:
		if is_planted == false:
			#print("stahp")
			is_planted=true
			#print(get_tree().get_node("GameManager").asphalt_left)
			#print(gameManager.name)
			
			if game_manager_node.asphalt_left >= 10:
				#cam shaker
				game_manager_node.main_camera.start_shaker()
				
				game_manager_node.asphalt_left -= 10
				game_manager_node.get_node("GameText").text = "Asphalt: "+str(game_manager_node.asphalt_left)
				
				
				var nextBrickName = "res://Players_02.tscn"
				print(nextBrickName)
				var scene = load(nextBrickName)
				var player = scene.instance()
				
				#placed particles 
				var fx_placedscene = load("res://FX_placed_mm.tscn")
				var fx_placed = fx_placedscene.instance()
				
				add_child(player)
				add_child(fx_placed)
				fx_placed.get_child(0).emitting = true
				if (get_child(1).transform.get_scale().x) < 0.3:
					player.position = Vector2(get_child(2).position.x, get_child(2).position.y)
				else:
					player.position = Vector2(get_child(2).position.x+50, get_child(2).position.y)
				fx_placed.position = Vector2(get_child(2).position.x-100,get_child(2).position.y)
				
				
				$Sprite_nc.modulate = Color(1,1,1,1)
			else:
				game_manager_node.canPlant=false
			#print(find_parent("GameManager"))
			#get_tree().get_root().get_node("GameManager").game_manager.asphalt_left-=10
			

	#position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
		
		
func _physics_process(delta):
		
	if not is_planted:
		rotation += rotation_speed*delta
	else: 
		rotation = self.rotation
	get_input()



