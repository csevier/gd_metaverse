extends Node
class_name Link, "res://link.svg"

export var link_location = "http://127.0.0.1:5000/"
export var pck  = "test.pck"
export var main_scene = "res://World.tscn"

func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	var success = ProjectSettings.load_resource_pack("res://"+pck)
	if success:
		
		var imported_scene = load(main_scene)
		get_tree().change_scene_to(imported_scene)

func download(link, path):
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "_http_request_completed")
	http.set_download_file(path)
	var request = http.request(link)
	if request != OK:
		push_error("Http request error")

func execute():
	download(link_location+pck+"/", pck)

