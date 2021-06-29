/*
Variable Library
Variable          Purpose
--------          -------
allow_multikey    TRUE will allow players to multi-key
number_players    represents how many players are connected to the game
*/

var/allow_multikey = FALSE //default: don't allow multi-keying
var/number_players = 0

client
	New()
		if(!allow_multikey)
			for(var/client/c)
				if(c != src && c.computer_id == src.computer_id)
					src<<"Multikeying is now allowed"
					del src
		..()
		number_players ++
		world.status = "[world.name] ([number_players] players connected)"
	Del()
		world<<"[src.key] has disconnected from the game"
		number_players --
		world.status = "[world.name] ([number_players] players connected)"
		..()