extends HttpFileRouter
class_name LinkRouter
	
var pck_hashes = null
func _init(path: String, md5_hashes: Dictionary).(path):
	pck_hashes = md5_hashes
	
# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse):
	print("HELLLLLLLO")
	if request.headers.has("hash"):
		print("sending: " + pck_hashes[request.path])
		response.send(200,  pck_hashes[request.path])
	else:
		print("NOT SENDING")
		.handle_get(request, response)

