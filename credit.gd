extends Control

# Khai báo cái loa để tí bấm nút nó kêu
@onready var sfx_click = $SfxClickCredit

func _ready():
	# Hàm này đảm bảo lúc ông ngồi đọc sớ, nhạc nền vẫn hát rỉ rả
	if not NhacNenToanCuc.playing:
		NhacNenToanCuc.play()

# Đây là cái hàm vừa được nối tín hiệu từ nút bấm
func _on_btn_back_pressed():
	sfx_click.play() # 1. Phát tiếng "tạch"
	
	# 2. Bắt game dừng lại 0.1 giây để tai ông kịp nghe tiếng tạch
	await get_tree().create_timer(0.1).timeout 
	
	# 3. Đá ông về lại màn hình Menu
	get_tree().change_scene_to_file("res://menu.tscn")
