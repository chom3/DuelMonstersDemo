/*
Variable Library
Variable          Purpose
--------          -------
list/guilds       a list that stores every single guild that is created
guild_save        directory in which all guilds will be saved

accept_inv        specifies whether or not a player will automatically decline guild invitations

myGuild           reference to the person's guild

leader            the guild leader's key
list/members      a list of keys of the members of the guild
name              the name of the guild
tagg              a shorthand notation for the guild

Proc Library
Proc              Purpose
----              -------
save_guild        saves all guilds to the guild_save directory
load_guild        loads all guilds into the guilds list from the guild_save directory, if it exists

inGuild           returns the guild in which a key belongs

Verb Library
Verb              Purpose
----              -------
toggle_invite     toggles the player's accept_inv variable between TRUE and FALSE
create_guild      allows the player to create a guild if they do not belong to one

disband           allows guild leader to disband (delete) the guild if there are no other members
invite            allows guild leader to invite new members to his/her guild
kick              allows guild leader to remove a member from the members list
give_leader       allows guild leader to pass leadership to another player
leave             allows guild members to leave the guild
view_members      allows guild members to view the members list
*/

var
	list/guilds
	guild_save = "saves/guilds.rofl"

proc
	save_guild()
		if(fexists(guild_save))
			fdel(guild_save)
		var/savefile/s = new(guild_save)
		s["guilds"] << guilds
	load_guild()
		if(fexists(guild_save))
			var/savefile/s = new(guild_save)
			s["guilds"] >> guilds

world/New()
	..()
	load_guild()

mob
	pl
		var
			accept_inv = TRUE

client
	var
		guild/myGuild
	proc
		inGuild()
			for(var/guild/g in guilds)
				if(src.key in g.members)
					return g
	verb
		toggle_invite()
			var/mob/pl/m = src.mob
			if(m.accept_inv)
				m.accept_inv = FALSE
				m<<"You are no longer accepting guild invitations"
			else
				m.accept_inv = TRUE
				m<<"You are now accepting guild invitations"
		create_guild()
			set category = "Guild"
			if(src.myGuild)
				src<<"BUG! You should not have this verb"
				src.verbs -= /client/verb/create_guild
			else
				var/gName = input(src,"Name your guild","Create Guild") as null|text
				if(gName)
					for(var/guild/g in guilds)
						if(lowertext(g.name) == lowertext(gName))
							src<<"That name has already been used"
							return
					var/gTag = input(src,"Give your guild a tag (max: 4 characters)","Create Guild") as null|text
					if(gTag)
						if(length(gTag) > 0 && length(gTag) < 5)
							for(var/guild/G in guilds)
								if(lowertext(G.tagg) == lowertext(gTag))
									src<<"That tag has already been used"
									return
						else
							src<<"A guild tag must be 1-4 characters long"
							return
						new /guild(gName,gTag,src.mob)
	New()
		..()
		var/guild/g = src.inGuild()
		if(g)
			src.myGuild = g
			src<<"Guild found"
			if(g.leader == src.key)
				src.verbs += typesof("/guild/leader/verb")
			src.verbs += typesof("/guild/verb")

guild
	var
		mob/pl/leader
		list/members
		name
		tagg
	New(n,t,mob/pl/a)
		src.name = n
		src.tagg = t
		src.leader = a.key
		src.members = new
		src.members += a.key
		a.client.myGuild = src
		a.verbs -= /client/verb/create_guild
		a.verbs += typesof("/guild/verb")
		a.verbs += typesof("/guild/leader/verb")
		a<<"<u>[src.name]</u> {[src.tagg]} has been created"
		if(!guilds) guilds = new
		guilds += src
		save_guild()
	Del()
		guilds -= src
		world<<"[src.name] \[[src.tagg]] has been disbanded"
		if(guilds && !guilds.len)
			guilds = null
			fdel(guild_save)
		else save_guild()
		..()
	leader/verb
		disband()
			set category = "Guild"
			var/client/c = usr.client
			if(c)
				var/guild/g = c.myGuild
				if(g)
					if(g.members.len == 1)
						c.myGuild = null
						c.verbs -= typesof("/guild/leader/verb")
						c.verbs -= typesof("/guild/verb")
						del g
					else usr<<"You cannot disband a guild that has other members"
		invite()
			set category = "Guild"
			var/list/L = new
			for(var/client/c)
				var/mob/pl/m = c.mob
				if(!c.myGuild && m.accept_inv)
					L += m
			if(L.len)
				var/mob/pl/m = input(usr,"","Guild Invite") as null|anything in L
				if(m)
					var/client/c = usr.client
					if(alert(m,"[usr.name] has invited you to join [c.myGuild.name] \[[c.myGuild.tagg]]. Accept?","Guild Invitation","Yes","No") == "Yes")
						c<<"[m.name] accepted the guild invitation"
						var/client/cli = m.client
						cli.myGuild = c.myGuild
						c.myGuild.members += cli.key
						cli.verbs += typesof("/guild/verb")
						cli.verbs -= /client/verb/create_guild
					else c<<"[m.name] declined the guild invitation"
			else usr<<"No one online is eligible to be invited"
		kick()
			set category = "Guild"
			var/client/c = usr.client
			var/guild/g = c.myGuild
			var/list/L = g.members.Copy()
			var/k = input(c,"","") as null|anything in L
			if(k)
				if(alert(c,"Are you sure you would like to kick [k] from [g.name] \[[g.tagg]]?","Guild Kick","Yes","No") == "Yes")
					g.members -= k
					for(var/client/cli)
						if(cli.key == k)
							cli.verbs -= typesof("/guild/verb")
							cli.verbs += /client/verb/create_guild
							cli<<"You have been kicked from <u>[g.name]</u> \[[g.tagg]]"
		give_leader()
			set category = "Guild"
			var/client/c = usr.client
			var/guild/g = c.myGuild
			var/list/L = g.members.Copy()
			L -= g.leader
			var/k = input(c,"","Give Guild Leadership") as null|anything in L
			if(k)
				c.verbs -= typesof("/guild/leader/verb")
				g.leader = k
				for(var/client/cli)
					if(cli.key == k)
						cli.verbs += typesof("/guild/verb")
	verb
		leave()
			set category = "Guild"
			var/client/c = usr.client
			var/guild/g = c.myGuild
			if(g.leader == c.key && g.members.len > 1)
				c<<"You must give guild leadership to someone else first"
			else
				g.members -= c.key
				c.verbs -= typesof("/guild/verb")
				c.verbs -= typesof("/guild/leader/verb")
				c.verbs += /client/verb/create_guild
		view_members()
			set category = "Guild"
			usr<<"<b><u>Guild Members</u></b>"
			var/client/c = usr.client
			var/guild/g = c.myGuild
			for(var/client/cli)
				if(cli.key in g.members)
					c<<"[cli.key == g.leader ? "<font color=green>Leader</font> ":null]<b>[cli.mob.name]</b> ([cli.key])[cli.afk ? " <font color=red>Away</font>":null]"
			c<<"----- ----- ----- ----- -----"