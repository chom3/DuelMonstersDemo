?%   Wv????`?U?`?%  Interface.dmf macro "macro"
	elem 
		name = "North+REP"
		command = ".north"
		is-disabled = false
	elem 
		name = "South+REP"
		command = ".south"
		is-disabled = false
	elem 
		name = "East+REP"
		command = ".east"
		is-disabled = false
	elem 
		name = "West+REP"
		command = ".west"
		is-disabled = false
	elem 
		name = "Northeast+REP"
		command = ".northeast"
		is-disabled = false
	elem 
		name = "Northwest+REP"
		command = ".northwest"
		is-disabled = false
	elem 
		name = "Southeast+REP"
		command = ".southeast"
		is-disabled = false
	elem 
		name = "Southwest+REP"
		command = ".southwest"
		is-disabled = false
	elem 
		name = "Center+REP"
		command = ".center"
		is-disabled = false


menu "menu"
	elem 
		name = "&Quit"
		command = ".quit"
		category = "&File"
		is-checked = false
		can-check = false
		group = ""
		is-disabled = false
		saved-params = "is-checked"


window "bag"
	elem "bag"
		type = MAIN
		pos = 281,0
		size = 350x400
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = none
		is-visible = false
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = false
		right-click = false
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Inventory"
		titlebar = true
		statusbar = false
		can-close = true
		can-minimize = false
		can-resize = false
		is-pane = false
		is-minimized = false
		is-maximized = false
		can-scroll = none
		icon = ""
		image = ""
		image-mode = stretch
		keep-aspect = false
		transparent-color = none
		alpha = 255
		macro = ""
		menu = ""
		on-close = ""
	elem "cash"
		type = LABEL
		pos = 0,0
		size = 350x20
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #ffffff
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = false
		border = sunken
		drop-zone = false
		right-click = false
		saved-params = ""
		text = "Money:"
		image = ""
		image-mode = center
		keep-aspect = false
		align = center
		text-wrap = false
	elem "grid"
		type = GRID
		pos = 0,20
		size = 350x380
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #ffffff
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = true
		right-click = false
		saved-params = ""
		cells = 0x0
		current-cell = 0,0
		show-lines = both
		small-icons = false
		show-names = true
		enable-http-images = false
		link-color = #0000ff
		visited-color = #ff00ff
		line-color = #c0c0c0
		style = "BIG IMG.icon {width: 32px; height: 32px}"
		is-list = false

window "default"
	elem "default"
		type = MAIN
		pos = 281,0
		size = 640x472
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = #c0c0c0
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = true
		border = none
		drop-zone = false
		right-click = false
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Library"
		titlebar = true
		statusbar = false
		can-close = true
		can-minimize = true
		can-resize = true
		is-pane = false
		is-minimized = false
		is-maximized = false
		can-scroll = none
		icon = ""
		image = ""
		image-mode = stretch
		keep-aspect = false
		transparent-color = none
		alpha = 255
		macro = "macro"
		menu = "menu"
		on-close = ""
	elem "map1"
		type = MAP
		pos = 96,16
		size = 352x240
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = none
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = true
		border = none
		drop-zone = false
		right-click = false
		saved-params = "icon-size"
		icon-size = 0
		text-mode = false
		on-show = ""
		on-hide = ""
	elem "output1"
		type = OUTPUT
		pos = 280,272
		size = 328x200
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #ffffff
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = true
		border = none
		drop-zone = false
		right-click = false
		saved-params = "max-lines"
		link-color = #d7d7d7
		visited-color = #d7d7d7
		style = ""
		enable-http-images = false
		max-lines = 1000
		image = ""
	elem "info1"
		type = INFO
		pos = 8,272
		size = 248x200
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = #ffffff
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = true
		border = none
		drop-zone = false
		right-click = false
		saved-params = ""
		highlight-color = #00ff00
		tab-text-color = #000000
		tab-background-color = none
		tab-font-family = ""
		tab-font-size = 0
		tab-font-style = ""
		allow-html = true
		multi-line = true
		on-show = ""
		on-hide = ""
		on-tab = ""

window "party"
	elem "party"
		type = MAIN
		pos = 281,0
		size = 300x400
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = none
		is-visible = false
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = false
		right-click = false
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Party Window"
		titlebar = true
		statusbar = false
		can-close = false
		can-minimize = false
		can-resize = true
		is-pane = false
		is-minimized = false
		is-maximized = false
		can-scroll = none
		icon = ""
		image = ""
		image-mode = stretch
		keep-aspect = false
		transparent-color = none
		alpha = 255
		macro = ""
		menu = ""
		on-close = ""
	elem "grid"
		type = GRID
		pos = 0,0
		size = 300x400
		anchor1 = 0,0
		anchor2 = 100,100
		font-family = "Verdana"
		font-size = 9
		font-style = "bold"
		text-color = #ff0000
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = true
		right-click = false
		saved-params = ""
		cells = 1x0
		current-cell = 1,0
		show-lines = both
		small-icons = false
		show-names = true
		enable-http-images = false
		link-color = #0000ff
		visited-color = #ff00ff
		line-color = #ff0000
		style = ""
		is-list = false

window "quest"
	elem "quest"
		type = MAIN
		pos = 281,0
		size = 500x300
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = none
		is-visible = false
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = false
		right-click = false
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Quests"
		titlebar = true
		statusbar = false
		can-close = true
		can-minimize = false
		can-resize = true
		is-pane = false
		is-minimized = false
		is-maximized = false
		can-scroll = none
		icon = ""
		image = ""
		image-mode = stretch
		keep-aspect = false
		transparent-color = none
		alpha = 255
		macro = ""
		menu = ""
		on-close = ""
	elem "grid"
		type = GRID
		pos = 0,0
		size = 500x300
		anchor1 = 0,0
		anchor2 = 100,100
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #ffff00
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = true
		right-click = false
		saved-params = ""
		cells = 0x0
		current-cell = 0,0
		show-lines = both
		small-icons = false
		show-names = true
		enable-http-images = false
		link-color = #0000ff
		visited-color = #ff00ff
		line-color = #ffff80
		style = ""
		is-list = false

window "skillbook"
	elem "skillbook"
		type = MAIN
		pos = 281,0
		size = 350x500
		anchor1 = none
		anchor2 = none
		font-family = ""
		font-size = 0
		font-style = ""
		text-color = #000000
		background-color = none
		is-visible = false
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = false
		right-click = false
		saved-params = "pos;size;is-minimized;is-maximized"
		title = "Skill Book"
		titlebar = true
		statusbar = false
		can-close = true
		can-minimize = false
		can-resize = true
		is-pane = false
		is-minimized = false
		is-maximized = false
		can-scroll = none
		icon = ""
		image = ""
		image-mode = stretch
		keep-aspect = false
		transparent-color = none
		alpha = 255
		macro = "macro"
		menu = ""
		on-close = ""
	elem "grid"
		type = GRID
		pos = 0,0
		size = 350x500
		anchor1 = 0,0
		anchor2 = 100,100
		font-family = "Verdana"
		font-size = 0
		font-style = ""
		text-color = #00ffff
		background-color = #000000
		is-visible = true
		is-disabled = false
		is-transparent = false
		is-default = false
		border = none
		drop-zone = true
		right-click = false
		saved-params = ""
		cells = 0x0
		current-cell = 0,0
		show-lines = both
		small-icons = false
		show-names = true
		enable-http-images = false
		link-color = #0000ff
		visited-color = #ff00ff
		line-color = #ff0000
		style = ""
		is-list = false

  ?jt????`?U?`  Misc.dmi ?PNG

   IHDR   @   @   ??M   PLTE      ?  3f ħ?   tRNS @??f   xzTXtDescription  x?SVpru??Sp???*K-*???S?U0?3??,?L)? r???83R3?3J ???ĒT S)?(??X??3%???7??L+J?M????
r+S?*?+HƥFY????B `?/5????    IDAT8?c??P?0*0*?$?

``T`T !  ???8??    IEND?B`?