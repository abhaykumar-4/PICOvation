pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
local report_menu_flag = false
local arrow_index = 1
local active_page = 0
local cam = 0
local clock = 0
local last_time = 0
local count_of_active_anomaly = 0
local count_of_catch_anomaly = 0
local event_time = 0
local rnd_value = 0
local index = 0
local is_pending = false
local pending_time = 0
local target_typ
local target_cam
local fixing_screen = false
local fixing_time = 0
local wrong_anomaly = false
local wrong_time = 0
local game_over = false
local first = true
local init_screen = true
local first_monster = true

local anomalies = {

	--1 crack in the wall disappereance
 {typ = 2, cam = 0, act = false},
 
 --2 lights off
 {typ = 1, cam = 0, act = false},
 
 --3 distortion
 {typ = 4, cam = 0, act = false},
 
 --4 extra iron on the board
 {typ = 3, cam = 0, act = false},
 
 --5 monster behind the shelf
 {typ = 5, cam = 0, act = false},
 
 --6 skull on the shelf
 {typ = 3, cam = 0, act = false},
 
 --7 spider
 {typ = 5, cam = 0, act = false},
 
 --8 shelf door opening
 {typ = 6, cam = 0, act = false},
 
 --9 flower pot color change
 {typ = 7, cam = 0, act = false},
 
 --10 picture
 {typ = 7, cam = 0, act = false},
 
 --11 light color change
 {typ = 7, cam = 0, act = false},
 
 --12 book disappearence
 {typ = 2, cam = 0, act = false},
 
 --13 lights off
 {typ = 1, cam = 1, act = false},
 
 --14 distortion
 {typ = 4, cam = 1, act = false},
 
 --15 chair dissappearence
 {typ = 2, cam = 1, act = false},
 
 --16 extra fork on the table
 {typ = 3, cam = 1, act = false},
 
 --17 monster in chair
 {typ = 5, cam = 1, act = false},
 
 --18 handles change
 {typ = 6, cam = 1, act = false},
 
 --19 cold water color
 {typ = 7, cam = 1, act = false},
 
 --20 picture
 {typ = 7, cam = 1, act = false},
 
 --21 blooded knife
 {typ = 8, cam = 1, act = false}, 
 
 --22 shampoo disappearence
 {typ = 2, cam = 2, act = false},
 
 --23 extra shampoo
 {typ = 3, cam = 2, act = false},
 
 --24 camera failure
 {typ = 4, cam = 2, act = false},
 
 --25 monster in bath
 {typ = 5, cam = 2, act = false},
 
 --26 cabinet door open
 {typ = 6, cam = 2, act = false},
 
 --27 monster in the mirror
 {typ = 5, cam = 2, act = false},
 
 --28 monster in vent
 {typ = 5, cam = 2, act = false},
 
 --29 blood in sink
 {typ = 8, cam = 2, act = false},
 
 --30 help
 {typ = 8, cam = 2, act = false},
 
 --31 extra teethbrush
 {typ = 3, cam = 2, act = false},
 
 --32 shampoo color change
 {typ = 7, cam = 2, act = false},
 
 --33 clock
 {typ = 8, cam = 1, act = false},
 
 --34 apocalypse picture on kitchen
 {typ = 7, cam = 1, act = false},
 
 --35 phone
 {typ = 8, cam = 1, act = false},
 
 --36 rainbow
 {typ = 7, cam = 0, act = false},
 
 --37 alien
 {typ = 3, cam = 0, act = false},
 
 --38 pig
 {typ = 8, cam = 0, act = false},
 
 --39 extra shampoo
 {typ = 3, cam = 2, act = false},
 
 --40 towel
 {typ = 7, cam = 2, act = false},
  
 --41 fork disappearence
 {typ = 2, cam = 1, act = false},
 
 --42 gas
 {typ = 3, cam = 1, act = false},
 
 --43 teapot disappearence
 {typ = 2, cam = 1, act = false},
 
 --44 pillow disappearence
 {typ = 2, cam = 0, act = false},
 
 --45 blood in bath
 {typ = 8, cam = 2, act = false},
 
 --46 cat
 {typ = 3, cam = 1, act = false},
 
 --47 carpet change color
 {typ = 7, cam = 0, act = false},
 
 --48 carpet movement
 {typ = 8, cam = 0, act = false},
 
 --49 oven door opening
 {typ = 6, cam = 1, act = false},
 
 --50 fridge door opening
 {typ = 6, cam = 1, act = false},
 
 --51 sticker star disapp
 {typ = 2, cam = 1, act = false},
 
 --52 sticker heart color change
 {typ = 7, cam = 1, act = false},
 
 --53 car falling
 {typ = 8, cam = 0, act = false},
 
 --54 carpet in bathroom disapp
 {typ = 2, cam = 2, act = false},
 
 --55 ironing board legs
 {typ = 3, cam = 0, act = false},
 
 --56 lights off
 {typ = 1, cam = 2, act = false},
 
 --57 distortion
 {typ = 4, cam = 2, act = false},
 
 --58 picture disap
 {typ = 2, cam = 0, act = false},
 
 --59 distortion
 {typ = 4, cam = 1, act = false},
 
 --60 clock distortion
 {typ = 4, cam = 1, act = false},
 
 --61 door handle changing
 {typ = 6, cam = 0, act = false},
 
 --62 big door
 {typ = 6, cam = 1, act = false},
 
 --63 knife disap
 {typ = 2, cam = 1, act = false}
}

function _init()
	cls()
	palt(0, false)
	music(0)
end


function _draw()

	if init_screen then 
		cls()
		print("i'm on picovation duty", 20, 60, 7)
		print("press z to start", 34, 70, 7)
	else

	if cam == 0 then
		sspr(0, 0, 64, 64, 0, 0, 128, 128)
	elseif cam == 1 then
		sspr(64, 0, 64, 64, 0, 0, 128, 128)
	elseif cam == 2 then
		sspr(64, 64, 64, 64, 0, 0, 128, 128)
	end
	
	draw_anomaly(cam)
	
	if report_menu_flag then
		report_menu()
	end
	
	print("●", 1, 1, 8)
	print("cam " .. cam, 9, 1, 1)
	print(format_time(clock), 108, 1, 1)
	
	if is_pending then
		print("pending...", 50, 1, 1)
	end
	
	if fixing_screen then
		rectfill(0, 0, 128, 128, 6)
		print("fixing...", 50, 61, 1)
	end
	
	if wrong_anomaly then
		print("wrong anomaly", 40, 1, 1)
	end
	
	if clock > 359 then
	
		if clock == 360 and first then
			sfx(15)
			first = false
		end
	
		game_over = true
		rectfill(0, 0, 128, 128, 7)
		print("you won", 51, 60, 0)
		print("you caught " .. count_of_catch_anomaly .. " anomalies", 19, 66, 0)
	end
	
	if count_of_active_anomaly - count_of_catch_anomaly >= 4 then
		game_over = true
		sfx(11)
		rectfill(0, 0, 128, 128, 0)
		print("too many anomalies active", 18, 60, 7)
		print("you lose", 51, 66, 7)
	end
	
	end
	--print(rnd_value, 100, 100, 1)
	--print(index, 105, 105, 1)
end

function _update()

	if init_screen then
		if btnp(4) then
			init_screen = false
			music(-1)
		end
	else

	if not game_over then

	local current_time = time()
 if current_time - last_time >= 1 then
  last_time = current_time
  if clock <= 360 then
   clock = clock + 1
  end
 end
 
 if clock == 270 and first_monster then
 	make_monster() 
 	first_monster = false
 end
 
 if is_pending then
 	wrong_anomaly = false
 	report_menu_flag = false
 	if current_time - pending_time > 5 then
 		is_pending = false
 		try_catch_anomaly(target_typ, target_cam)
 	end
 end
 
 if fixing_screen then
 	if current_time - fixing_time > 1.5 then
 		fixing_screen = false
 	end
	end 
	
	if wrong_anomaly then
		if current_time - wrong_time > 3 then
			wrong_anomaly = false
			make_anomaly()
		end
	end
 
 if current_time - event_time > 20 then
 	event_time = current_time
  make_anomaly()
 end
	
	if report_menu_flag then 
	
		if btnp(5) then
			sfx(3)
			report_menu_flag = false
		end
	
		if btnp(2) then
			arrow_index = arrow_index - 1
			if arrow_index ~= 0 then sfx(2) end
			if arrow_index < 1 then
				arrow_index = 1
			end
		end
	
		if btnp(3) then
			arrow_index = arrow_index + 1
			if arrow_index ~= 5 then sfx(2) end
			if arrow_index > 4 then
				arrow_index = 4
			end
		end
		
		if btnp(1) and active_page ~= 1 then
			active_page = 1
			sfx(2)
		end
		
		if btnp(0) and active_page ~= 0 then
			active_page = 0
			sfx(2)
		end
		
		if btnp(4) then
			sfx(4)
			sfx(6)
			pending_time = time()
			is_pending = true
			target_typ = arrow_index + 4 * active_page
			target_cam = cam
		end
		
	end
	
	if not report_menu_flag then

		if btnp(4) and not is_pending then
			report_menu_flag = true
			sfx(1)
		end
		
		if btnp(1) then
		 cam = cam + 1
		 sfx(0)
		 if cam > 2 then
		 	cam = 0
		 end
		end
		
		if btnp(0) then
			cam = cam - 1
			sfx(0)
			if cam < 0 then
				cam = 2
			end
		end
	
	end
		
end

end
end

function report_menu()
	rect(0, 101, 127, 127, 7)
	rectfill(1, 102, 126, 126, 0)
 print(">", 2, arrow_index * 6 + 97, 7)

	if active_page == 0 then
		print("lights off", 6, 103, 7)
		print("object disappearance", 6, 109, 7)
		print("extra object/replacement", 6, 115, 7)
		print("distortion/camera failure", 6, 121, 7)
		print("1/2", 115, 121, 7)
	elseif active_page == 1 then
		print("monster", 6, 103, 7)
		print("door anomaly", 6, 109, 7)
		print("picture/color anomaly", 6, 115, 7)
		print("other", 6, 121, 7)
		print("2/2", 115, 121, 7)
	end
end

function format_time(clock)
    local minutes = flr(clock / 60)
    local seconds = clock % 60
    if minutes < 10 then
        minutes = "0" .. minutes
    end

    if seconds < 10 then
        seconds = "0" .. seconds
    end

    return minutes .. ":" .. seconds
end

function draw_anomaly(cam)

	if cam == 0 then
	
		if anomalies[1].act then
			sspr(8, 0, 8, 8, 0, 0, 16, 16)
		end
		
		if anomalies[4].act then
			sspr(0, 64, 8, 8, 80, 96, 16, 16)
		end
		
		if anomalies[5].act then
			sfx(8)
			sspr(8, 64, 8, 16, 64, 48, 16, 32)
		end
		
		if anomalies[6].act then
			sspr(16, 64, 8, 8, 80, 48, 16, 16)
		end
		
		if anomalies[7].act then
			sspr(24, 64, 8, 8, 112, 0, 16, 16)
		end
		
		if anomalies[61].act then
			sspr(40, 40, 8, 8, 96, 80, 16, 16)
		end
		
		if anomalies[8].act then
			sspr(32, 64, 8, 16, 112, 80, 16, 32)
		end	
		
		if anomalies[9].act then
			rectfill(116, 112, 117, 113, 1)
			rectfill(122, 112, 123, 113, 1)
			rectfill(114, 114, 123, 121, 1)
			rectfill(116, 122, 121, 123, 1)
		end
		
		if anomalies[10].act then
			sspr(48, 64, 16, 16, 16, 32, 32, 32)
		end
		
		if anomalies[58].act then
			for i = 0, 3 do
				for j = 0, 2 do
					sspr(8, 0, 8, 8, 0 + i*16, 16 + j*16, 16, 16)
				end
			end
		end
		
		if anomalies[11].act then
			rectfill(64, 10, 67, 13, 9)
		end
		
		if anomalies[12].act then
			rectfill(86, 70, 87, 77, 5)
		end
		
		if anomalies[55].act then
			sspr(56, 120, 8, 8, 80, 112, 16, 16)
		end
		
		if anomalies[44].act then
			rectfill(18, 84, 29, 95, 9)
			rectfill(16, 86, 17, 87, 9)
			rectfill(18, 90, 29, 91, 4)
		end
		
		if anomalies[47].act then
			sspr(0, 112, 24, 8, 16, 112, 48, 16)
		end
		
		if anomalies[53].act then
			sspr(40, 112, 16, 8, 96, 32, 32, 16)
			sspr(40, 120, 16, 8, 96, 96, 32, 16)
			if anomalies[8].act then
				sspr(40, 64, 8, 8, 112, 96, 16, 16)
			end
		end
		
		if anomalies[48].act then
			sspr(0, 56, 8, 8, 48, 112, 16, 16)
			sspr(8, 56, 24, 8, 0, 112, 48, 16)
		end
		
		if anomalies[36].act then
			local j = 14
			for i = 102, 114, 2 do
				rectfill(i, 58, i+1, 61, j)
				j = j - 1
			end
		end
		
		if anomalies[37].act then
			sspr(24, 96, 16, 8, 96, 64, 32, 16)
		end
		
		if anomalies[38].act then
			rectfill(94, 52, 95, 53, 5)
			rectfill(94, 56, 95, 61, 14)
			rectfill(92, 52, 93, 59, 14)
			rectfill(92, 56, 93, 57, 0)
		end
		
		if anomalies[3].act then
			sfx(11)
			sspr(32, 8, 24, 24, 0, 0, 128, 128)
		end
		
		if anomalies[2].act then
			rectfill(0, 0, 128, 128, 0)
		end
	
	elseif cam == 1 then
	
		if anomalies[15].act then 
			sspr(64, 48, 8, 16, 64, 96, 16, 32)
			rectfill(78, 118, 79, 121, 4)
		end
		
		if anomalies[62].act then
			rectfill(66, 84, 77, 93, 15)
			rectfill(72, 88, 73, 89, 7)
		end
		
		if anomalies[63].act then
			rectfill(64, 70, 67, 79, 4)
		end
		
		if anomalies[18].act then
			rectfill(44, 88, 45, 89, 15)
			rectfill(52, 88, 53, 89, 15)
			rectfill(38, 88, 39, 89, 7)
			rectfill(58, 88, 59, 89, 7)
		end
		
		if anomalies[19].act then
			rectfill(46, 66, 47, 67, 12)
		end
		
		if anomalies[20].act then
			sspr(16, 72, 16, 8, 64, 16, 32, 16)
		end
		
		if anomalies[21].act then
			rectfill(58, 56, 59, 59, 8)
			rectfill(56, 60, 57, 61, 8)
		end
		
		if anomalies[16].act then
			rectfill(86, 108, 91, 109, 7)
		end
		
		if anomalies[17].act then
			sfx(8)
			sspr(0, 72, 8, 16, 64, 96, 16, 32)
		end
		
		if anomalies[41].act then
			rectfill(70, 50, 75, 61, 9)
			rectfill(72, 48, 73, 49, 5)
		end
		
		if anomalies[42].act then
			rectfill(86, 72, 87, 75, 9)
			rectfill(86, 76, 89, 77, 10)
			rectfill(88, 74, 89, 75, 9)
		end
		
		if anomalies[43].act then
			sspr(104, 32, 8, 8, 112, 64, -16, 16)
		end
		
		if anomalies[51].act then
			rectfill(6, 48, 11, 61, 7)
		end
		
		if anomalies[52].act then
			rectfill(20, 50, 21, 53, 0)
			rectfill(24, 50, 25, 53, 0)
			rectfill(22, 52, 23, 55, 0)
		end
		
		if anomalies[50].act then
			sspr(24, 104, 16, 24, 0, 48, 32, 48)
		end
		
		if anomalies[49].act then
			sspr(40, 96, 16, 16, 80, 80, 32, 32)
		end
		
		if anomalies[46].act then
			sspr(0, 96, 8, 16, 16, 96, 16, 32)
		end
		
		if anomalies[33].act then
			rectfill(16, 20, 17, 25, 7)
			rectfill(20, 22, 21, 23, 0)
			rectfill(18, 24, 19, 25, 0)
		end
		
		if anomalies[34].act then
			sspr(8, 96, 8, 16, 96, 16, 16, 32)
		end
		
		if anomalies[35].act then
			sspr(16, 96, 8, 16, 112, 48, 16, 32)
		end
		
		if anomalies[60].act then
			sspr(64, 8, 16, 12, 2, 2, 48, 40)
		end
		
		if anomalies[59].act then
			if not anomalies[13].act then sfx(11) end
			sspr(80, 0, 8, 8, 40, 32, 128, 80)
		end
	
		if anomalies[14].act then
			if not anomalies[13].act then sfx(11) end
			sspr(64, 0, 64, 64, 128, 128, -128, -128)
		end
	
		if anomalies[13].act then
			rectfill(0, 0, 128, 128, 0)
		end
	
	elseif cam == 2 then
	
		if anomalies[22].act then
			rectfill(32, 50, 35, 55, 4)
			rectfill(32, 48, 35, 49, 13)
		end
		
		if anomalies[23].act then
			rectfill(46, 82, 49, 91, 14)
			rectfill(50, 86, 51, 91, 12)
		end
		
		if anomalies[45].act then
			for i = 0, 5 do
				rectfill(66 + i*4, 98 + i*2, 71 + i*4, 99 + i*2, 8)
			end
			rectfill(90, 110, 93, 111, 8)
		end
		
		if anomalies[25].act then
			sfx(8)
			sspr(8, 80, 16, 8, 48, 80, 32, 16)
			sspr(8, 88, 16, 8, 64, 96, 32, 16)
		end
		
		if anomalies[26].act then
			sspr(24, 80, 16, 16, 16, 96, 32, 32)
		end
		
		if anomalies[54].act then
			sspr(0, 120, 24, 8, 32, 112, 48, 16)
			if anomalies[26].act then
				sspr(40, 88, 8, 8, 32, 112, 16, 16)
			end
		end
		
		if anomalies[27].act then
			sspr(40, 72, 8, 16, 0, 48, 16, 32)
		end
		
		if anomalies[28].act then
			sfx(13)
			sspr(48, 80, 16, 16, 96, 0, 32, 32)
		end
		
		if anomalies[29].act then
			rectfill(16, 84, 17, 93, 8)
		end
		
		if anomalies[30].act then
			sspr(0, 88, 8, 8, 32, 64, 16, 16)
		end
		
		if anomalies[31].act then
			rectfill(26, 82, 27, 89, 9)
			rectfill(26, 80, 27, 81, 7)
			rectfill(28, 84, 29, 89, 9)
		end
		
		if anomalies[32].act then
			rectfill(38, 50, 41, 53, 5)
		end
		
		if anomalies[39].act then
			rectfill(36, 48, 37, 53, 11)
		end
		
		if anomalies[40].act then
			sspr(56, 96, 8, 24, 48, 16, 16, 48)
		end
		
		if anomalies[24].act then
			sspr(0, 0, 64, 64, 0, 0, 128, 128)
		end
		
		if anomalies[57].act then
			sfx(11)
			sspr(80, 72, 32, 24, 96, 64, -64, -48)
		end
		
		if anomalies[56].act then
			rectfill(0, 0, 128, 128, 0)
		end
		
	end

end

function try_catch_anomaly(typ_, cam_)

	local anomaly_exist = false 

	for i, anomaly in ipairs(anomalies) do
		if anomaly.typ == typ_ and anomaly.cam == cam_ and anomaly.act then
			anomaly_exist = true
			fixing_screen = true
			fixing_time = time()
			sfx(7)
			anomalies[i].act = false
			count_of_catch_anomaly = count_of_catch_anomaly + 1
			break
		end
	end
	
	if not anomaly_exist then
		wrong_anomaly = true
		sfx(5)
		wrong_time = time()
	end

end

function make_anomaly() 
	rnd_value = flr(rnd(101))
 	
 if rnd_value < 66 then
 	
 	repeat
 		index = flr(rnd(#anomalies))+1
 	until not anomalies[index].act
 	
 	anomalies[index].act = true
 	count_of_active_anomaly = count_of_active_anomaly + 1
 	
 	if index == 2 or index == 13 or index == 56 then sfx(10) end
 	if index == 8 or index == 26 or index == 49 or index == 50 then sfx(9) end
		if index == 29 or index == 25 or index == 45 then sfx(12) end
		if index == 4 or index == 16 or index == 31 or index == 53 or index == 61 then sfx(14) end
 end
end

function make_monster() 

	local ind = flr(rnd(3))
	if ind == 0 then
		anomalies[5].act = true
		count_of_active_anomaly = count_of_active_anomaly + 1
	elseif ind == 1 then
		anomalies[17].act = true
		count_of_active_anomaly = count_of_active_anomaly + 1
	elseif ind == 2 then
		anomalies[25].act = true
		count_of_active_anomaly = count_of_active_anomaly + 1
	end
	
end
__gfx__
ff555ff6fffffff6fffffff6fffffff655fffff6fffffff6fffff7f6f7ff77769999999999999999999999999999999999999999999999999999999999999999
fff55ff6fffffff6fffffff6fffffff655fffff6fffffff6fffff7f677f77ff79999999999999999999999999999999999999999999999999999999999999999
ffff55f6fffffff6fffffff6fffffff5555ffff6fffffff6fffff7f7ff7ff7f79999999999999999999999999999999999999999999999999999999999999999
fff55556fffffff6fffffff6fffff55555555ff6fffffff6ffffff76ff7f7f779999999999999999999999999999999999999999999999999999999999999999
fff5ff55fffffff6fffffff6ffff5555555555f6fffffff6ffffff76f7f7ff769999999999999999999999999999999999999999999999999999999999999999
ff55ff55fffffff6fffffff6fffff555aa555ff6fffffff6fffffff77fff77f69999999999999999999999999999999999999999999999999999999999999999
fffff556fffffff6fffffff6fffffff6aafffff6fffffff6fffffff67ff7ff779999999999999999999999999999999999999999999999999999999999999999
fffff5f6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6f7f7f7f69999999999999999999999999999999999999999999999999999999999999999
fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6ff7ff7f69999994444499999999999999999999944444444444444449999999999999999
fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fff77ff69999947777749999999999999999999947777777777777749999999999999999
fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffff77799994777077749999999999999999999477777a7777777749999999999999999
fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff6fffffff699947777077774999999999999999999477377aa777377749999999999999999
fffffff6fffffff6fffffff6fffffff6fffffff6fffffff633bffff6fffffff6999477770777749999999999999999994777387aa73777749999999999999999
fffffff6fffffff55ffffff6fffffff6fffffff6ffffffb3fff3fff6fffffff6999477770000749999999999999999994778888aabb977749944444499999999
fffffff6ffffff56f5fffff6fffffff6fffffff6fb3fff333ffffff6fffffff6999477777777749999999999999999994778888aabb99774994accc499999999
fffffff555555555555555555ffffff6fffffff33333f333fb3ffff6fffffff699947777777774999999999999999999477d88aabbbbd774994cccc499999999
fffffff5cccccccccccccccc5ffffff6ffffff3bfff3333fff3ffff6fffffff6999947777777499999999999999999994777dddddddd7774994ccdc499999999
fffffff5cccccccccccccccc5ffffff6ffffff36ffff333fff3ffff6fffffff6999994777774999999999999999999994777777777777774994ccdd499999999
fffffff5cccccccccccccaac5ffffff6ffffff36fff133b1ff3ffff88888cff6999999444449999999999999999999994444444444444444994ccdd499999999
fffffff5ccccccccc7cccaac5ffffff6fffffff6fff11111ffffff888888ccf6999999999999999999999999999999999999999999999999994ccdd499999999
fffffff5cccccccc667ccccc5ffffff6fffffff6fff1111100000088888888a0999999999999999999999999999999999999999999999999994dcdd499999999
fffffff5c3ccccc66667cccc5ffffff6fffffff6fff111114444448888888884999999999999999999999999999999999999999999999999994dcdd499999999
fffffff5333ccc6666667ccc5ffffff6fffffff6ff0111114444444004440044999777777777777779999999999999999999999999999999994dddd499999999
fffffff53333cc6666666ccc5ffffff6fffffff6f044111444444444444444449977777777777777699999999999999999999999999999999944444499988999
fffffff533366666666667c35ffffff6fffffff60000000000000000000000009777777777777776699999999995055545556599999999999999999999822899
fffffff564666666666666335ffffff6fffffff60057755555555555555555559777777777878776699999999999099949996999999999999999999999822899
fffffff564666666666663335ffffff6fffffff60077775e55e55555555555559777777777888776699999999999099949996999999999999999999999822899
fffffff555555555555555555ffffff6fffffff60077775eeee5555555cccccc9777777777787776699999999999669949996999999999999999999999822899
fffffff6fffffff6fffffff6fffffff6fffffff600577550ee05555555cccccc9777a77777777776699999999999669444966699999999999999999999822899
fffffff6fffffff6fffffff6fffffff6fffffff6005dd55eeee89abcde333333977aaa7777777776699999999999669444969699999999999999999999825899
fffffff6fffffff6fffffff6fffffff6fffffff600dddd55ee589abcde3333339777a77777777776699999669999699949969699999999999999999999958599
fffffff6fffffff6fffffff6fffffff6fffffff600000000000000000000000097777777777777766999969969999999999999999999999999999999a9959599
fffffff6fffffff6fffffff6fffffff6fffffff600555555555555555555dd559777777ff7777776699999996999999999999999966666666666666933599599
fffffff6fffffff6fffffff6fffffff6fffffff600d555e1155555999999dd559777777ff7777776444444486c4444444444444966600666666006669359593a
fffffff6fffffff6fffffff6fffffff6fffffff600d588e1155522599995dd889777777ff7776674444555556555554444448444660660666606606693359939
fffffff6fffffff6fffffff6fffffff6fffffff600db88e1135522599995dd889777b77777777674445555555555555464488844666006666660066699399939
fffffff6f44444444ff44444444ffff6fffffff600db88e1133522559955dd88977b777777c77674445555555555555466488844666666661611116699939339
fffffff649999999944999999994fff6fffffff600db88e1153322559955dd889777b7777ccc7774445555555555555466448444666006666111116699939399
fffffff4999999999999999999994ff6fffffff600db88e1155322599995dd88977b777777c77774445555556555555404444444660660666611116699939399
ffffff499999999999999999999994f6fffffff60000000000000000000000009777777777777774445555566655555404444444666006666660066699933399
ffffff499999999999999999999994f6fffffff6044444440444444404444444266666666666666444455555555555444444444466555555555555662223323a
ffffff499999999999999999999994f6fffffff6044444440444444404444444277777777777777444444444444444444444444465555000000555562a33333e
ffffff499cccc9999999999eeee994f6fffffff6044444440444444404444444277777777777777444ffffff4ffffff444ffff44655555555555555622333332
fffff494c6666c99999999effffe4946fffffff6040444440444440404044444277777777777777444ffffff4ffffff444ffff44655555555555555622111112
00004999466666c999999efffff4999400000000044444440444444404444444277777777777777444ffff7f4f7ffff444ff7f44655555555555555622111112
66664949466666c444444efffff4949466666666044444440444444404444444277777777777777444ffffff4ffffff444ffff44655555555555555622111112
6666499946666c99999999effff4999466666666044444440444444404444444277777777777777444ffffff4ffffff444ffff44665555555555556622211122
666649949cccc9999999999eeee9499466666666000000000000000000000000e7777777777777744444444444444444444444446666666666666666eee111ee
666649949999999999999999999949946666666666666666666666666666666622222e2222222e2222222e2222222e2222222e2222222e2222222e2222222e22
66666494999999999999999999994946666666666666666666666666666633662222e2222222e2222222e2222222e2222222e2222222e2222222e2222222e222
66666494999999999999999999994946666666666666666666666666666333662222e2222222e2222222e2222222e2222224e2222222e223322233222222e222
66666644449999999999999999444466666666655555555555566666663336662222e2222222e2222222e2222222e2222244e2222222e233332332223322e222
6666666644444444444444444444666666666554444444444456666663333366222e2222222e2222222e2222222e222224442222224444344333444433444422
6666666664446666666666664446666666665444444444444456666666333336222e2222222e2222222e2222222e222244f42222224444444433444433444422
6666666666466666666666666466666666665444444444444456666666333336222e2222222e2222222e2222222e22224ff42222244444444433444432444222
6666666666666666666666666666666666666544444444444456666666644666eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4ff4eeeee44444444411474732444eee
666666666644446666644444446666666666665555555555555666666624426622e2222222e2222222e2222222e222224ff42222444774444411477733442222
66666666649a9a44444a9a9a9a4666666666666600666600666666666222226622e2222222e2222222e2222222e222224f442222447877444411447433442222
66666666649a9a9a9a9a9a9a9a4666666666666660066006666666666222226622e2222222e2222222e2222222e2222244444422447887444444447444442222
66666666649a9a9a9a9a9a9a94666666666666666600006666666666622222662e2222222e2222222e2222222e22222244444424444774444444444444422222
66666666649a9a9a9a9a9a9a94666666666666666660066666666666622222662e2222222e2222222e2222222e22222244444224444444444444444444422222
66666666649a9a9a9a9a9a9a9a466666666666666600006666666666662226662e2222222e2222222e2222222e22222244444222242242222e22224224222222
666666666649a9a9a9aa9a9a9a46666666666666600660066666666666666666e2222222e2222222e2222222e222222242224222e4224222e2222242e4222222
66666666649a9a9a9a9a9a9a9a46666666666666006666006666666666666666eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4eee4eeee4eeeeeeeeeeee4eeeeeeeee
66666666fffffff600000000f0ff700000000004666444460000000000555550dddddddddddddddddddddddddddddddddccc7ccc7ccc7ccc7cc00ccccccccccc
66666600ff000ff6005777550707000000000444660433660555500005555555dddddddddddddddddddddddddddddddddcccccccccccccccccc05000cccccccc
66666606f00000060077777eff70000000004444888333660555500007555555dddddddddddddddddddddddddddddddddc7ccc7ccc7cccccccc05555000ccccc
55550000f00007000070707eff00000700044444883336665575700005750555dddddddddddddddddddddddddddddddddcccccccccccccccccc05005555000cc
444088800000000000777770f780000600044444833333665555500000000555dddddddddddddddddddddddddddddddddc7c7c7c7ccc7ccc7cc0555000555500
44088880007000000057775e7f0800f000044444883333365555500000000055dddddddddddddfffdddddddddddddddddcccccccccccccccccc0500555000555
40000000f0000000005676557ff7ff0700040444663333365555500555000055dddddddddddddffffddddddddddddddddc7ccc7ccc7ccc7ccc70555000555005
44444444f000000000000000f7f7f0ff00044444666446665555505557000055dddddddddddddddfffdddddddddddddddcccccccccccccccccc0500555000555
22220002fff00000444444444444444466644446dddddddc5555505555000555dddddddddddddddffffddddddddddddddc7c7c7c7c7c7c7c7c70055000555005
22200000ffff0000477777777777777466643366dddddc7c0555505555000555ddddddddddddddffffffddddddddddddd7ccccccccccccccccccc00055000555
22208008ffffff00477377a77777777466633366dddcc7cc0555500555005555dddddddddddddfffffff7ddddddddddddc7c7c7c7c7ccc7ccc7ccc7c00055005
22400000fffffff6477737aa7777777466333666ddcc7ccc5555555555555555dddddddddddddfffffff7ddddddddddddcccccccccccccccccccccccccc00055
24440002ffffff004777bb7aa773777463333366ddcc7cccfffffff6fffffff6ddddddddddddd7fffff7dddddddddddddc7c7c7c7c7c7c7c7c7c7c7c7ccc7c00
44f00022fffff0004777bb7aa837777466333336ddc700ccfffffff6fffffff6dddddddddddddd77aa7ddddddd5dddddd7ccc7cccccccccccccccccccccccccc
4ff00222fffff006477bbbba8888777466333336dd70000cfffffff6fffffff6ddddddddddddddddaaddddddddd5bddddc7c7c7c7c7c7c7c7c7c7c7ccc7ccc7c
4ff00eeefffffff6477dbbaa8888d77466644666dd000000fffffff6fffffff6ddddddddddddddddddddddddddddbddddccccccccccccccccccccccccccccccc
4ff00222d6d6600000677777f44fffffff4ddd67dd0800807cc00cccccccccccddddddddddddddddddddddddddddbbdddc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
4f400022dd660000000667c74fff4ffff44ddd67dd000000ccc00000ccccccccdddddddddddddddddddddddddddbbbddd7ccc7ccc7ccc7ccc7cccccccccccccc
44000022dd60000007077667fffffff4404dddd6ddc0000cccc00000000cccccdddddddddddddddddddddddddddbbbdddc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
440040046660070000077776fffff440044dddd6ddcc00ccccc00000000000ccdddddddddddddddddddddddddddbb3dddcc7ccc7ccc7cccccccccccccccccccc
440042047777000000066777fff440004f4dd006ddc700cc7cc0000000808055ddddddddddddddddddddd22ddddbbb3ddc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
444002027766000000066667f44f40004f400111dd70000dccc0000000000055ddddddddddddddddddddd22ddd3bbb3dd7ccc7c7c7ccc7ccc7ccc7ccccccc7cc
4222020277766000000066664fff4004ff451111dd000dddcc70000000000050ddddddddddddddddddddd22ddd3bbbbddc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
4eee0e0e6677760000000666ffff404fff415511dd0dddddccc0808000000055dddddddddccdddeddddd422ddd3bbbbddcc7ccc7ccc7ccc7ccc7ccc7cccccccc
8d8d88dd0000000666666777ffff404fff411155ff4111557c70000000000050dddddddccccdddedaa44422dd3bbbbbbdc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
888d88dd7000000006666667ff4f404f4f4111194f415511ccc0000000080855dddddc7ccccddeeeaa411224d3bbb3bbd7c7c7c7c7c7c7c7c7c7c7ccc7ccc7cc
8d8d8ddd7770000000066666ffff404fff411999ff451111cc70c00000000050dddcc7cccccddeeeaa4114ddd3bbb3bbdc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
8d8d88dd6677700000000666ffff404ff4199998f4111111ccc0c00c0c000055ddcc7ccccc7d4eeeaa44ddddd3bbb33bd7c7c7c7c7c7ccc7ccc7ccc7ccc7ccc7
d8ddd88d7766777000000066ffff404f49998888411111117c7c707c0cc00005ddcc7cccc77ddeee44ddddddd3bb3b33dc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
d8ddd8d87777667770000006fff4404f4199988841111115ccccc0ccccccc0ccddc7cccc77cddd44dddddddd3bbb3b33d7c7c7c7c7c7c7c7c7c7c7c7c7ccc7cc
d8ddd88d7777776677700000f440004405519998055115517c7c707c0c70c07cdd7ccccc77cddddddddddddd3bb33bbddc7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c
d888d8dd7777777766777007400000000015519900155111ccccc0cc0cccccccddccccc77ccddddddddddddd3bb33dddd7c7c7c7c7c7c7c7c7c7c7c7ccc7ccc7
29229e229999999999888899555555b5555bdd556600000000000066ddddddddddcccc77cccdddddddddddddddddddddd77c777c777c7c7c777c7c7c7c7c7c7c
2999922299999999998888991555555b55b5dd556000000000000006ddddddddddccc77ccccdddddddddddddddddddddd7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7
9999992299999999998888991555225bbbb5dd886000000000000006ddddddddddcc7c7ccccddddddddddddddddddddddc777c7c7c777c7c7c7c7c7c7c7c7c7c
909909229999999999888899135522b0bb0bdd886000000000000006ddddddddddcc77cccccdddddddddddddddddddddd7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7
999999229999999999888899133522bbbbbbdd886000000000000006ddddddddddc77ccccdddddddddddddddddddd66dd77c777c777c777c777c777c7c7c7c7c
299992229944444499888899153322b5555bdd886000000000000006dd5ddddddd7c7ccddddddddddddddddddddd6dd6d7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7
2299222299455554999589991553225b55b5dd886655555555555566ddd5edddddc7cdddddddddddddddddddddd6dddddc777c777c777c777c7c7c7c7c7c7c7c
ee99ee9e99455554a995999900000000000000006555555555555556ddddedddddcdddddddddddddddddddddddd6d6dd67c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7
22992292994058043395999997667777777777762555555555555552ddddeeddddddddd6ddddddddddddddddd6d66d66766777777777777c777c777c777c777c
29999292994058849395993a97776666666666662555550000555552dddeeedddddddd6d6ddd44dddddddddddd666667777667c7c7c7c7c7c7c7c7c7c7c7c7c7
29999229994008849335993997777776666666662255555335553322dddeeedddddddd6ddd44ff44dddddddddd6666776777766777777c777c777c777c777c7c
99449929994008849932293997777777777666662222e23333233222dddee2dddddddd6677ffffff44dddddd666677666667777667c7c7c7c7c7c7c7c7c7c7c7
94444929994808849993233997a77777777776662244443443334444dddeee2dddddd6776677fffff44ddd66777766666666677776677777777c7777777c777c
9444499999480884999323999aaa7777877776662244444444334444dd2eee2ddddd776666667ff44f4dd6777766666666666667777667c7c7c7c7c7c7c7c7c7
99449992994888849993239997a77777888776662444444444334444dd2eeeeddd44f7766667744fff4dd6667776666666666666677776677c777c777c777c77
e9449eee99444444999323999777777778777666e444444444114747dd2eeeed44fffff777744fffff4dd67766777666666666666667777667c7c7c7c7c7c7c7
6644446666644444446666669777777777777666ff3ffff6fffffff6d2eeeeee444ffffff44fffffff4ddd677766777666666666666667777667777777777777
649a9a44444a9a9a9a4666669777777777777666ff3ffff6fffffff6d2eee2ee4ff44ff44fff4ffff44ddd67777766777555666666666667777667c7c7c7c7c7
64a9a9a9a9a9a9a9a9466666977777f777777664ff3ffff6fffffff6d2eee2ee4ffff44ffffffff44f4dddd67777776677755566666666666777766777777c77
649a9a9a9a9a9a9a94666666977777f777777664fffffff6fffffff6d2eee22e4ffff4fffffff44fff4dddd67777777766777555666666666667777667c7c7c7
64a9a9a9a9a9a9a9a4666666977b77f7777776640000000000000000d2ee2e224ffff4fffff44fffff4dd0067777777777667775556666666666677776777777
649a9a9a9a9a9a9a9a46666697b777777767766444444444444444442eee2e224ffff4fff44f4fffff4001116777777777776677755566666667777766c7c7c7
6649a9a9a9a9a9a9a9466666977b77777776766444444444444444442ee22eed4ffff4f44fff4fffff4511116777777777777766777555666777776667777777
649a9a9a9a9a9a9a9a46666697b777777776766444444444444444442ee22ddd4ffff44fffff4f4fff4155111667777777777777667775577777667767c7c7c7
ff41115511166777777777772777777c777676646666666666666666555555554ffff4ffffff4fffff4111551916677777777777776677777766777677777777
ff4155115511166777777777267777ccc77776746666600666003366006666004ffff4ffff4f4fffff4111199999566777777777777766776677777677c777c7
f445111111511556677777772766777c777776746666888888833366600660064ffff4ffffff4ffff44119999899991667777777777777667777776777777777
41111111111551111666777727776667777776745556a88888333666660000664ffff4ffffff4ff441199998888899911666777777777776777777600777c7c7
1111111115511551111166772777777666677674445688cc83333366666006664ffff4ffffff4441199988888888899991556677777777677777761110077777
5111111551111115511155662777777777766774445668cc88333336666006664ffff4fffff441155199988888888889999111667777776777776111111007c7
155115511111111115551111277777777777777444566666663333366660066644fff4fff4411111155199988888888889999111667776777766151115511007
511551111111111155115111e7777777777777744456666666644666666006660144f4f441111115511551998888888888899911116676777611115551111110
__label__
ffff555555ffff66ffffffffffffff66ffffffffffffff66ffffffffffffff665555ffffffffff66ffffffffffffff66ffffffffff77ff66ff77ffff77777766
fff888555511f111f111fffff111ff66ffffffffffffff66ffffffffffffff665555ffffffffff66ffffffffffffff66ffffffffff7711161117ffff11171766
ff888f8551fff161f111fffff1f1ff66ffffffffffffff66ffffffffffffff665555ffffffffff66ffffffffffffff66ffffffffff771f161717f177171f1f77
ff88888551fff111f1f1fffff1f1ff66ffffffffffffff66ffffffffffffff665555ffffffffff66ffffffffffffff66ffffffffff771f161717ff77171f1117
ff88888f5155f161f1f1fffff1f1ff66ffffffffffffff66ffffffffffffff55555555ffffffff66ffffffffffffff66ffffffffff771f171f1f71ff1f171f17
fff888ff5511f161f1f1fffff111ff66ffffffffffffff66ffffffffffffff55555555ffffffff66ffffffffffffff66ffffffffff771117111f77ff11171117
ffffff5555555566ffffffffffffff66ffffffffffffff66ffffffffff5555555555555555ffff66ffffffffffffff66ffffffffffff7766ffff77ff77ff7777
ffffff5555555566ffffffffffffff66ffffffffffffff66ffffffffff5555555555555555ffff66ffffffffffffff66ffffffffffff7766ffff77ff77ff7777
ffffff55ffff5555ffffffffffffff66ffffffffffffff66ffffffff55555555555555555555ff66ffffffffffffff66ffffffffffff7766ff77ff77ffff7766
ffffff55ffff5555ffffffffffffff66ffffffffffffff66ffffffff55555555555555555555ff66ffffffffffffff66ffffffffffff7766ff77ff77ffff7766
ffff5555ffff5555ffffffffffffff66ffffffffffffff66ffffffffff555555aaaa555555ffff66ffffffffffffff66ffffffffffffff7777ffffff7777ff66
ffff5555ffff5555ffffffffffffff66ffffffffffffff66ffffffffff555555aaaa555555ffff66ffffffffffffff66ffffffffffffff7777ffffff7777ff66
ffffffffff555566ffffffffffffff66ffffffffffffff66ffffffffffffff66aaaaffffffffff66ffffffffffffff66ffffffffffffff6677ffff77ffff7777
ffffffffff555566ffffffffffffff66ffffffffffffff66ffffffffffffff66aaaaffffffffff66ffffffffffffff66ffffffffffffff6677ffff77ffff7777
ffffffffff55ff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ff77ff77ff77ff66
ffffffffff55ff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ff77ff77ff77ff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffff77ffff77ff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffff77ffff77ff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffff7777ffff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffff7777ffff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffff777777
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffff777777
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff663333bbffffffff66ffffffffffffff66
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff663333bbffffffff66ffffffffffffff66
ffffffffffffff66ffffffffffffff5555ffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffbb33ffffff33ffffff66ffffffffffffff66
ffffffffffffff66ffffffffffffff5555ffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffbb33ffffff33ffffff66ffffffffffffff66
ffffffffffffff66ffffffffffff5566ff55ffffffffff66ffffffffffffff66ffffffffffffff66ffbb33ffffff333333ffffffffffff66ffffffffffffff66
ffffffffffffff66ffffffffffff5566ff55ffffffffff66ffffffffffffff66ffffffffffffff66ffbb33ffffff333333ffffffffffff66ffffffffffffff66
ffffffffffffff555555555555555555555555555555555555ffffffffffff66ffffffffffffff3333333333ff333333ffbb33ffffffff66ffffffffffffff66
ffffffffffffff555555555555555555555555555555555555ffffffffffff66ffffffffffffff3333333333ff333333ffbb33ffffffff66ffffffffffffff66
ffffffffffffff55cccccccccccccccccccccccccccccccc55ffffffffffff66ffffffffffff33bbffffff33333333ffffff33ffffffff66ffffffffffffff66
ffffffffffffff55cccccccccccccccccccccccccccccccc55ffffffffffff66ffffffffffff33bbffffff33333333ffffff33ffffffff66ffffffffffffff66
ffffffffffffff55cccccccccccccccccccccccccccccccc55ffffffffffff66ffffffffffff3366ffffffff333333ffffff33ffffffff66ffffffffffffff66
ffffffffffffff55cccccccccccccccccccccccccccccccc55ffffffffffff66ffffffffffff3366ffffffff333333ffffff33ffffffff66ffffffffffffff66
ffffffffffffff55ccccccccccccccccccccccccccaaaacc55ffffffffffff66ffffffffffff3366ffffff113333bb11ffff33ffffffff8888888888ccffff66
ffffffffffffff55ccccccccccccccccccccccccccaaaacc55ffffffffffff66ffffffffffff3366ffffff113333bb11ffff33ffffffff8888888888ccffff66
ffffffffffffff55cccccccccccccccccc77ccccccaaaacc55ffffffffffff66ffffffffffffff66ffffff1111111111ffffffffffff888888888888ccccff66
ffffffffffffff55cccccccccccccccccc77ccccccaaaacc55ffffffffffff66ffffffffffffff66ffffff1111111111ffffffffffff888888888888ccccff66
ffffffffffffff55cccccccccccccccc666677cccccccccc55ffffffffffff66ffffffffffffff66ffffff11111111110000000000008888888888888888aa00
ffffffffffffff55cccccccccccccccc666677cccccccccc55ffffffffffff66ffffffffffffff66ffffff11111111110000000000008888888888888888aa00
ffffffffffffff55cc33cccccccccc6666666677cccccccc55ffffffffffff66ffffffffffffff66ffffff111111111144444444444488888888888888888844
ffffffffffffff55cc33cccccccccc6666666677cccccccc55ffffffffffff66ffffffffffffff66ffffff111111111144444444444488888888888888888844
ffffffffffffff55333333cccccc66666666666677cccccc55ffffffffffff66ffffffffffffff66ffff00111111111144444444444444000044444400004444
ffffffffffffff55333333cccccc66666666666677cccccc55ffffffffffff66ffffffffffffff66ffff00111111111144444444444444000044444400004444
ffffffffffffff5533333333cccc66666666666666cccccc55ffffffffffff66ffffffffffffff66ff0044441111114444444444444444444444444444444444
ffffffffffffff5533333333cccc66666666666666cccccc55ffffffffffff66ffffffffffffff66ff0044441111114444444444444444444444444444444444
ffffffffffffff553333336666666666666666666677cc3355ffffffffffff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffffff553333336666666666666666666677cc3355ffffffffffff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffffff556644666666666666666666666666333355ffffffffffff66ffffffffffffff66000055777755555555555555555555555555555555555555
ffffffffffffff556644666666666666666666666666333355ffffffffffff66ffffffffffffff66000055777755555555555555555555555555555555555555
ffffffffffffff556644666666666666666666666633333355ffffffffffff66ffffffffffffff6600007777777755ee5555ee55555555555555555555555555
ffffffffffffff556644666666666666666666666633333355ffffffffffff66ffffffffffffff6600007777777755ee5555ee55555555555555555555555555
ffffffffffffff555555555555555555555555555555555555ffffffffffff66ffffffffffffff6600007777777755eeeeeeee55555555555555cccccccccccc
ffffffffffffff555555555555555555555555555555555555ffffffffffff66ffffffffffffff6600007777777755eeeeeeee55555555555555cccccccccccc
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000557777555500eeee0055555555555555cccccccccccc
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000557777555500eeee0055555555555555cccccccccccc
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66000055dddd5555eeeeeeee8899aabbccddee333333333333
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66000055dddd5555eeeeeeee8899aabbccddee333333333333
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dddddddd5555eeee558899aabbccddee333333333333
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dddddddd5555eeee558899aabbccddee333333333333
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000555555555555555555555555555555555555dddd5555
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000555555555555555555555555555555555555dddd5555
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dd555555ee11115555555555999999999999dddd5555
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dd555555ee11115555555555999999999999dddd5555
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dd558888ee11115555552222559999999955dddd8888
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000dd558888ee11115555552222559999999955dddd8888
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000ddbb8888ee11113355552222559999999955dddd8888
ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff66ffffffffffffff660000ddbb8888ee11113355552222559999999955dddd8888
ffffffffffffff66ff4444444444444444ffff4444444444444444ffffffff66ffffffffffffff660000ddbb8888ee11113333552222555599995555dddd8888
ffffffffffffff66ff4444444444444444ffff4444444444444444ffffffff66ffffffffffffff660000ddbb8888ee11113333552222555599995555dddd8888
ffffffffffffff664499999999999999994444999999999999999944ffffff66ffffffffffffff660000ddbb8888ee11115533332222555599995555dddd8888
ffffffffffffff664499999999999999994444999999999999999944ffffff66ffffffffffffff660000ddbb8888ee11115533332222555599995555dddd8888
ffffffffffffff44999999999999999999999999999999999999999944ffff66ffffffffffffff660000ddbb8888ee11115555332222559999999955dddd8888
ffffffffffffff44999999999999999999999999999999999999999944ffff66ffffffffffffff660000ddbb8888ee11115555332222559999999955dddd8888
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66000000000000000000000000000000000000000000000000
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffffff449999999999999999999999999999999999999999999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffffff449999cccccccc99999999999999999999eeeeeeee999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffffff449999cccccccc99999999999999999999eeeeeeee999944ff66ffffffffffffff66004444444444444400444444444444440044444444444444
ffffffffff449944cc66666666cc9999999999999999eeffffffffee44994466ffffffffffffff66004400444444444400444444444400440044004444444444
ffffffffff449944cc66666666cc9999999999999999eeffffffffee44994466ffffffffffffff66004400444444444400444444444400440044004444444444
0000000044999999446666666666cc999999999999eeffffffffff44999999440000000000000000004444444444444400444444444444440044444444444444
0000000044999999446666666666cc999999999999eeffffffffff44999999440000000000000000004444444444444400444444444444440044444444444444
6666666644994499446666666666cc444444444444eeffffffffff44994499446666666666666666004444444444444400444444444444440044444444444444
6666666644994499446666666666cc444444444444eeffffffffff44994499446666666666666666004444444444444400444444444444440044444444444444
66666666449999994466666666cc9999999999999999eeffffffff44999999446666666666666666004444444444444400444444444444440044444444444444
66666666449999994466666666cc9999999999999999eeffffffff44999999446666666666666666004444444444444400444444444444440044444444444444
666666664499994499cccccccc99999999999999999999eeeeeeee99449999446666666666666666000000000000000000000000000000000000000000000000
666666664499994499cccccccc99999999999999999999eeeeeeee99449999446666666666666666000000000000000000000000000000000000000000000000
66666666449999449999999999999999999999999999999999999999449999446666666666666666666666666666666666666666666666666666666666666666
66666666449999449999999999999999999999999999999999999999449999446666666666666666666666666666666666666666666666666666666666666666
66666666664499449999999999999999999999999999999999999999449944666666666666666666666666666666666666666666666666666666666633336666
66666666664499449999999999999999999999999999999999999999449944666666666666666666666666666666666666666666666666666666666633336666
66666666664499449999999999999999999999999999999999999999449944666666666666666666666666666666666666666666666666666666663333336666
66666666664499449999999999999999999999999999999999999999449944666666666666666666666666666666666666666666666666666666663333336666
66666666666644444444999999999999999999999999999999994444444466666666666666666655555555555555555555555566666666666666333333666666
66666666666644444444999999999999999999999999999999994444444466666666666666666655555555555555555555555566666666666666333333666666
66666666666666664444444444444444444444444444444444444444666666666666666666555544444444444444444444445566666666666633333333336666
66666666666666664444444444444444444444444444444444444444666666666666666666555544444444444444444444445566666666666633333333336666
66666666666666666644444466666666666666666666666644444466666666666666666655444444444444444444444444445566666666666666333333333366
66666666666666666644444466666666666666666666666644444466666666666666666655444444444444444444444444445566666666666666333333333366
66666666666666666666446666666666666666666666666666446666666666666666666655444444444444444444444444445566666666666666333333333366
66666666666666666666446666666666666666666666666666446666666666666666666655444444444444444444444444445566666666666666333333333366
66666666666666666666666666666666666666666666666666666666666666666666666666554444444444444444444444445566666666666666664444666666
66666666666666666666666666666666666666666666666666666666666666666666666666554444444444444444444444445566666666666666664444666666
66666666666666666666444444446666666666444444444444446666666666666666666666665555555555555555555555555566666666666666224444226666
66666666666666666666444444446666666666444444444444446666666666666666666666665555555555555555555555555566666666666666224444226666
6666666666666666664499aa99aa4444444444aa99aa99aa99aa4466666666666666666666666666000066666666000066666666666666666622222222226666
6666666666666666664499aa99aa4444444444aa99aa99aa99aa4466666666666666666666666666000066666666000066666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666660000666600006666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666660000666600006666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99446666666666666666666666666666666600000000666666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99446666666666666666666666666666666600000000666666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99446666666666666666666666666666666666000066666666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99446666666666666666666666666666666666000066666666666666666666666622222222226666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666666600000000666666666666666666666666222222666666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666666600000000666666666666666666666666222222666666
666666666666666666664499aa99aa99aa99aaaa99aa99aa99aa4466666666666666666666666666660000666600006666666666666666666666666666666666
666666666666666666664499aa99aa99aa99aaaa99aa99aa99aa4466666666666666666666666666660000666600006666666666666666666666666666666666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666000066666666000066666666666666666666666666666666
6666666666666666664499aa99aa99aa99aa99aa99aa99aa99aa4466666666666666666666666666000066666666000066666666666666666666666666666666

__sfx__
00010000157300c7002c7000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
00010000235301b530235300050000500005000050017500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100001253000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001753023530175300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005000014530005002a5302a50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002213714100141001413716100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
001400000000000000000000001000000000000001000000000000001000000000000001000000000000001000000000000001000000000000001000000000000001000000000000001000000000000000000000
001000000061000610006100061000610006100061000610006100061000610006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
001000000042000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
02050000071510e6011a611246112d6110f6010f6010f6010f6010f6010f6010f60110601106011060100601106010060110601106010f601006010d6010c6010b601006010a6010960109601086010860108601
000a0000060101f500137100050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
0002000000100001001913000100001000e10000100001002810000100001002f100001000010019100001000010000100001000010015100001000010000100001002910000100001001e100001000010000100
00060000317210070000700247000070000700007003e72100700007002a700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0001000005150011001c1501810015100121001110010100111000010013100191000510008100101000e1000c1000d10013100171002110000100271001b1001d10024100001000010000100001000010000100
b60500000c72015700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
100800000c5400e5401054011540135401554017540185401a5401c5401d5401f5402154023540175001a5001c5001e50021500235002550027500295002d50030500325003450037500385003b5003e5003f500
99140000050500a0500e0500e0500b050070500105000050000500405008050090500805007050050500405003050010500205004050070500c0500f0500d0500a05006050030500105000050000500005000050
991400000215004150041500315002150021500215003150061500615006150051500415003150031500215002150021500215002150031500415006150061500515004150031500215001150011500115001150
__music__
03 10114344

