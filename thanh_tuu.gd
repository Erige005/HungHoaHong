extends Control

# Cấu hình 4 mốc: Giá tiền và Đường dẫn ảnh
var costs = [500, 1500, 3000, 99999]
var rewards = [
	"res://anh1.jpg", 
	"res://anh2.jpg", 
	"res://anh3.png", 
	"res://anh4.png"
]

var selecting_level = -1 # Biến tạm để nhớ người chơi đang bấm mốc nào

@onready var confirm_dialog = $HopThoaiXacNhan
@onready var reward_popup = $PopupPhanThuong
@onready var reward_img = $PopupPhanThuong/ImgThuong
# Khai báo loa âm thanh
@onready var sfx_click = $SfxClickAchieve

func _ready():
	# Ẩn hết các bảng khi vừa vào
	confirm_dialog.hide()
	reward_popup.hide()
	
	# Đảm bảo loa click kêu được kể cả khi pause
	sfx_click.process_mode = Node.PROCESS_MODE_ALWAYS

# Hàm dùng chung khi bấm vào các mốc 1, 2, 3, 4
func open_confirm(level: int):
	sfx_click.play() # Phát tiếng khi bấm vào mốc
	
	# 1. Nếu mốc này ĐÃ MỞ RỒI
	if level < Global.unlock_level:
		show_reward(level)
		return

	# 2. Nếu mốc này CHƯA ĐẾN LƯỢT
	if level > Global.unlock_level:
		confirm_dialog.title = "Chưa thể mở"
		confirm_dialog.dialog_text = "Bạn phải mở mốc " + str(Global.unlock_level + 1) + " trước đã!"
		confirm_dialog.get_ok_button().hide() 
		confirm_dialog.popup_centered()
		return

	# 3. Nếu ĐÚNG THỨ TỰ và CHƯA MỞ
	selecting_level = level
	confirm_dialog.title = "Xác nhận mở khóa"
	confirm_dialog.dialog_text = "Bạn có muốn dùng " + str(costs[level]) + " hoa để mở mốc " + str(level + 1) + "?"
	confirm_dialog.get_ok_button().show() 
	confirm_dialog.popup_centered()

# Hàm hiện ảnh phần thưởng
func show_reward(level: int):
	reward_img.texture = load(rewards[level])
	reward_popup.show()

# --- KẾT NỐI TÍN HIỆU NÚT BẤM ---

func _on_btn_moc_1_pressed(): open_confirm(0)
func _on_btn_moc_2_pressed(): open_confirm(1)
func _on_btn_moc_3_pressed(): open_confirm(2)
func _on_btn_moc_4_pressed(): open_confirm(3)

func _on_hop_thoai_xac_nhan_confirmed():
	sfx_click.play() # Tiếng click khi xác nhận mua
	var cost = costs[selecting_level]
	if Global.total_roses_owned >= cost:
		Global.total_roses_owned -= cost
		Global.unlock_level += 1
		Global.save_data()
		show_reward(selecting_level)
	else:
		# Có thể phát thêm tiếng "tịt tịt" báo lỗi ở đây nếu bạn có file mp3 khác
		print("Đéo đủ hoa!") 

func _on_btn_dong_pressed():
	sfx_click.play()
	reward_popup.hide()

func _on_btn_quay_lai_pressed():
	sfx_click.play()
	# Chờ một chút cho tiếng kêu kịp phát rồi mới quay lại Menu
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://menu.tscn")
