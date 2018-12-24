extends MarginContainer

var globals
var gameScene

func _ready():
	self.globals = get_node("/root/globals")
	self.gameScene = load("res://Scene/Game.tscn").instance()
	pass
	
func __create_button__():
	get_tree().get_root().add_child(gameScene)
	self.gameScene.__generate_world__()
	get_tree().get_root().get_node("Lobby").hide()
	
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(globals.GAME_PORT, globals.MAX_PLAYERS)
	if(err != OK):
		#is another server running?
		_set_status("Can't host, address in use.",false)
		return
	
	get_tree().set_network_peer(peer)
	pass
	
func __connect_button__():
	get_tree().get_root().add_child(gameScene)
	var ip = get_node("VBoxContainer/HBoxContainer2/IpAdressLineEdit").get_text()
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid", false)
		return
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, globals.GAME_PORT)
	get_tree().set_network_peer(host)
	get_tree().get_root().get_node("Lobby").hide()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass