extends MeshInstance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.get_active_material(0).set_uv1_offset(self.get_active_material(0).uv1_offset + Vector3(0.01,0.01,0))
	
