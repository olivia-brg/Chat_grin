--chat grin
--par nathan, stephane, olivia

--variables

function _init()
	joueur = {
		-- position depart
		x = 544,
		y = 312,
		-- sprite
		sp = 1,
		anim = 0,
		-- points de vie
		vie = 5,
		tps_immune = 0,
		-- taille sprite
		w = 7,
		h = 7,
		flp = false,
		-- initialisation/limitation vitesse
		dx = 0,
		dy = 0,
		max_dx = 1,
		max_dy = 1.5,
		acc = 0.1,
		saut = 4,
		-- etat du joueur
		courir = false,
		sauter = false,
		chuter = false,
		glisser = false,
		atterrir = false,
	}
	
 -- competences
 init_double_saut = {
	 recuperer = false,
 	activer = false,
 }

 init_dash = {
 	recuperer = false,
 	activer = false,
 }

		-- physique
		gravite = 0.4
		friction = 0.92
	
		--respawn
		respawn={
			x = 544,
	 	y = 312,
	 }
		-- map limits
		debut_map = 0
		fin_map = 1024
		haut_map = 0
		bas_map = 512
	
		spawn_ennemi_1()
		spawn_ennemi_2()
		spawn_ennemi_3()
		spawn_ennemi_4()
		spawn_ennemi_5()
		spawn_double_saut()
		spawn_dash()
		spawn_poisson_1()
		spawn_poisson_2()
		spawn_poisson_3()
		spawn_maison()
		spawn_checkpoint_1()
		spawn_checkpoint_2()
		spawn_checkpoint_3()
		spawn_halo()
		
		temps()
		
		music(o)
		 
		-- konami code
		local code = {⬆️,⬆️,⬇️,⬇️,⬅️,➡️,⬅️,➡️}
		chsys = {}
		add_chsys(code, function() code_reussi = true end)
		 
		-- scene au lancement
		scene = "menu"
end

function _update60()
		if scene == "menu"
		  then update_menu()
		elseif scene == "game" 
		  then update_game()
		elseif scene == "mort" 
		  then update_mort()
		elseif scene == "fin"
		  then update_fin()
	 end
end

function _draw()

	if scene == "menu" 
	  then draw_menu()

	elseif scene == "game"
	  then draw_game()
	  
	elseif scene == "mort"
	  then draw_mort()
	  	
	elseif scene == "fin"
	  then draw_fin()
	end
	
end
-->8
--update and draw

function update_game()
		joueur_update()
		animation_joueur()
		update_ennemi_1()
		update_ennemi_2()
		update_ennemi_3()
		update_ennemi_4()
		update_ennemi_5()
	 update_timer()
	 update_double_saut()
	 update_dash()
	 update_poisson_1()
	 update_poisson_2()
	 update_poisson_3()
	 update_maison()
	 update_checkpoint_1()
	 update_checkpoint_2()
	 update_checkpoint_3()
	 update_halo()
	 
	
		--camera x
	 cam_x = joueur.x - 64 + joueur.w / 2
	 if cam_x < debut_map
	   then cam_x = debut_map
	 end
	 if cam_x > fin_map - 128 
	   then cam_x = fin_map - 128
	 end
	 
	 --camera y
	 cam_y = joueur.y - 64 + joueur.h / 2
	 if cam_y < haut_map 
	   then cam_y = haut_map
	 end
	 if cam_y > bas_map - 128 
	   then cam_y = bas_map - 128
	 end
	 
  camera(cam_x,cam_y)
  
  --konami code
  for c in all(chsys) do
    c:update()
  end
  
  if joueur.vie == 0 
    then scene = "mort"
		end
  
end

function draw_game()

  cls()
	
		if timer.invincible < 120
		  then
			 if (timer.invincible%20)<10
			 and timer.invincible > 15
			   then joueur.sp = 0
			   else joueur.sp=1
			 end
		end
	
		map(0, 0)
		
		if init_double_saut.recuperer
		  then
		  print("double saut\ndebloque!",970,274,0)
		end
		if init_dash.recuperer
		  then
		  print("appuie sur 🅾️\npour dash!",336,26,0)
		end
		
		--draw ennemi
		spr(ennemi_1.sp, ennemi_1.x, ennemi_1.y)
		spr(ennemi_2.sp, ennemi_2.x, ennemi_2.y)
		spr(ennemi_3.sp, ennemi_3.x, ennemi_3.y)
		spr(ennemi_4.sp, ennemi_4.x, ennemi_4.y)
		spr(ennemi_5.sp, ennemi_5.x, ennemi_5.y)
		--draw capacites
		spr(dash.sp, dash.x, dash.y)
		spr(double_saut.sp, double_saut.x, double_saut.y)

		--draw poisson
		spr(poisson_1.sp, poisson_1.x, poisson_1.y ,1,1, poisson_1.flp)
		spr(poisson_2.sp, poisson_2.x, poisson_2.y ,1,1, poisson_2.flp)
		spr(poisson_3.sp, poisson_3.x, poisson_3.y ,1,1, poisson_3.flp)
		--draw checkpoints
		spr(checkpoint_1.sp, checkpoint_1.x, checkpoint_1.y)
		spr(checkpoint_2.sp, checkpoint_2.x, checkpoint_2.y)
		spr(checkpoint_3.sp, checkpoint_3.x, checkpoint_3.y)
		--draw joueur
		spr(joueur.sp, joueur.x, joueur.y, 1, 1, joueur.flp)
	 --draw "maison"
	 spr(maison.sp, maison.x, maison.y)
	 spr(halo.sp, halo.x, halo.y)
	 --draw nuage devant "maison"
	 spr(72,528,224,4,2)
	 spr(72,544,220,4,2)
	 --draw griffes
		if (btn(❎)) and timer.griffes < 9 
		  then spr(25, griffes.x ,griffes.y,1,1, griffes.flp)
	 end
		
		--affichage point de vie
		if timer.invincible < 180 
		  then points_vie()
		end
		
end
-->8
--collisions

function collision_map(obj, direction, flag)
		--obj = table needs x,y,w,h
		--aim = left,right,up,down
	
		local x = obj.x
		local y = obj.y
		local w = obj.w
		local h = obj.h
	
		local x1 = 0
		local y1 = 0
		local x2 = 0
		local y2 = 0
	
		if direction == "left" 
				then
				x1 = x  y1 = y
				x2 = x + 1 y2 = y + h - 1
		elseif direction == "right"
				then
				x1 = x + w - 1 y1 = y
				x2 = x + w y2 = y + h - 1
		elseif direction == "up"
		  then
		  x1 = x + 2 y1 = y - 1
			 x2 = x + w - 3 y2 = y
		elseif direction == "down"
		  then
		  x1 = x + 2 y1 = y + h
			 x2 = x + w - 3 y2 = y + h
		end
	
		--pixels to tiles
		x1 /= 8
		y1 /= 8
		x2 /= 8
		y2 /= 8
	
		if fget(mget(x1, y1), flag)
		or fget(mget(x1, y2), flag)
		or fget(mget(x2, y1), flag)
		or fget(mget(x2, y2), flag)
		  then return true
		else
			 return false
		end
end

-->8
--joueur

function joueur_update()
		--physique
		joueur.dy += gravite
		joueur.dx *= friction
	
		--controles
		if btn(⬅️)
		  then
			 joueur.dx -= joueur.acc
			 joueur.courir = true
			 joueur.flp = true
		end
		
		if btn(➡️)
		  then
			 joueur.dx += joueur.acc
			 joueur.courir = true
			 joueur.flp = false
		end
	
		--slide
		if joueur.courir
		and not btn(⬅️)
		and not btn(➡️)
		and not joueur.chuter
		and not joueur.sauter
		  then
			 joueur.courir = false
			 joueur.glisser = true
		end
	
		--saut
		if btnp(⬆️,poke(0x5f5c, 255))
		and joueur.atterrir
		  then
			 joueur.dy -= joueur.saut
			 joueur.atterrir = false
			 sfx(11)
		end
		
		if joueur.sauter
		or joueur.chuter
		  then
		  if btnp(⬆️,poke(0x5f5c, 255))
			 and init_double_saut.activer
		 	and init_double_saut.recuperer
		 	  then
			   joueur.dy -= joueur.saut
		 	  init_double_saut.activer = false
		 	  sfx(11)
		  end
		end
		
		if joueur.atterrir
		  then
		  init_double_saut.activer = true
		end
		
		
		--dash
		if btnp(🅾️,poke(0x5f5c, 255))
		and init_dash.activer
		and init_dash.recuperer
		 	then
		 	timer.dash = 0
		 	joueur.max_dx = 3
		 	init_dash.activer = false
		 	sfx(16)
		 	if joueur.flp
		 	  then joueur.dx -=5
		 	else joueur.dx +=5
		 	end
		end
		
		if timer.dash > 60
		  then init_dash.activer = true
		end
		
		if timer.dash > 15
		  then	joueur.max_dx = 1
		end
		
		
		--attaque
		if btnp(❎,poke(0x5f5c, 255))
		  then
				attaque()
				sfx(15)
		end
	
		--check collision haut et bas
		if joueur.dy > 0
		  then
			 joueur.chuter = true
			 joueur.atterrir = false
			 joueur.sauter = false
			 joueur.dy = vitesse_limite(joueur.dy, joueur.max_dy)
	
			 if collision_map(joueur, "down", 0)
			   then
	  			joueur.atterrir = true
			  	joueur.chuter = false
			  	joueur.dy = 0
				
				  --verification de la tile du
				  --joueur pour eviter le glitch
				  joueur.y -= (joueur.y + joueur.h) % 8
			 end
			
		elseif joueur.dy < 0
		  then
			 joueur.sauter = true
			 if collision_map(joueur, "up", 1)
			   then
		    joueur.dy = 0
		    sfx(12)
		  end
	 end
	
		--check collision gauche droite
		if joueur.dx < 0
		  then
			 joueur.dx = vitesse_limite(joueur.dx, joueur.max_dx)
			   
			 if collision_map(joueur, "left", 1)
			   then joueur.dx = 0
			 end
		
		elseif joueur.dx > 0
		  then
			 joueur.dx = vitesse_limite(joueur.dx, joueur.max_dx)
	
	   if collision_map(joueur, "right", 1)
	     then joueur.dx = 0
	   end
  end
  
  --collision pique / respawn
  if collision_map(joueur, "down", 2)
  	then
  	joueur.x = respawn.x
  	joueur.y = respawn.y
  	joueur.vie -= 1
  	timer.invincible = 0
  	sfx(10)
  end
  		
		--stop sliding
		if joueur.glisser
		  then
			 if abs(joueur.dx) < .2
				or joueur.courir
				  then
				  joueur.dx = 0
				  joueur.glisser = false
			 end
		end
	
		joueur.x += joueur.dx
		joueur.y += joueur.dy
	
		--bord de map
		if joueur.x < debut_map
		  then joueur.x = debut_map
		end
		
		if joueur.x > fin_map - joueur.w
		  then
			 joueur.x = fin_map - joueur.w
		end
		
		if joueur.y < haut_map
		  then
			 joueur.y = haut_map
		end
		
		if joueur.y > bas_map - joueur.w
		  then
			 joueur.x = respawn.x
			 joueur.y = respawn.y
			 if timer.invincible > 120
			   then
	     joueur.vie -= 1
	     timer.invincible = 0
		  end
		end
end



function animation_joueur()

  if joueur.sauter then
		joueur.sp = 4
	elseif joueur.chuter then
		joueur.sp = 5
	elseif joueur.glisser then
		joueur.sp = 7
	elseif joueur.courir then
		if time() - joueur.anim > .1 then
			joueur.anim = time()
			joueur.sp += 1
			if joueur.sp > 6 then
				joueur.sp = 3
			end
		end
	else
		--player idle
		if time() - joueur.anim > .3 then
			joueur.anim = time()
			if time()%5>4.25 then
				joueur.sp += 1
			end
			if joueur.sp > 2 then
				joueur.sp = 1		
			end
		end
	end
end

function vitesse_limite(num, maximum)
	return mid(-maximum, num, maximum)
end

function points_vie()
  print(joueur.vie,(joueur.x)+(joueur.w/2),(joueur.y)-5,8)
end
-->8
--interaction

function attaque()
		griffes = {
	  x = 0,
	  y = 0,
	  flp = false,
	  degat = 1,
	 }

  timer.griffes = 0

		if joueur.flp
		  then
		  griffes.x = joueur.x-8
		  griffes.y = joueur.y-1
		  griffes.flp = true
 	else
		  griffes.x = joueur.x+8
		  griffes.y = joueur.y-1
 	end
end

--taper hitbox
function taper_hitbox(a,b)
 	return not (a.x > b.x + 8
  									or a.y > b.y + 8
  									or a.x + 8 < b.x
  									or a.y + 8 < b.y)
end

--ennemi update
function spawn_ennemi_1()
		ennemi_1 = {
		 sp = 15,
		 vie = 5,
		 x = 730,
		 y = 392,
	 }
end

function spawn_ennemi_2()
	ennemi_2 = {
	 sp = 15,
	 vie = 5,
	 x = 864,
	 y = 328,
 }
end

function spawn_ennemi_3()
	ennemi_3 = {
	 sp = 15,
	 vie = 5,
	 x = 112,
	 y = 88,
 }
end

function spawn_ennemi_4()
	ennemi_4 = {
	 sp = 15,
	 vie = 3,
	 x = 336,
	 y = 32,
 }
end

function spawn_ennemi_5()
	ennemi_5 = {
	 sp = 15,
	 vie = 5,
	 x = 328,
	 y = 80,
 }
end

function update_ennemi_1()

	if timer.animation%240 >=120
		then ennemi_1.x -=0.5
 		else ennemi_1.x +=0.5
 	end

 	if (btnp(❎))
 	and taper_hitbox(griffes, ennemi_1)
 			then
  		ennemi_1.vie -= griffes.degat
 	end

 	if collision_enn(joueur, ennemi_1)
 			then
  		joueur.dx  *= -10
  		joueur.dy  *= -2
  		if timer.invincible > 120
  				then
   			joueur.vie -= 1
   			timer.invincible = 0
   			sfx(0)
  		end
 	end
 	
 	if ennemi_1.vie == 0
 	  then ennemi_1.y = -10
 	end
end

function update_ennemi_2()

	if timer.animation%200 >=100
		then ennemi_2.x -=0.5
 		else ennemi_2.x +=0.5
 	end

 	if (btnp(❎))
 	and taper_hitbox(griffes, ennemi_2)
 			then
  		ennemi_2.vie -= griffes.degat
 	end

 	if collision_enn(joueur, ennemi_2)
 			then
  		joueur.dx  *= -10
  		joueur.dy  *= -2
  		if timer.invincible > 120
  				then
   			joueur.vie -= 1
   			timer.invincible = 0
   			sfx(0)
  		end
 	end
 	
 	if ennemi_2.vie == 0
 	  then ennemi_2.y = -10
 	end
end

function update_ennemi_3()

	if timer.animation%200 >=100
		then ennemi_3.x -=0.5
 		else ennemi_3.x +=0.5
 	end

 	if (btnp(❎))
 	and taper_hitbox(griffes, ennemi_3)
 			then
  		ennemi_3.vie -= griffes.degat
 	end

 	if collision_enn(joueur, ennemi_3)
 			then
  		joueur.dx  *= -10
  		joueur.dy  *= -2
  		if timer.invincible > 120
  				then
   			joueur.vie -= 1
   			timer.invincible = 0
   			sfx(0)
  		end
 	end
 	
 	if ennemi_3.vie == 0
 	  then ennemi_3.y = -10
 	end
end

function update_ennemi_4()

	if timer.animation%120 >=60
		then ennemi_4.x -=0.5
 		else ennemi_4.x +=0.5
 	end

 	if (btnp(❎))
 	and taper_hitbox(griffes, ennemi_4)
 			then
  		ennemi_4.vie -= griffes.degat
 	end

 	if collision_enn(joueur, ennemi_4)
 			then
  		joueur.dx  *= -10
  		joueur.dy  *= -2
  		if timer.invincible > 120
  				then
   			joueur.vie -= 1
   			timer.invincible = 0
   			sfx(0)
  		end
 	end
 	
 	if ennemi_4.vie == 0
 	  then ennemi_4.y = -10
 	end
end

function update_ennemi_5()

	if timer.animation%150 >=75
		then ennemi_5.x -=0.5
 		else ennemi_5.x +=0.5
 	end

 	if (btnp(❎))
 	and taper_hitbox(griffes, ennemi_5)
 			then
  		ennemi_5.vie -= griffes.degat
 	end

 	if collision_enn(joueur, ennemi_5)
 			then
  		joueur.dx  *= -10
  		joueur.dy  *= -2
  		if timer.invincible > 120
  				then
   			joueur.vie -= 1
   			timer.invincible = 0
   			sfx(0)
  		end
 	end
 	
 	if ennemi_5.vie == 0
 	  then ennemi_5.y = -10
 	end
end

function collision_enn(a,b)
  return not (a.x+1 > b.x + 7
           or a.y+1 > b.y + 7
           or a.x + 7 < b.x+2
           or a.y + 8 < b.y+2)
end


--capacites

--double saut
function spawn_double_saut()
		double_saut = {
	  sp = 11,
	  x = 1008,
	  y = 280,
	 }
end

function update_double_saut()
	 if timer.animation%60 >=30
	   then double_saut.y -=0.05
	 else double_saut.y +=0.05
	 end
	 
  if (btnp(❎))
  and taper_hitbox(griffes, double_saut)
    then
		  double_saut.y = -50
		  init_double_saut.activer = true
		  init_double_saut.recuperer = true
 	  sfx(14)
 	end
end

-- dash
function spawn_dash()
		dash = {
	  sp = 65,
	  x = 336,
	  y = 32,
	 }
end

function update_dash()

  if (timer.animation%75) < 15
	   then dash.sp = 64
	 elseif (timer.animation%75) < 30
	   then dash.sp = 65
	 elseif (timer.animation%75) < 45
	   then dash.sp = 66
	 elseif (timer.animation%75) < 60
	   then dash.sp = 67
	 end

	 if (btnp(❎))
  and taper_hitbox(griffes, dash)
			 then
			 dash.y = -50
			 init_dash.activer = true
		  init_dash.recuperer = true
		  sfx(14)
	 end
end

--poisson (recuperation vie)

function spawn_poisson_1()
		poisson_1 = {
	  sp = 126,
	  x = 693,
	  y = 312,
	  flp = false
	 }
end
function spawn_poisson_2()
	poisson_2= {
  sp = 126,
  x = 68,
  y = 112,
  flp = false
 }
end
function spawn_poisson_3()
	poisson_3 = {
  sp = 126,
  x = 456,
  y = 80,
  flp = false
 }
end


function update_poisson_1()

  if (timer.animation%180)<15
	   then poisson_1.y -= 0.5
	 elseif (timer.animation%180)<30
	   then poisson_1.y += 0.5
	 end
	 
	 if (timer.animation%360) == 5
	   then poisson_1.flp = not poisson_1.flp
	 end

	 if (btnp(❎))
  and taper_hitbox(griffes, poisson_1)
			 then
			 poisson_1.y = -50
			 joueur.vie += 1
			 timer.invincible = 0
			 sfx(14)
	 end
end

function update_poisson_2()

	if (timer.animation%180)<15
		 then poisson_2.y -= 0.5
	  elseif (timer.animation%180)<30
		 then poisson_2.y += 0.5
	  end
	  
	  if (timer.animation%360) == 5
		 then poisson_2.flp = not poisson_2.flp
	  end
 
	  if (btnp(❎))
	and taper_hitbox(griffes, poisson_2)
			  then
			  poisson_2.y = -50
			  joueur.vie += 1
			  timer.invincible = 0
			  sfx(14)
	  end
 end

 function update_poisson_3()

	if (timer.animation%180)<15
		 then poisson_3.y -= 0.5
	  elseif (timer.animation%180)<30
		 then poisson_3.y += 0.5
	  end
	  
	  if (timer.animation%360) == 5
		 then poisson_3.flp = not poisson_3.flp
	  end
 
	  if (btnp(❎))
	and taper_hitbox(griffes, poisson_3)
			  then
			  poisson_3.y = -50
			  joueur.vie += 1
			  timer.invincible = 0
			  sfx(14)
	  end
 end

--checkpoint
function spawn_checkpoint_1()
		checkpoint_1 = {
	  sp = 10,
	  x = 484,
	  y = 272,
	 }
end
function spawn_checkpoint_2()
		checkpoint_2 = {
	  sp = 10,
	  x = 320,
	  y = 8,
	 }
end
function spawn_checkpoint_3()
		checkpoint_3 = {
	  sp = 10,
	  x = 352,
	  y = 176,
	 }
end

function update_checkpoint_1()
		if (btnp(❎))
  and taper_hitbox(griffes, checkpoint_1)
   then
		  checkpoint_1.sp = 12
		  respawn.x = 484
		  respawn.y = 272
 	  sfx(14)
 	end
end
function update_checkpoint_2()
	if (btnp(❎))
and taper_hitbox(griffes, checkpoint_2)
then
	  checkpoint_2.sp = 12
	  respawn.x = 320
	  respawn.y = 8
	sfx(14)
 end
end
function update_checkpoint_3()
	if (btnp(❎))
and taper_hitbox(griffes, checkpoint_3)
then
	  checkpoint_3.sp = 12
	  respawn.x = 352
	  respawn.y = 176
	sfx(14)
 end
end

--maison (fin du jeu)

function spawn_maison()

  maison = {
	  sp = 80,
	  x  = 545,
	  y  = 225,
	 }
	
end

function update_maison()

	 if collision_enn(joueur, maison)
	   then scene = "fin"
	 end
	 
end

function spawn_halo()
  halo = {
	  sp = 79,
	  x  = 568,
	  y  = 224,
	 }
end

function update_halo()
	 if timer.animation%90 >=45
	   then halo.x -=0.07
	 else halo.x +=0.07
  end
end
-->8
--konami code

local code_reussi = false

function add_chsys(code, callback)
  add(chsys, {
    cnt = 1,
    code = code,
    update = function(self)
      if self.cnt <= #self.code then
        for i = 0, 5 do
          if btnp(i) then
            if i == self.code[self.cnt] then
              self.cnt += 1
            else
              self.cnt = 1
            end
          end
        end
      else
      init_double_saut.activer = true
		    init_double_saut.recuperer = true
		    joueur.vie = 99
		    init_dash.recuperer = true
		    init_dash.activer = true
		    timer.dash = -999999
		    --[[gravite = 0
		    if btn(⬇️)
	 	     then
    			 joueur.dy += joueur.acc
	    		 joueur.courir = true
	    	end
	    	
	    	if btn(⬆️)
	 	     then
    			 joueur.dy -= joueur.acc
	    		 joueur.courir = true
	    	end]]--
		    
      end
    end,
  })
end
-->8
--timer

function temps()
	 timer = {
		 griffes = 60,
		 invincible = 0,
		 dash = 0,
		 animation = 0,
	 }
end

function update_timer()
	 timer.griffes += 1
	 timer.invincible +=1
	 timer.dash +=1
	 timer.animation +=1
	 
	 
	 --chronometre pour ecrans de fin
	 mnt = flr(timer.animation/3600)
	 scd = flr((timer.animation/60)%60)
	 
	 minutes = tostr(mnt)
	 secondes = tostr(scd)
  
  if #minutes == 1
	   then minutes ="0"..minutes
	 end
	 
  if #secondes == 1
	   then secondes ="0"..secondes
	 end
	 
	 timer_fin = minutes ..":" ..secondes 
	 
end

-->8
--scenes

--menu
function draw_menu()
	 cls()
	 map(0, 0)
	 rectfill(507,270,587,300,15)
	 
	 rect(508,271,588,300,133)
	 --rect(509,272,588,300)
	 rect(506,269,588,301,4)
	 rect(507,270,587,300,4)
	 
	 --[[print(titre, hcenter(titre)+483,275,128)
		print(sous_titre, hcenter(sous_titre)+483,285)
		print(sous_titre2, hcenter(sous_titre2)+483,293)]]--
		
	 print(titre, hcenter(titre)+483,274,132)
		print(sous_titre, hcenter(sous_titre)+483,284)
		print(sous_titre2, hcenter(sous_titre2)+483,292)

		if time()%1.5<.75
		  then
		  print(text_demarrer1,hcenter(text_demarrer1)+483 ,361,7)
		  print(text_demarrer2,hcenter(text_demarrer2)+483 ,369)
		end
		
		spr(joueur.sp, 544, 312, 1, 1, joueur.flp)
end

function update_menu()
  _init()
  camera(483,252)
	 if btnp(🅾️, poke(0x5f5c, 255)) 
	   then scene = "game"
	 end
end

--mort
function draw_mort()
	 cls()
	 
	 rectfill(0,0,127,127,0)
	 
	 print(text_mort, hcenter(text_mort),54,130)
	 print(text_mort2, hcenter(text_mort2),62)
  print(timer_fin, hcenter(timer_fin),70)
  print(text_menu1, hcenter(text_menu1), 111)
  print(text_menu2, hcenter(text_menu2), 119)
	 
	 print(text_mort, hcenter(text_mort),53,136)
	 print(text_mort2, hcenter(text_mort2),61)
  print(timer_fin, hcenter(timer_fin),69)
  
  if time()%1.5<.75
		  then
    print(text_menu1, hcenter(text_menu1), 110)
    print(text_menu2, hcenter(text_menu2), 118)
  end
  
end

function update_mort()

  camera(0,0)
	 if btnp(🅾️, poke(0x5f5c, 255)) 
	   then scene = "menu"
  end
end

--fin
function draw_fin()
	 cls()
	 
	 rectfill(0,0,127,127,7)
	 
	 spr(72,20,40,4,2)
	 spr(72,70,90,4,2)
	 spr(72,12,100,4,2)
	 spr(72,60,25,4,2)
	 spr(72,75,19,4,2)
	 spr(72,38,84,4,2)
	 spr(72,100,34,4,2)
	 spr(72,77,95,4,2)
	 spr(72,76,18,4,2)
	 spr(72,98,6,4,2)
	 spr(72,29,51,4,2)
	 spr(72,42,22,4,2)
	 spr(72,55,33,4,2)
	 spr(72,16,46,4,2)
	 spr(72,8,0,4,2)
	 spr(72,70,112,4,2)
	 
	 print(text_victoire1, hcenter(text_victoire1),53,12)
		print(timer_fin, hcenter(timer_fin),61)
		print(text_victoire2, hcenter(text_victoire2),69)
		print(text_victoire3, hcenter(text_victoire3),77)
		
		if time()%1.5<.75
		  then
		  print(text_menu1, hcenter(text_menu1), 110)
    print(text_menu2, hcenter(text_menu2), 118)
  end
end

function update_fin()

  camera(0,0)
 
	 if btnp(🅾️, poke(0x5f5c, 255)) 
	   then scene = "menu"
  end
end
-->8
--text menus

--[[fonction pour centrer
  une chaine de charactere]]--
function hcenter(s)
  return 64-#s*2
end

titre = "grain"
sous_titre = "a la recherche"
sous_titre2 = "d'un foyer"

text_demarrer1 = "appuie sur 🅾️ "
text_demarrer2 = "pour lancer le jeu!"

text_menu1 = "appuie sur 🅾️ "
text_menu2 = "pour retourner au menu"

text_mort = "oh non!"
text_mort2 = "tu as abandonne grain..."

text_victoire1 = "felicitations! il t'aura fallu"
text_victoire2 = "pour aider le chat grain"
text_victoire3 = "dans son periple"