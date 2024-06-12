local OSC_PEEK_SEC = 2
local CLEAR_OSD_TIMEOUT = .01

local osc_always_on = false

local options = {
	oscactive = true
}

require "mp.options".read_options(options, "oscpeek")

local function toggle_osc_auto_always()
	osc_always_on = not osc_always_on
	
	mp.commandv('script-message', 'osc-visibility', osc_always_on and 'always' or 'auto', "")
	mp.add_timeout(CLEAR_OSD_TIMEOUT, function () mp.osd_message('') end)
end

local function peek_osc()
	if not osc_always_on then
		toggle_osc_auto_always()
		mp.add_timeout(OSC_PEEK_SEC, toggle_osc_auto_always)
	end
end

local function initialise()
	filename = mp.get_property_native("filename")
	if filename:match(".m4a$") or filename:match(".mp3$") then
		osc_always_on = true
	else
		osc_always_on = not options.oscactive
	end
	toggle_osc_auto_always()
end

mp.add_key_binding(nil, 'toggle-osc-auto-always', toggle_osc_auto_always)
mp.add_key_binding(nil, 'peek-osc', peek_osc)

mp.register_event("file-loaded", initialise)
