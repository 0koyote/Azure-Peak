/*
	Well, we were on the preferences menu, but now we are on our own datum yet again
*/
/datum/drifter_queue_menu
	var/client/linked_client

/datum/drifter_queue_menu/proc/first_show_drifter_queue_menu()
	var/datum/asset/thicc_assets = get_asset_datum(/datum/asset/simple/blackedstone_drifter_queue_menu_slop_layout)
	thicc_assets.send(linked_client)
	show_drifter_queue_menu()

/datum/drifter_queue_menu/proc/show_drifter_queue_menu()
	//Opening tags and empty head
	var/data = {"
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<html>
		<head>
			<style>
			</style>
			<link rel='stylesheet' type='text/css' href='slop_menustyle4.css'>
		</head>
	"}

	//Body tag start
	data += "<body>"
	data += "<table class='timer_table'><tr><td class='timer_fluff'>Time to next incursion:</td><td class='timer_time'>[SSrole_class_handler.time_left_until_next_wave_string]</td></tr></table>"
	data += "<br>"
	data += "<div class='table_fluff_container'><span class='table_fluff_text'>Forecast:</span><span class='table_fluff_fadeout_line'></span></div><br>"
	/*
		I have decided to just display the current and the next wave
		Three would mean people would get too much heads up information and be more likely to afk than normal
	*/

	data += "<table class='wave_container'>"

	
	if(SSrole_class_handler.drifter_wave_schedule.len)
		// Amount of iterations
		var/current_iteration = 0
		// Amount of waves to display
		var/max_to_display = 2
		for(var/i = SSrole_class_handler.drifter_wave_schedule.len, i > 0, i--)
			var/datum/drifter_wave/cur_datum = SSrole_class_handler.drifter_wave_schedule[i]
			current_iteration++

			data += "<tr class='wave_row'>"
			switch(current_iteration)
				if(1)
					data += "<td class='wave_entry_href'>"
					if(linked_client in SSrole_class_handler.drifter_wave_joined_clients)
						data += "<a class='leave_drifter_queue'href='?src=\ref[src];leave_queue=1'>LEAVE</a>"
					else
						data += "<a class='join_drifter_queue'href='?src=\ref[src];join_queue=1'>JOIN</a>"
					data += "</td>"
					data += "<td class='wave_number'>NOW: </td>"
				if(2)
					data += {"
						<td class='wave_entry_href'></td>
						<td class='wave_number'>NEXT: </td>
					"}

				else
					data += {"
						<td class='wave_entry_href'></td>
						<td class='wave_number'>[i]: </td>
					"}

			data += "<td class='wave_type'><a class='wave_type_hlink' href='?src=\ref[src];'>[cur_datum.wave_type_name]<span class='wave_type_hlink_tooltext'>[cur_datum.wave_type_tooltip]</span></a></td>"
			if(current_iteration == 1)
				data += "<td>[SSrole_class_handler.drifter_wave_joined_clients.len]/[cur_datum.maximum_playercount]</td>"
			else
				data += "<td>0/[cur_datum.maximum_playercount]</td>"
			data += "</tr>"

			if(current_iteration >= max_to_display)
				break
	
	data += "</table>"
	data += "<hr class='fadeout_line'>"

	data += SSrole_class_handler.drifter_queue_player_tbl_string

	//Closing Tags
	data += {"
		</body>
	</html>
	"}

	linked_client << browse(data, "window=drifter_queue;size=400x430;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1")
	// We setup the href_list "close" call if they hit the x on the top right
	for(var/i in 1 to 10)
		if(linked_client && winexists(linked_client, "drifter_queue"))
			onclose(linked_client.mob, "drifter_queue", src)
			break

/datum/drifter_queue_menu/proc/ForceCloseMenus()
	linked_client << browse(null, "window=drifter_queue")

/datum/drifter_queue_menu/Topic(href, list/href_list)
	. = ..()
	if(href_list["join_queue"])
		SSrole_class_handler.attempt_to_add_client_to_drifter_wave(linked_client)
		show_drifter_queue_menu()

	if(href_list["leave_queue"])
		SSrole_class_handler.remove_client_from_drifter_wave(linked_client)
		show_drifter_queue_menu()

	if(href_list["close"])
		SSrole_class_handler.remove_client_from_drifter_wave(linked_client)
		SSrole_class_handler.remove_drifter_queue_viewer(linked_client)
		return
