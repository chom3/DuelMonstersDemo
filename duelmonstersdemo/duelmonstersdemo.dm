/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)


// Make objects move 8 pixels per tick when walking

mob
	step_size = 8

obj
	step_size = 8

// Instantiate all the icons
turf
	cliff
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Cliff"
	dirt
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Dirt"
	grass
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Grass"
	lava
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Lava"
		density = 1
	roof
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Roof"
		density = 1
	sand
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Sand"
	stairs
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Stairs"
	start
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Start"
	stone
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Stone"
		density = 1
	tile_1
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Tile One"
	tile_2
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Tile Two"
	water
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Water"
		density = 1
	waterfall
		icon = 'icons/turf/Turfs.dmi'
		icon_state = "Waterfall"
		density = 1

world
	turf = /turf/water

mob
	// default logic of female for tea, anybody else is yugi
	Login()
		loc = locate(/turf/start)
		if(cmptext(client.gender,"female"))
			icon = 'icons/player/tea.dmi'
		else
			icon = 'icons/player/yugi.dmi'


