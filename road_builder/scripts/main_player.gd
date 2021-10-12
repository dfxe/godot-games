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
		print(current)
	return (next.get_global_position())

func get_last_child_2():
	return find_node(self.get_parent().name+str(game_manager_node.countr))
	
func get_input():
	
	if Input.is_action_just_pressed("ui_select") && game_manager_node.canPlant:
		if is_planted == false:
			is_planted=true
			
			if game_manager_node.update_budget() and check_spawn_boundary(get_last_child_pos()):
				
				var nextBrickName = "res://Players_02.tscn"
			
				var scene = load(nextBrickName)
				var player = scene.instance()
				
				#placed particles 
				var fx_placedscene = load("res://FX_placed_mm.tscn")
				var fx_placed = fx_placedscene.instance()
				
				add_child(fx_placed)
				
				add_child(player)
				
				fx_placed.get_child(0).emitting = true
				#TODO UI follows main road and 
				#TODO when outside the viewport, destroy 
				#Fix: get_global_position()
				var last = get_last_child_pos()
				game_manager_node.game_text_panel.rect_position = Vector2(last)
				player.position = Vector2(get_child(2).position.x+50, get_child(2).position.y)
				fx_placed.position = Vector2(get_child(2).position.x-100,get_child(2).position.y)
				
				$Sprite_nc.modulate = Color(1,1,1,1)
				self.set_process_input(false)
			else:
				game_manager_node.game_over()

var rotation_backward = false
func rotation_control(delta):
	if rotation_backward:
		rotation-=rotation_speed*delta
	else:
		rotation+=rotation_speed*delta
	if rotation > 2:
		rotation_backward=true
	elif rotation <= -2: 
		rotation_backward=false
	
		
func _physics_process(delta):
	if not is_planted:
		rotation_control(delta)
	else: 
		rotation = self.rotation
	get_input()



