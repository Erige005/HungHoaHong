extends Node2D

# 1. Tải sẵn các bản thiết kế
var rose_scene = preload("res://rose.tscn")
var giant_rose_scene = preload("res://hoa_khong_lo.tscn")
var bomb_scene = preload("res://bom.tscn")
var giant_bomb_scene = preload("res://bom_khong_lo.tscn")
var heart_scene = preload("res://tim.tscn")
var floating_text_scene = preload("res://floating_text.tscn")

var lives = 5
var thoi_gian_da_choi = 0 

@onready var lives_label = $UILayer/LivesLabel
@onready var score_label = $UILayer/ScoreLabel
@onready var menu_board = $UILayer/MenuBoard
@onready var menu_title = $UILayer/MenuBoard/VBoxContainer/MenuTitle
@onready var btn_resume = $UILayer/MenuBoard/VBoxContainer/BtnResume
@onready var gio = $Basket 

# --- HỆ THỐNG CÁC LOA ---
@onready var sfx_an_hoa_tim = $SfxAnHoaTim
@onready var sfx_an_bom = $SfxAnBom
@onready var sfx_an_bom_2 = $SfxAnBom2
@onready var sfx_chet = $SfxChet
@onready var sfx_missing = $SfxMissing 
@onready var sfx_click = $SfxClick 
@onready var bgm_ocean = $BgmOcean # <--- LOA SÓNG BIỂN

func _ready():
	Global.reset_score() 
	lives_label.text = "Mạng: " + str(lives)
	score_label.text = "Hoa: " + str(Global.current_score)
	menu_board.hide()
	
	# TẮT NHẠC NỀN MENU KHÔNG LIÊN QUAN
	NhacNenToanCuc.stop()
	
	# BẬT SÓNG BIỂN RÌ RÀO KHI VÀO CHƠI
	bgm_ocean.play()
		
	# ÉP BUỘC LOA CHẾT VÀ CLICK PHẢI KÊU XUYÊN QUA PAUSE
	sfx_chet.process_mode = Node.PROCESS_MODE_ALWAYS
	sfx_click.process_mode = Node.PROCESS_MODE_ALWAYS

func hien_so_nhay(vi_tri, noi_dung, mau_sac):
	var so = floating_text_scene.instantiate()
	add_child(so) 
	so.global_position = vi_tri + Vector2(-20, -50) 
	if so.has_method("setup"):
		so.setup(noi_dung, mau_sac)

# --- THUẬT TOÁN SPAWNER: TĂNG TIẾN SIÊU CHẬM ---
func _on_timer_timeout():
	thoi_gian_da_choi += 1 
	var pool = [] 
	var speed_multiplier = 1.0 
	var so_luong_roi = 1 
	var khoang_cach_an_toan = 200 
	var ti_le_tim = 0.0
	
	if thoi_gian_da_choi < 20:
		pool = [rose_scene]
		speed_multiplier = 0.8 
		so_luong_roi = 1
		ti_le_tim = 3.0
	elif thoi_gian_da_choi < 60:
		pool = [rose_scene, giant_rose_scene, bomb_scene, giant_bomb_scene]
		speed_multiplier = 1.0 
		so_luong_roi = 2 
		ti_le_tim = 7.0
	elif thoi_gian_da_choi < 120:
		pool = [rose_scene, giant_rose_scene, bomb_scene, giant_bomb_scene]
		speed_multiplier = 1.15
		so_luong_roi = 2
		ti_le_tim = 12.0
		if thoi_gian_da_choi % 8 == 0: so_luong_roi = 3
	else:
		# --- GIAI ĐOẠN SAU 2 PHÚT: TĂNG TỪ TỪ ĐẾN VÔ TẬN ---
		pool = [rose_scene, giant_rose_scene, bomb_scene, giant_bomb_scene]
		
		# Tốc độ tăng cực kỳ chậm (0.0015 mỗi giây)
		speed_multiplier = 1.25 + (thoi_gian_da_choi - 120) * 0.0015
		
		# Cứ mỗi 180 giây (3 phút) sau phút thứ 2 mới rớt thêm 1 món đồ
		var bonus_items = int((thoi_gian_da_choi - 120) / 180.0)
		so_luong_roi = 3 + bonus_items
		
		# KHÓA CỨNG số lượng rơi tối đa là 5 món để màn hình không bị kẹt
		if so_luong_roi > 5: 
			so_luong_roi = 5
		
		# Khoảng cách an toàn thu hẹp nhẹ
		khoang_cach_an_toan = 180 - (bonus_items * 10)
		if khoang_cach_an_toan < 100: 
			khoang_cach_an_toan = 100
		
		ti_le_tim = 15.0

	if lives >= 20: ti_le_tim = 0.0

	var cac_toa_do_x_da_tao = [] 

	for i in range(so_luong_roi):
		var random_item
		if randf_range(0, 100) < ti_le_tim:
			random_item = heart_scene
		else:
			random_item = pool.pick_random()
		
		var instance = random_item.instantiate()
		
		if random_item == giant_bomb_scene:
			instance.speed = 320 * speed_multiplier
		else:
			instance.speed = instance.speed * speed_multiplier
		
		var random_x = 0
		var toa_do_hop_le = false
		var so_lan_thu = 0
		while not toa_do_hop_le and so_lan_thu < 25:
			random_x = randf_range(120, 1000)
			toa_do_hop_le = true
			for x_cu in cac_toa_do_x_da_tao:
				if abs(random_x - x_cu) < khoang_cach_an_toan:
					toa_do_hop_le = false
					break
			so_lan_thu += 1
			
		cac_toa_do_x_da_tao.append(random_x) 
		var random_y = -100 - (i * 150) + randf_range(-30, 30) 
		instance.position = Vector2(random_x, random_y)
		add_child(instance)

# --- CÁC HÀM XỬ LÝ GAMEPLAY ---
func cong_diem(so_diem):
	Global.current_score += so_diem
	score_label.text = "Hoa: " + str(Global.current_score)
	sfx_an_hoa_tim.play() 
	if so_diem == 1: hien_so_nhay(gio.global_position, "+1", Color.GREEN)
	elif so_diem == 5: hien_so_nhay(gio.global_position, "+5", Color.GREEN)

func cong_mang():
	if lives < 20:
		lives += 1
		lives_label.text = "Mạng: " + str(lives)
		hien_so_nhay(gio.global_position, "+1 Mạng", Color.RED)
		sfx_an_hoa_tim.play()
	else:
		hien_so_nhay(gio.global_position, "MAX!", Color.YELLOW)

func tru_mang(so_luong = 1):
	hien_so_nhay(gio.global_position, "-" + str(so_luong) + " Mạng", Color.BLACK)
	lives -= so_luong
	if lives < 0: lives = 0 
	lives_label.text = "Mạng: " + str(lives)
	
	if so_luong > 1:
		sfx_an_bom_2.play() 
	else:
		sfx_an_bom.play() 
		
	if lives <= 0: ket_thuc_game()

func tru_mang_khong_hieu_ung(so_luong):
	lives -= so_luong
	if lives < 0: lives = 0
	lives_label.text = "Mạng: " + str(lives)
	sfx_missing.play()
	if lives <= 0: ket_thuc_game()

func ket_thuc_game():
	bgm_ocean.stop() # Tắt luôn tiếng sóng biển khi Game Over
	NhacNenToanCuc.stop()
	sfx_chet.play()
	if Global.current_score > Global.high_score:
		Global.high_score = Global.current_score
	Global.total_roses_owned += Global.current_score 
	Global.save_data()
	get_tree().paused = true 
	menu_title.text = "GAME OVER!\nĐIỂM: " + str(Global.current_score) + "\nKỶ LỤC: " + str(Global.high_score)
	btn_resume.hide()
	menu_board.show()

# --- HỆ THỐNG NÚT BẤM ---
func _on_btn_pause_pressed():
	sfx_click.play()
	get_tree().paused = true
	menu_title.text = "TẠM DỪNG"
	btn_resume.show() 
	menu_board.show()

func _on_btn_resume_pressed():
	sfx_click.play()
	menu_board.hide()
	get_tree().paused = false 

func _on_btn_restart_pressed():
	sfx_click.play()
	get_tree().paused = false 
	get_tree().reload_current_scene() 

func _on_btn_quit_pressed():
	sfx_click.play()
	get_tree().paused = false
	if not NhacNenToanCuc.playing:
		NhacNenToanCuc.play()
	get_tree().change_scene_to_file("res://menu.tscn")
