extends Node

var current_score = 0 
var total_roses_owned = 0 
var unlock_level = 0 # MỚI: Biến lưu mốc thành tựu (từ 0 đến 4)
var high_score = 0 # MỚI: Biến lưu kỷ lục cao nhất

# Godot dùng "user://" để trỏ đến thư mục AppData an toàn trên Windows
var save_path = "user://savegame.cfg" 

func _ready():
	# Ngay khi game vừa bật lên, tự động đọc file save trên ổ cứng
	load_data()

func reset_score():
	current_score = 0

# Hàm GHI dữ liệu ra ổ cứng
func save_data():
	var config = ConfigFile.new()
	# Lưu cấu trúc giống file .ini: [Player] -> ...
	config.set_value("Player", "total_roses", total_roses_owned)
	config.set_value("Player", "unlock_level", unlock_level) 
	config.set_value("Player", "high_score", high_score) # Lưu kỷ lục
	config.save(save_path)

# Hàm ĐỌC dữ liệu từ ổ cứng
func load_data():
	var config = ConfigFile.new()
	# Kiểm tra xem file save có tồn tại không
	var err = config.load(save_path)
	if err == OK:
		# Lấy giá trị ra, nếu không tìm thấy thì gán mặc định là 0
		total_roses_owned = config.get_value("Player", "total_roses", 0)
		unlock_level = config.get_value("Player", "unlock_level", 0) 
		high_score = config.get_value("Player", "high_score", 0) # Đọc lại kỷ lục
