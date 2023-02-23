pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--init

function _init()
	create_player()
	enemies={}
	spawn_zombie(20,20)
	spawn_robot(60,60)
	init_msg()
end

function _update()
	if #messages==0 then
	player_mouvement()
	end
	update_zombie()
	update_robot()
	new_camera()
	update_msg()
end 

function _draw()
cls()
	 draw_map()
  draw_player()
 -- ennemis
 	draw_zombie()
 	draw_robot()

		draw_ui()
		draw_msg()
end
-->8
--map

function draw_map()
	map (0,0,0,0,128,64)

end

--check collision

function check_flag(flag,x,y)
	local sprite=mget(x,y)
	return fget(sprite,flag)
end

-- sprite switch pour la cle

function next_tile(x,y)
	local sprite=mget(x,y)
	mset(x,y,sprite+1)
end

--ramasser cle

function pick_up_key(x,y)
	next_tile(x,y)
	p.keys+=1
	sfx(1)
end

--ouvrir porte

function open_door(x,y)
	next_tile(x,y)
	p.keys-=1
	sfx(2)
end


-->8
--players

function create_player()
	p={x=6,y=4,sprite=2,keys=0}
end

function player_mouvement()
	newx=p.x
	newy=p.y
	if (btnp(➡️)) newx+=1
	if (btnp(⬅️)) newx-=1
	if (btnp(⬇️)) newy+=1
	if (btnp(⬆️)) newy-=1

	interact(newx,newy)
	
	--collision obstacles

 if not check_flag(0,newx,newy) 
then  p.x=mid(0,newx,127)
      p.y=mid(0,newy,63)
 end
end

--ramassage de cle

function interact(x,y)
	if check_flag(1,x,y) then
		pick_up_key(x,y)
	elseif check_flag(2,x,y) 
	and p.keys>0 then
		open_door(x,y)
	end
end

--sprite joueur

function draw_player()
	palt(15, true)
	palt(0, false)
	spr(p.sprite,p.x*8,p.y*8)
	
end
-->8
--camera

function update_camera()
	camx=mid(0,p.x-7.5,31-15)
	camy=mid(0,p.y-7.5,31-15)
	camera(camx*8,camy*8)
end
 
--camera section
 
function new_camera()
 camx=flr(p.x/16)*16
 camy=flr(p.y/16)*16
 camera(camx*8,camy*8)
end
-->8
-- user interface

--nombres de cle ui
function draw_ui()
	camera()
	palt(0,false)
	palt(12,true)
	spr(80,2,2)
	palt()
	print_outline("X"..p.keys,10,2)
end

--surbrillance noir cle

function print_outline(text,x,y)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	print(text,x,y,7)	
end
-->8
-- messages pnj

function init_msg()
	messages={}
	create_msg()
end

--boite de dialogue

function create_msg(name,...)
	msg_title=name
	messages={...}
end

--bouton message suivant

function update_msg()
	if btnp(❎) then
		deli(messages,1)
	end
end

--emplacement boite de dialogue

function draw_msg()
	if messages[1] then
		local y=100
		if p.y%16>=9 then
		y=10
		end
		--titre
		rectfill(7,y-65,10+#msg_title*4,y-71,2)
		print (msg_title,9,y-70,10)
		--message
		print(messages[1],35,50,0)
	end
end
-->8
-- zombie

--

function spawn_zombie(a,b)
	zombie={
	x=a,
	y=b,
	life=5,
	direction="droite",
	type="zombie"
	}
	add(enemies,zombie)
end



function update_zombie()

	for e in all(enemies) do
	if e.type=="zombie" then
		if e.direction=="droite" then
			e.x+=1
		else
			e.x-=1
		end
		if e.x>=64 and e.direction=="droite" then
			e.direction="gauche"
		end
		if e.x<=8 and e.direction=="gauche" then
			e.direction="droite"
		end
	end
	end 
end

function draw_zombie()
	for e in all(enemies) do
		if e.type=="zombie" then
			spr(112,e.x,e.y)
		end
	end
end
-->8
-- robot

function spawn_robot(a,b)
	robot={
	x=a,
	y=b,
	life=5,
	direction="haut",
	type="robot"
	}
	add(enemies,robot)
end


function update_robot()
	for e in all(enemies) do
	if e.type=="robot" then
		if e.direction=="haut" then
			e.y+=1
		else
			e.y-=1
		end
		if e.y>=50 and e.direction=="haut" then
			e.direction="bas"
		end
		if e.y<=15 and e.direction=="bas" then
			e.direction="haut"
		end
	end
	end 
end

function draw_robot()
	for e in all(enemies) do
		if e.type=="robot" then
			spr(113,e.x,e.y)
		end
	end
end
 
__gfx__
0000000033333333ff9888ff3333333333333333444444444444444411111114111111114444444441111111333333344ddddddd111111144111111115444451
0000000033333333888888883bbbbbb333333933ddddddddddddddd41111111d111111114ddddddd41111111333333344111111111111114d111111116ffff61
0070070033333333f04040ffbaab331133339a931111111111111114111111111111111141111111411111113333333441111111111111141111111115444451
0007700033333333f00444ffba443110333339331111111111111114111111111111111141111111411111113333333441111111111111141111111115444451
0007700033333333f0099affbb34310033c333331111111111111114111111111111111141111111411111113333333441111111111111141111111115444451
0070070033333333fa099aff3bb410033cac33331111111111111114111111111111111141111111411111113333333441111111111111141111111116ffff61
0000000033333333f41114ff3334433333c333331111111111111114111111111111111141111111411111113333333441111111111111141111111115444451
0000000033333333ff1f1fff34444433333333331111111111111114111111111111111141111111411111114444444441111111111111141111111115444451
33333333333333333333333333333333744443b33544444b333333333b45444b3333333333333333333333333333333333333333454444543333333333333333
33338333333333333333333333333333b444444b3b4444bb363333b56b444443333b333bbb6bb333333333333333333333b33333d6ffff6d33333bb33bbbbbb3
533883635555555555f33333333335553344444bb444444bb4b3bb4b444444b333b44bb444b544b3333333333b3b333333fbb3331544445133333bb3b8bb3380
33898833dddddddddf5f33333333ddddb34444b3b344444444444433444444b33b4444344444443b3333333333b333333bbb333315444451333b3333bb334410
34899845444444444f5f333333334444b54444b33b344444444444444444444b3b4544444444444b3333b33333333b3b333b33331544445133333333bb384100
338a9833444444444f5f3333333344443b4444333344444444444444444b444333b44444444444bb37b44b33333333b3333333b316ffff613333333333b44033
644884434444444444f3333333333444b44444b33bbb443334444444b4b3bb533b344444b4444343345444433b3b33333333333315444451b333b33333444333
333443353333333333333333333333333b744346333b4b5bbb4b4b33bb3333333b34444bb44443b5b444444533b33333333b3333154444513333333334444433
33311133aaaaaaaaaaabbeaaaafaffaaaaaa9aaaaaaaaaa9aaaaaaaa799aa9aaa3aa3aaaaaaaaaaa333aaaaa33a33aaaaaaaaaaaa59aa69aaa95aa9aaaaaaaaa
33313133aaaaaaaaaa0beeeaaa3ff3aa9a99aa9a9a9aa99a4aaaa44aa99a699a33a3aaaaaaaaaaaa33aaa3aa3a33a33aa6aaaaa5a99aa99a6a99aa9aaaaaaaaa
32111103aaaaaaaaaa3b3eaba0b33b3aa99a999aa999aa9aa44a44aaa9aaaa9a3aaaaaaaaaaaaaaa33aaaa3a33aaaaaa99aaaa99a99aa99a999aaa9aaaa99969
23111103aaaaaaaaaa303bb33b3bb303aa9a9aaa99aaa99aaa444aaaa99aa99a333aaaaa3a3a3aaa33a3aaaa33a33aaa59999969a9aaaa99aaaaaa9aaa9999a9
21011100aaaaaaaaba3b3b300b30b3b09a9a9a9aa99aa999aaa44a4aa59aa9aa33aaaaaaa33a33aa3333a3aa3333aaaaaaaaaaaaa99aaaaa6aaa999aaa95aaaa
21100010aaaaaaaa0bbb3baa3b3bb3b3aaa999aaa9aa99aaa44444aaaa9aa9aa3a3aaaaa3aaaaa3a33aa333333aaaa3aaaaaaaaaaa9aaaaa9999999aaa99aaaa
31111110aaaaaaaa33bb3baaa3b33b3aa99aaa9aa9a9a99aaa444aaaa99aa99a333aaaaa3333aaaa3333a3aa33aaa3aa7a9aaa99a59999aa99aaaa5aaa9aaa59
32111103aaaaaaaaaabb30aaaa30b3aaaa9a9a9aaaa9aaaaa9a449a9a97aa9963aaaaaaa3333a3aa3333a33333aaaaaa99999996aaaa9959aaaaaaaaaa9aaa99
aaaaaaaa66670765a8a00aaaa95aa99a44444244aa00a8aa54475044444442444444424411cc1111444442440000000000000000000000000000000000000000
aa6aaaaa55560655a80660aaaa9aa9aa44444244a06608aa5466504400000000444442441c77c111400000000000000000000000000000000000000000000000
999599aa55550555a064460a6a9aa99a44444244064460aa56745044666666664444424417117111666666660000000000000000000000000000000000000000
99aa999a0000000006444460999aaa99222222226444460056225022555555552222222211111cc1555555550000000000000000000000000000000000000000
aaaaaa9a56667075644444469aaaaaaa4424444444aa44665427504455555555442444441111c77c555555550000000000000000000000000000000000000000
aaaaa99a5555606544499444aaaaaaaa44244444444444445466504455555555442444441cc17117555555550000000000000000000000000000000000000000
95aaa99a555550554a499444aa9a99994424444444994444566450440000000044244444c77c1111400000000000000000000000000000000000000000000000
999aa995000000004449944499999596222222224499444457225022222222222222222271171111222222220000000000000000000000000000000000000000
33333333333333330144444104444100777070074444424444444244000000000000000000000000000000000000000000000000000000000000000000000000
3b3333333b3333330405050401445450707077074444424444444244000000000000000000000000000000000000000000000000000000000000000000000000
33333933333333330405050404455450777077774444494444444244000000000000000000000000000000000000000000000000000000000000000000000000
37aaa3933333333304050504044544507000707727aaa29222222222000000000000000000000000000000000000000000000000000000000000000000000000
3a333933333333330444444404444450700070074a24494444244444000000000000000000000000000000000000000000000000000000000000000000000000
333bb333333bb3330444449404444450005555004424444444244444000000000000000000000000000000000000000000000000000000000000000000000000
333bb3b3333bb3b30444444404444100000050004424444444244444000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333330144444101444000005550002222222222222222000000000000000000000000000000000000000000000000000000000000000000000000
cc0ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0a0000c000000000666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0aaaa0600000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0a000a0600000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc0ccc0c060660600666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc060660600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc006006000666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3c111133333333334444424400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccc1113344420030444200400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc0f0f13344444036444440600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3cffffc3345545235455452500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
35050533344444235444444500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
35000533333423335554255500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3f000f3333b423b30004200400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33030333333333332222222200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888ffffff882222228888888888888888888888888888888888888888888888888888888888888888228228888ff88ff888222822888888822888888228888
88888f8888f882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888222822888882282888888222888
88888ffffff882888828888888888888888888888888888888888888888888888888888888888888882288822888f8ff8f888222888888228882888888288888
88888888888882888828888888888888888888888888888888888888888888888888888888888888882288822888ffffff888888222888228882888822288888
88888f8f8f88828888288888888888888888888888888888888888888888888888888888888888888822888228888ffff8888228222888882282888222288888
888888f8f8f8822222288888888888888888888888888888888888888888888888888888888888888882282288888f88f8888228222888888822888222888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555550000000000000000000000000000007777777777775555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227000000000075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550333333333333333399999999888888888888888888888888333333333333333305555550000000000011111111112222222227033333333075555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550000000000011111111112222222227000000000075555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666667777777777775555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550888888888888888888888888888888888888888888888888888888888888888805555550444444444455555555556666666666777777777705555555
55555550333333330000000044444444000000004444444400000000333333333333333305555550444444444455555555556666666666777777777705555555
55555550333333330000000044444444000000004444444400000000333333333333333305555550444444444455555555556666666666777777777705555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000004444444400000000444444440000000033333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000000000000044444444444444444444444433333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000000000000044444444444444444444444433333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
5555555033333333000000000000000044444444444444444444444433333333333333330555555088888888889999999999aaaaaaaaaabbbbbbbbbb05555555
55555550333333330000000000000000444444444444444444444444333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550333333330000000000000000444444444444444444444444333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550333333330000000000000000444444444444444444444444333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550333333330000000000000000444444444444444444444444333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
55555550333333330000000000000000444444444444444444444444333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555550ccccccccccddddddddddeeeeeeeeeeffffffffff05555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555550000000000000000000000000000000000000000005555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555555555555555555555555555555555555555555555555555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555555555555555555555555555555555555555555555555555555
555555503333333300000000000000009999999999999999aaaaaaaa333333333333333305555555555555555555555555555555555555555555555555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555550000000555556667655555555555555555555555555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555550000000555555666555555555555555555555555555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa33333333333333330555555000000055555556dddddddddddddddddddddddd5555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa3333333333333333055555500030005555555655555555555555555555555d5555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555550000000555555576666666d6666666d666666655555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555550000000555555555555555555555555555555555555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555550000000555555555555555555555555555555555555555555
5555555033333333aaaaaaaa000000009999999999999999aaaaaaaa333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555556665666555556667655555555555555555555555555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555556555556555555666555555555555555555555555555555555
5555555033333333444444441111111111111111111111114444444433333333333333330555555555555555555556dddddddddddddddddddddddd5555555555
555555503333333344444444111111111111111111111111444444443333333333333333055555565555565555555655555555555555555555555d5555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555556665666555555576666666d6666666d666666655555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333334444444411111111111111111111111144444444333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333333333333311111111333333331111111133333333333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333333333333311111111333333331111111133333333333333333333333305555555555555555555555555555555555555555555555555555555
55555550333333333333333311111111333333331111111133333333333333333333333305555550005550005550005550005550005550005550005550005555
555555503333333333333333111111113333333311111111333333333333333333333333055555011d05011d05011d05011d05011d05011d05011d05011d0555
55555550333333333333333311111111333333331111111133333333333333333333333305555501110501110501110501110501110501110501110501110555
55555550333333333333333311111111333333331111111133333333333333333333333305555501110501110501110501110501110501110501110501110555
55555550333333333333333311111111333333331111111133333333333333333333333305555550005550005550005550005550005550005550005550005555
55555550333333333333333311111111333333331111111133333333333333333333333305555555555555555555555555555555555555555555555555555555
55555550000000000000000000000000000000000000000000000000000000000000000005555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
555555555555575555555ddd55555d5d5d5d55555d5d555555555d5555555ddd5555553398883355555555555555555555555555555555555555555555555555
555555555555777555555ddd55555555555555555d5d5d55555555d55555d555d555558888888856666666666666555557777755555555555555555555555555
555555555557777755555ddd55555d55555d55555d5d5d555555555d555d55555d55553040403356ddd6ddd6ddd6555577ddd775566666555666665556666655
555555555577777555555ddd55555555555555555ddddd5555ddddddd55d55555d55553004443356d6d6d6d666d6555577d7d77566dd666566ddd66566ddd665
5555555557577755555ddddddd555d55555d555d5ddddd555d5ddddd555d55555d555530099a3356d6d6d6d6ddd6555577d7d775666d66656666d665666dd665
5555555557557555555d55555d55555555555555dddddd555d55ddd55555d555d555553a099a3356d6d6d6d6d666555577ddd775666d666566d666656666d665
5555555557775555555ddddddd555d5d5d5d555555ddd5555d555d5555555ddd5555553411143356ddd6ddd6ddd655557777777566ddd66566ddd66566ddd665
55555555555555555555555555555555555555555555555555555555555555555555553313133356666666666666555577777775666666656666666566666665
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555566666665ddddddd5ddddddd5ddddddd5
00000000000000077777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333073398883370333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333078888888870bbbbb3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007003333330730404033703b34bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333073004443370b444bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770003333330730099a3370a44b33000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333073a099a3370344333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333073411143370344333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333073313133370444433000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000077777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__gff__
0000000100010101010101000101010001010000000000000000000000000001000001010000010000000000000000000001010000010100000000000000000002000500000200000000000000000000000000000000000000000000000000000101010000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
031f0104011b031f031f1f1f1f1f1f1e1f1f1f1f1f1f1f1f0103030101401f01282524242125242424212421212425212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
1f0401200101011f1f031f1f1f1f031f1f1f1f1f031f1f0303030101011f1f1f282524212224242424242521252125242121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
1b011001011c011b1f031b1f030303031f030303031f1f0303030101031f03012a2924212121212321212426252125212424212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
011311120101011f1f1f1f1f011f1f1f1c1f0401010301010301010303030303012821212424212121222124252625242121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
1f1c1b011b611a031f010144031b0101010101011e010101011e010303011f03012823212125212121212126212124212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0103031f1f041401011b0101010101010118161616161901010101011c1f1f1f012821212421212626212525252125242121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
03030303031f1516161616161616161616170101313142313101010401030303042a29252422212426242525242424242121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
031b1f1f030303011c031f0101011f011f03030109051d0505060101011f0303010128252424242524242123212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0303031f1b03031f1f1f03031c031b1f1f1f1b090e080f0808390d011c1f0303030328212426212425252125212125212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0103031f1f1f1f031f1c031f1f1f03030101090e0801011c0808390d011f011f1f0328212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
031f1b031f1f1b1f03040303031f1f0109050e0d1e01010104080808081f1f03030328212121252121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
1f010101010101030303031b0303031c0a390d01010161011b080839081f0303042b21212121212525252521212525252121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
040905050505060101030301010101010a080d1c0401010101390808081c1f1f012821212424212121252521212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
090e080839080706011e011b010905050e08390d0101011e0808080d1f1f01032b2521242421242121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
0a3908011b0a390705050505050e390808080808080f08080808080d1f011f03282125212521212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
04011c011c010a0808390808080808080d040401390f080d1e03011f03031f1c282121212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
011b0101041e010101010101010101031f1f1f1e1b01011c0101041f03030101282124212421212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
01010101313131313131313131313101010303031e011b01031f030303031f1f2a2921212124212421252521212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
3131313131313434343434343431313131313131310131313101031f1f031f03012821252521212525212121252121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313134343436345234523452343431313434313134343434311b041f1f1f1f1c1f2821212525212521212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313134443436343434343434343431343434343134513434311b01011c011f031f2a29212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
3131343434343a37373737373737373737623442343434343101010401520140030128213521212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313134343436343434343434343431343434343134343434341e010101010303030328212121212121352121212135212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
314534343436343434343434343431313434313134343434311b1c011b011e03010328212121213221212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
3131314231313434343434343431313131313131313131313131313131313131313131292132212121322132213521212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
31313434343131313131313131313101011c0101011b01010101010401010118161616282c2c2c2c21212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
3134343434343101010101011b010401011b01131112010104011c01011c0114010161282121212121212135212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313434343434310101010101010101010101600101011b1b0101010101010114010103212121212135212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313434343434341616161616161616161601011b100161010116161616161617010328212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313434343434310101010101010101011b010101010101010101010101011f031f0328212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313134343431310101010101011c010101010113111201010101011f1f031f031f2b21212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
313131313131310101011b010101010101011c0101010101010403031f030103032821212121212121212121212121212121212121212121212121212121212101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000100501805020050240501b000220002000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002a0502205019050110501c00023000270002a0002d0003000031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
