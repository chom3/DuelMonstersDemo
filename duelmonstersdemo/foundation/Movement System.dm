/*
Variable Library
Variable             Purpose
--------             -------
next_move            works in conjunction with world.time to decide whether or not the player can move
move_delay           time between movements
*/

client
	var
		next_move = 0
		move_delay = 1
	Move()
		if(src.next_move < world.time)
			src.next_move = world.time+src.move_delay
			if(src.afk)
				src.afk = FALSE
				src<<"You are no longer marked as away"
			return ..()