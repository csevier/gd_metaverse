extends Node

var routes = []
func _ready() -> void:
	var args = Array(OS.get_cmdline_args())
	if args.has("host"):
		print("starting server...")
		var server = HttpServer.new()
		fill_route_names()
		var hashes = {}
		for route in routes:
			print("register route: " + route)
			print("Hashing: " + route)
			var pck_hash = hash_file("res://host/"+route)
			print("MD5 Hash is: " + pck_hash)
			hashes["/"+route] = pck_hash
		server.register_router("*", LinkRouter.new("res://host",hashes))
		add_child(server)
		server.start()
	else:
		print("Not starting server...")
	
func fill_route_names():
	var dir = Directory.new()
	if dir.open("res://host") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				print("Found file: " + file_name)
				routes.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
const CHUNK_SIZE = 1024

func hash_file(path):
	var ctx = HashingContext.new()
	var file = File.new()
	# Start a SHA-256 context.
	ctx.start(HashingContext.HASH_MD5)
	# Check that file exists.
	if not file.file_exists(path):
		return
	# Open the file to hash.
	file.open(path, File.READ)
	# Update the context after reading each chunk.
	while not file.eof_reached():
		ctx.update(file.get_buffer(CHUNK_SIZE))
	# Get the computed hash.
	var res = ctx.finish()
	# Print the result as hex string and array.
	return res.hex_encode()

