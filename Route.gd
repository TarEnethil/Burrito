extends Spatial

var texture_path

var color = Color(0.9, 0.1, 0.1)

var point_list := PoolVector3Array()

func create_mesh(point_list: PoolVector3Array):
	self.point_list = point_list
	refresh_mesh()

func refresh_mesh():
	var tmpMesh = Mesh.new()
	var i = 0
	var last_uv: float = 0.0
	for point_index in range(len(point_list)-1):	
		var point:Vector3 = point_list[point_index]
		var next_point:Vector3 = point_list[point_index+1]

		var distance: float = point.distance_to(next_point)
		var normal: Vector3 = (next_point - point).normalized()
		#print(normal)
		var horizontal_tangent:Vector3 = Vector3(normal.z, 0, -normal.x).normalized()

		normal = Vector3(0,0,0)

		var point1: Vector3 = point + normal/2 - horizontal_tangent/2
		var point2: Vector3 = point + normal/2 + horizontal_tangent/2
		var point3: Vector3 = next_point - normal/2 + horizontal_tangent/2
		var point4: Vector3 = next_point - normal/2 - horizontal_tangent/2

		var vertices = PoolVector3Array()
		var UVs = PoolVector2Array()

		vertices.push_back(point1)
		vertices.push_back(point2)
		vertices.push_back(point3)
		vertices.push_back(point4)

		var next_uv = last_uv + distance

		UVs.push_back(Vector2(1,last_uv))
		UVs.push_back(Vector2(0,last_uv))
		UVs.push_back(Vector2(0,next_uv))
		UVs.push_back(Vector2(1,next_uv))

		last_uv = next_uv
		if last_uv > 100:
			last_uv = last_uv-100

		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)

		for v in vertices.size(): 
			st.add_color(color)
			st.add_uv(UVs[v])
			st.add_vertex(vertices[v])
		st.commit(tmpMesh)
	$MeshInstance.mesh = tmpMesh


func update_point_vertical(index, y_value):
	pass

func reverse():
	self.point_list.invert()
	refresh_mesh()

func get_point_count():
	return len(self.point_list)

func get_point_position(index: int):
	return self.point_list[index]

func set_point_position(index: int, position: Vector3):
	self.point_list[index] = position
	refresh_mesh()

func add_point(position: Vector3, index: int = -1):
	if index == -1:
		self.point_list.append(position)
	else:
		self.point_list.insert(index, position)
	refresh_mesh()

func remove_point(index: int):
	self.point_list.remove(index)
	refresh_mesh()


func set_texture(texture):
	$MeshInstance.material_override.set_shader_param("texture_albedo", texture)

