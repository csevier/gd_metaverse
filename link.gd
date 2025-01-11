extends Node
class_name Link, "res://link.svg"

export var link_location = "http://127.0.0.1:5000/"
export var pck  = "test.pck"
export var main_scene = "res://World.tscn"
var thread
var should_download = false

func _ready():
	var args = Array(OS.get_cmdline_args())
	if not args.has("host"):
		thread = Thread.new()
		thread.start(self, "download")
	
func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	else:
		if _response_code == 404:
			print("Link failed to load. Reason...")
			print("Not Found: " + link_location + pck)
		else:
			print("World loaded from: " + link_location + pck)
			print("World written to: " + OS.get_user_data_dir() + "/" + pck)
			
func _http_hash_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Hash Check Failed")
	else:
		if _response_code == 404:
			print("No Hash Present. Reason...")
			print("Not Found: " + link_location + pck)
		else:
			var server_hash = _body.get_string_from_utf8()
			print("Hash Recieved: " + server_hash)
			var pck_hash = hash_file("user://"+pck)
			print("Hash Current: " + pck_hash)
			if pck_hash == server_hash:
				print("Hash Matches skipping download and using local: " + pck)
			else:
				print("Updating local: " + pck)
				should_download = true
	
func download():
	var file = File.new()
	if file.file_exists("user://"+pck):
		print("PCK Exists checking hash")
		var http_hash = HTTPRequest.new()
		add_child(http_hash)
		http_hash.connect("request_completed", self, "_http_hash_request_completed")
		var request = http_hash.request(link_location+pck, ["hash: true"])
		if request != OK:
			push_error("Http request error")
	else:
		print(pck + " not found locally, downloading.")
		should_download = true
	if should_download:
		var http = HTTPRequest.new()
		add_child(http)
		http.connect("request_completed", self, "_http_request_completed")
		http.set_download_file("user://"+pck) 
		var request = http.request(link_location+pck)
		if request != OK:
			push_error("Http request error")

func change_world():
	var success = ProjectSettings.load_resource_pack("user://"+pck)
	
	if success:
		print("changing world to: " + OS.get_user_data_dir() + "/" + pck)
		var imported_scene = load(main_scene)
		get_tree().change_scene_to(imported_scene)

func execute():
	change_world()
	
func _exit_tree():
	thread.wait_to_finish()
	
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

