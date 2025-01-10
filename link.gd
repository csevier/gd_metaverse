extends Node
class_name Link, "res://link.svg"

export var link_location = "http://127.0.0.1:5000/"
export var pck  = "test.pck"
export var main_scene = "res://World.tscn"
var thread

func _ready():
	var args = Array(OS.get_cmdline_args())
	if not args.has("host"):
		thread = Thread.new()
		thread.start(self, "download")
	
func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	else:
		print("World loaded from: " + link_location + pck)
		print("World written to: " + OS.get_user_data_dir() + "/" + pck)
	
func download():
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_http_request_completed")
	http.set_download_file("user://"+pck) 
	var request = http.request(link_location+pck)
	if request != OK:
		push_error("Http request error")

func change_world():
	var success = ProjectSettings.load_resource_pack("user://"+pck)
	print("changing world to: " + pck)
	if success:
		var imported_scene = load(main_scene)
		get_tree().change_scene_to(imported_scene)

func execute():
	change_world()
	
func _exit_tree():
	thread.wait_to_finish()

