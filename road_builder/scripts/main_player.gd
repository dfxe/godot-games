extends KinematicBody2D


onready var gameManagerNode = find_parent("GameManager")
export (int) var rotSpeed = 5
var planted = false
var velocity = Vector2() 
var randNum = RandomNumberGenerator.new()
var nextRandNum = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	randNum.randomize()
	nextRandNum=randNum.randi_range (1,3)
	gameManagerNode.present_next_brick(nextRandNum)
	print("Brick created") # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_input():
	
	if Input.is_action_just_pressed("ui_select") && gameManagerNode.canPlant:
		if planted == false:
			#print("stahp")
			planted=true
			#print(get_tree().get_node("GameManager").asphalt_left)
			#print(gameManager.name)
			
			if gameManagerNode.asphalt_left >= 10:
				#cam shaker
				gameManagerNode.main_camera.start_shaker()
				
				gameManagerNode.asphalt_left -= 10
				gameManagerNode.get_node("GameText").text = "Asphalt: "+str(gameManagerNode.asphalt_left)
				
				
				var nextBrickName = "res://Players_01.tscn"
				print(nextBrickName)
				var scene = load(nextBrickName)
				var player = scene.instance()
				
				#placed particles 
				var placedFXscene = load("res://FX_placed_mm.tscn")
				var placedFX = placedFXscene.instance()
				
				
				
				
				add_child(player)
				add_child(placedFX)
				if (get_child(1).transform.get_scale().x) < 0.3:
					player.position = Vector2(get_child(2).position.x, get_child(2).position.y)
				else:
					player.position = Vector2(get_child(2).position.x+50, get_child(2).position.y)
				placedFX.position = Vector2(get_child(2).position.x-100,get_child(2).position.y)
			else:
				gameManagerNode.canPlant=false
			#print(find_parent("GameManager"))
			#get_tree().get_root().get_node("GameManager").game_manager.asphalt_left-=10
			

	#position += velocity * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
		
		
func _physics_process(delta):
	
			
	if planted == false:
		rotation += rotSpeed*delta
		
	else: 
		rotation = self.rotation
	
	
	get_input()
	
	"""if planted == true:
		var coll = move_and_collide(velocity*delta)
		if coll:
			
			coll.collider.free()
			$CollisionShape2D.queue_free()
			"""
			
	
			
		

	#print(get_child(2).position.x)
	
		#velocity = move_and_slide(velocity)
	
	




