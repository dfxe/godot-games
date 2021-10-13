extends Area2D


export (PackedScene) var fx_end_of_life = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _on_Area2D_area_entered(area):
	
	if(area.get_parent().get_name()=="PlayerRoad"):
		
		var fx_placedscene = load(fx_end_of_life.get_path())
		
		
		
		var fx_placed = fx_placedscene.instance()
		
		get_parent().add_child(fx_placed)
		fx_placed.position = self.get_global_position()
		fx_placed.get_child(0).emitting = true
		fx_placed.get_child(0).one_shot = true
		
		
		self.queue_free()
