extends Node

#onready var mainPlayerNode = get_node("PlayerObj/PlayerKB2D").canPlant
var asphalt_left = 10
var asphalt_message = "Asphalt: "
var canPlant = true
var score = 0

var nextBrickSprite = [("res://images/pixil-frame-0 (1).png"),"res://images/pixil-frame-2.png",("res://images/pixil-frame-0.png")]
onready var nextBrickTexture = null

onready var main_camera = find_node("Camera2D")
onready var game_text_panel = find_node("GameTextPanel")
onready var game_text = find_node("GameTextPanel").get_child(0)

onready var rotation_on = true

onready var cost_to_plant = 1
func update_budget(delta):
	main_camera.start_shaker()
	asphalt_left += delta
	game_text.text = "Asphalt: "+str(asphalt_left)
func has_sufficient_budget(delta):
	return asphalt_left-delta >= 0
func present_next_brick(brickNum):
	if nextBrickTexture == null:
		nextBrickTexture = find_node("NextBrickTexture")
	nextBrickTexture.texture = load(nextBrickSprite[brickNum-1])

func point_obj_form(isRandom:bool,whatObj:String,coordX:float,coordY:float):
	var target_point_scene = null
	var target_point_obj = null
	if whatObj == "target":
		target_point_scene = load("res://Target_Point_01.tscn")
		target_point_obj = target_point_scene.instance()
	elif whatObj == "house_obstacle":
		target_point_scene = load("res://Costly_Obstacle_01.tscn")
		target_point_obj = target_point_scene.instance()
	elif whatObj == "bonus_asphalt":
		target_point_scene = load("res://Bonus_Asphalt_01.tscn")
		target_point_obj = target_point_scene.instance()
	elif whatObj == "river":
		pass
	if isRandom == true:
		var rand_p = RandomNumberGenerator.new()
		rand_p.randomize()
		var x_pos = rand_p.randf_range(-100,250)
		rand_p.randomize()
		var y_pos = rand_p.randf_range(-100,250)
		target_point_obj.position.x = x_pos
		target_point_obj.position.y = y_pos
		
	else:
		#Need a level layout, a sensible one 
		pass
	add_child(target_point_obj)	
		
func generate_target_points(how_many_points):
	for _i in range(1,how_many_points):
		#point_obj_form(true,"target",0,0)
		point_obj_form(true,"house_obstacle",0,0)
		point_obj_form(true,"bonus_asphalt",0,0)
		
func start_level_timer():
	var main_timer = find_node("LevelTimer")

	
# Called when the node enters the scene tree for the first time.
func start():
	asphalt_left = 10
	score = 0
	game_text.text = asphalt_message+str(asphalt_left)
	game_text_panel.rect_position = $PlayerRoad.get_global_position()
	generate_target_points(4)
	start_level_timer()

func _ready():
	start() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()
func pressed_reload():
	get_tree().reload_current_scene()
func game_over(message):
	canPlant=false
	rotation_on = false

	main_camera.start_rotate()

	find_node("GameOverBlur").visible=true
	find_node("GameOverReason").text = message
	find_node("GameOverPanel").visible=true
	find_node("BackToMenuBtn").visible=false
	

	print("GAME OVER")


func _on_BackToMenuBtn_pressed():
	pressed_reload()


func _on_EndRestart_pressed():
	pressed_reload() 
