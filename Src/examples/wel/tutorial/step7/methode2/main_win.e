class
	MAIN_WINDOW

inherit
	WEL_FRAME_WINDOW
		redefine
			on_left_button_down,
			on_left_button_up,
			on_mouse_move,
			on_menu_command,
			on_paint,
			closeable
		end
	WEL_ID_CONSTANTS
	WEL_STANDARD_COLORS
		export
			{NONE} all
		end

creation
	make

feature {NONE} -- Initialization

	make is
			-- Make the main window.
		do
			make_top ("My application")
			create dc.make (Current)
			set_pen_width (1)
			create lines.make
			set_menu (main_menu)
		end

feature -- Access

	dc: WEL_CLIENT_DC
			-- Device context associated to the current
			-- client window

	button_down: BOOLEAN
			-- Is the left mouse button down?

	pen: WEL_PEN
			-- Pen currently selected in `dc'

	line_thickness_window: LINE_THICKNESS_WINDOW
			-- Window to change line thickness

	lines: LINKED_LIST [LINE]
			-- All lines drawn by the user

	current_line: LINE
			-- Line currently drawn by the user

feature -- Element change

	set_pen_width (new_width: INTEGER) is
			-- Set pen width with `new_width'.
		do
			create pen.make_solid (new_width, black)
		end

feature {NONE} -- Implementation

	on_left_button_down (keys, x_pos, y_pos: INTEGER) is
			-- Initiate the drawing process.
		do
			if not button_down then
				button_down := True
				dc.get
				dc.move_to (x_pos, y_pos)
				dc.select_pen (pen)
				create current_line.make
				current_line.set_width (pen.width)
				lines.extend (current_line)
				current_line.add (x_pos, y_pos)
			end
		end

	on_mouse_move (keys, x_pos, y_pos: INTEGER) is
			-- Connect the points to make lines.
		do
			if button_down then
				dc.line_to (x_pos, y_pos)
				current_line.add (x_pos, y_pos)
			end
		end

	on_left_button_up (keys, x_pos, y_pos: INTEGER) is
			-- Terminate the drawing process.
		do
			if button_down then
				button_down := False
				dc.release
			end
		end

	on_paint (paint_dc: WEL_PAINT_DC; invalid_rect: WEL_RECT) is
			-- Paint the lines.
		local
			a_line: LINE
			a_pen: WEL_PEN
			first_point: BOOLEAN
		do
			from
				lines.start
			until
				lines.off
			loop
				from
					first_point := True
					a_line := lines.item
					a_line.start
					create a_pen.make_solid (a_line.width, black)
					paint_dc.select_pen (a_pen)
				until
					a_line.off
				loop
					if first_point then
						first_point := False
						paint_dc.move_to (a_line.item.x,
							a_line.item.y)
					else
						paint_dc.line_to (a_line.item.x,
							a_line.item.y)
					end
					a_line.forth
				end
				lines.forth
			end
		end

	on_menu_command (menu_id: INTEGER) is
			-- `menu_id' has been selected.
		local 
			msg_box:WEL_MSG_BOX
		do
			inspect
				menu_id
			when Cmd_new then
				lines.wipe_out
				invalidate
			when Cmd_open then
				create msg_box.make
				msg_box.warning_message_box (Current, "Feature not implemented.", "Open")
			when Cmd_save then
				create msg_box.make
				msg_box.warning_message_box (Current, "Feature not implemented.", "Save")
			when Cmd_exit then
				if closeable then
					destroy
				end
			when Cmd_line_thickness then
				if line_thickness_window = Void then
					create line_thickness_window.make (Current)
				end
				line_thickness_window.activate
			end
		end

	closeable: BOOLEAN is
			-- Does the user want to quit?
		local
			msg_box: WEL_MSG_BOX
		do
			create msg_box.make
			msg_box.question_message_box (Current, "Do you want to quit?","Quit")
			Result := (msg_box.message_box_result = Idyes)
		end

	main_menu: WEL_MENU is
			-- Window's menu
		local
			file, line: WEL_MENU
		once
			-- Create File popup menu
			create file.make
			file.append_string ("&New", Cmd_new)
			file.append_string ("&Open...", Cmd_open)
			file.append_string ("&Save...", Cmd_save)
			file.append_separator
			file.append_string ("E&xit", Cmd_exit)

			-- Create Line popup menu
			create line.make
			line.append_string ("Line &thickness...", Cmd_line_thickness)

			-- Append File and Line menus in main menu
			create Result.make
			Result.append_popup (file, "&File")
			Result.append_popup (line, "&Line")
		end

	-- Menu identifiers.
	Cmd_new: INTEGER is 101
	Cmd_open: INTEGER is 102
	Cmd_save: INTEGER is 103
	Cmd_exit: INTEGER is 105
	Cmd_line_thickness: INTEGER is 106

end -- class MAIN_WINDOW

--|-------------------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------------
