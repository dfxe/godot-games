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

func check_spawn_boundary(obj_pos:Vector2):
	#TODO set better boundary
	return (obj_pos.x<get_viewport_rect().size.x/2 and
	 obj_pos.y<get_viewport_rect().size.y/2 and
	  obj_pos.x > (get_viewport_rect().size.x/2)*(-1) and
	   obj_pos.y > (get_viewport_rect().size.y/2)*(-1) )

func get_last_child_pos()->Vector2:
	var current = self.get_children()
	var next = null
	while current:
		next = current[0]
		current = current[-1].get_children()
		
	return (next.get_global_position())

func has_budget()->bool:
	var has_budget = game_manager_node.has_sufficient_budget(game_manager_node.cost_to_plant)
	if not has_budget:
		game_manager_node.game_over("Cost overrun!")
	return has_budget

func in_boundary()->bool:
	var in_boundary = check_spawn_boundary(get_last_child_pos())
	if not in_boundary:
		game_manager_node.game_over("The road was built outside the planned area.")
	return in_boundary

func get_input():
	
	if Input.is_action_just_pressed("ui_select") && game_manager_node.canPlant:
		if is_planted == false:
			is_planted=true
		
			if has_budget() and in_boundary():
				game_manager_node.update_budget(-game_manager_node.cost_to_plant)
				var nextBrickName = "res://Players_02.tscn"
			
				var scene = load(nextBrickName)
				var player = scene.instance()
				
				#placed particles 
				var fx_placedscene = load("res://FX_placed_mm.tscn")
				var fx_placed = fx_placedscene.instance()
				
				add_child(fx_placed)
				
				add_child(player)
				
				fx_placed.get_child(0).emitting = true
				
				var last = get_last_child_pos()
				game_manager_node.game_text_panel.rect_position = last
				player.position = Vector2($Sprite3.position.x+20,$Sprite3.position.y) #Vector2(get_child(2).position.x+50, get_child(2).position.y)
				fx_placed.position = Vector2($Sprite3.position)#Vector2(get_child(2).position.x-100,get_child(2).position.y)
				
				$Sprite_nc.modulate = Color(1,1,1,1)
				self.set_process_input(false)
			

var rotation_backward = false
func rotation_control(delta):
	if rotation_backward:
		rotation-=rotation_speed*delta
	else:
		rotation+=rotation_speed*delta
	if rotation > 1:
		rotation_backward=true
	elif rotation <= -1: 
		rotation_backward=false
	
		
func _physics_process(delta):
	if not is_planted and game_manager_node.rotation_on:
		rotation_control(delta)
	else: 
		rotation = self.rotation
	get_input()



