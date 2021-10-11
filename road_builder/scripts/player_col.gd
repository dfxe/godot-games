extends Node

onready var game_manager_node = find_parent("GameManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func restore_color():
	get_parent().get_child(0).get_child(1).modulate = Color(0,0,0,1)
func error_fx():
	get_parent().get_child(0).get_child(1).modulate = Color(0.3,0,0,0.5)
func _on_Area2D_area_entered(area):
	print(area.get_parent().get_name())
	if ("PlayerRoad" in  area.get_parent().get_name() ):
		#game_manager_node.canPlant=false
		#$Sprite_nc.modulate = Color(0.3,0,0,1)
		
		if not get_parent().get_child(0).is_planted:
			error_fx()
	elif ("CostlyObtacle" in  area.get_parent().get_name()):
		area.queue_free()
func _on_Area2D_area_exited(area):

	if ("PlayerRoad" in  area.get_parent().get_name()):
		#game_manager_node.canPlant=false
		#$Sprite_nc.modulate = Color(0.3,0,0,1)
		print("touchde")
		restore_color()



