extends HTTPRequest

signal response_received(msg:Dictionary)

const LATEST_RELEASE_URL = "https://api.github.com/repos/Ark2000/PankuConsole/releases/latest"

const REQUEST_RESULT = {
	RESULT_SUCCESS: "SUCCESS",
	RESULT_CHUNKED_BODY_SIZE_MISMATCH: "CHUNKED_BODY_SIZE_MISMATCH",
	RESULT_CANT_CONNECT: "CANT_CONNECT",
	RESULT_CANT_RESOLVE: "CANT_RESOLVE",
	RESULT_CONNECTION_ERROR: "CONNECTION_ERROR",
	RESULT_TLS_HANDSHAKE_ERROR: "TLS_HANDSHAKE_ERROR",
	RESULT_NO_RESPONSE: "NO_RESPONSE",
	RESULT_BODY_SIZE_LIMIT_EXCEEDED: "BODY_SIZE_LIMIT_EXCEEDED",
	RESULT_BODY_DECOMPRESS_FAILED: "BODY_DECOMPRESS_FAILED",
	RESULT_REQUEST_FAILED: "REQUEST_FAILED",
	RESULT_DOWNLOAD_FILE_CANT_OPEN: "DOWNLOAD_FILE_CANT_OPEN",
	RESULT_DOWNLOAD_FILE_WRITE_ERROR: "DOWNLOAD_FILE_WRITE_ERROR",
	RESULT_REDIRECT_LIMIT_REACHED: "REDIRECT_LIMIT_REACHED",
	RESULT_TIMEOUT: "TIMEOUT"
}

static func dget(dict:Dictionary, key, default_value=""):
	return default_value if !dict.has(key) else dict[key]

var is_busy := false

func _ready():
	request_completed.connect(_on_request_completed)

func check_latest_release():
	if is_busy: return
	is_busy = true
	var error = request(LATEST_RELEASE_URL)
	if error != OK:
		is_busy = false
		response_received.emit({
			"success": false,
			"msg": "An error occurred in the HTTP request."
		})

func _on_request_completed(result:int, response_code:int, headers:PackedStringArray, body:PackedByteArray):
	is_busy = false
	if result != RESULT_SUCCESS:
		response_received.emit({
			"success": false,
			"msg": REQUEST_RESULT[result]
		})
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response:Dictionary = json.get_data()
	response_received.emit({
		"success": true,
		"published_at": dget(response, "published_at", "???"),
		"name": dget(response, "name", "???"),
		"html_url": dget(response, "html_url", "???")
	})
