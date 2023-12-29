-- https://www.reddit.com/r/mpv/comments/ob22cd/any_way_to_stop_automatic_resizing_when_youre/ (231229)

local toggleflag = true

function freeze_window()
	mp.osd_message("big black nigga balls hd")
	if toggleflag then
		local ww, wh = mp.get_osd_size()
		mp.set_property("geometry", string.format("%dx%d", ww, wh))
		mp.osd_message("window size frozen")
		toggleflag = not toggleflag
	else
		mp.set_property("geometry", "")
		mp.osd_message("window size un-frozen")
		toggleflag = not toggleflag
	end
end

mp.add_key_binding(nil, 'freeze_window', freeze_window)
