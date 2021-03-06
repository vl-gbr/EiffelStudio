note
	description: "This class represents a MS_IMPdrawing area"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class

	DRAWING_AREA_IMP

inherit

	PRIMITIVE_IMP
		undefine
			on_move
		redefine
			background_brush,
			set_size,
			set_background_color
		end

	WEL_CONTROL_WINDOW
		rename
			make as wel_make,
			show as wel_show,
			hide as wel_hide,
			destroy as wel_destroy,
			x as wel_x,
			y as wel_y,
			width as wel_width,
			height as wel_height,
			set_x as wel_set_x,
			set_y as wel_set_y,
			set_width as wel_set_width,
			set_height as wel_set_height,
			shown as wel_shown,
			parent as wel_parent,
			text as wel_text,
			text_length as wel_text_length,
			set_text as wel_set_text,
			move as wel_move,
			set_focus as wel_set_focus,
			set_capture as wel_set_capture,
			release_capture as wel_release_capture,
			item as wel_item,
			font as wel_control_font,
			set_font as wel_control_set_font
		undefine
			class_background,
			background_brush,
			on_size,
			on_right_button_up, on_left_button_down,
			on_left_button_up, on_right_button_down,
			on_mouse_move, on_destroy, on_set_cursor,
			on_key_up,
			on_key_down,
			on_show,
			on_hide
		redefine
			class_name,
			on_paint,
			default_ex_style
		end

	DRAWING_AREA_I

	DRAWABLE_DEVICE_WINDOWS

	CURSOR_WIDGET_MANAGER

	WEL_MK_CONSTANTS
		export
			{NONE} all
		end

	WEL_MM_CONSTANTS
		export
			{NONE} all
		end

	WEL_CAPABILITIES_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_drawing_area: DRAWING_AREA; man: BOOLEAN; oui_parent: COMPOSITE)
			-- Create a drawing area
		do
			create private_attributes
			parent ?= oui_parent.implementation
			managed := man
			set_line_width (1);
			create gc_fg_color.make_system (Color_windowtext)
			if private_background_color /= Void then
				create gc_bg_color.make_rgb (private_background_color.red // 256,
					private_background_color.green // 256,
					private_background_color.blue // 256)
			else
				create gc_bg_color.make_system (Color_window)
			end
			line_style := ps_solid
		end

	realize
			-- Display a drawing area
		local
			wc: WEL_COMPOSITE_WINDOW
			client_dc: WEL_CLIENT_DC
		do
			if not realized then
				create background_pen.make (Ps_solid, 1, gc_bg_color)
				wc ?= parent
				make_with_coordinates (wc, "", x, y, width.min (maximal_width),
					height.min (maximal_height))
				create client_dc.make (Current)
				client_dc.get
				client_dc.set_background_color (gc_bg_color)
				client_dc.select_brush (background_brush)
				drawing_dc := client_dc
				clear
			end
		end

feature -- Status report

	set_size (new_width, new_height: INTEGER)
			-- Set the height to new_height,
			-- width to `new_width'.
		do
			private_attributes.set_width (new_width)
			private_attributes.set_height (new_height)
			if exists then
				resize (new_width.min(maximal_width), new_height.min (maximal_height))
			end
			if parent /= Void then
				parent.child_has_resized
			end
		end

	painting: BOOLEAN
			-- Are we currently executing a WM_PAINT message?

	is_valid: BOOLEAN
		do
			Result := True
		end

feature -- Status setting

	set_background_color (a_color: COLOR)
		do
			private_background_color := a_color
			bg_color ?= a_color.implementation
			check
				valid_color: bg_color /= Void
			end
			if drawing_dc /= Void and then drawing_dc.exists then
				drawing_dc.rectangle (0, 0, width, height)
			end
		end

feature -- Element change

	add_input_action (a_command: COMMAND; arg: ANY)
			-- Add `a_command' to the list of action to be executed when
			-- a key is pressed or when a mouse button is pressed.
			-- `argument' will be passed to `a_command' whenever it is
			-- invoked as a callback.
		do
			left_button_press_actions.add (Current, a_command, arg)
			left_button_release_actions.add (Current, a_command, arg)
			right_button_press_actions.add (Current, a_command, arg)
			right_button_release_actions.add (Current, a_command, arg)
			middle_button_press_actions.add (Current, a_command, arg)
			middle_button_release_actions.add (Current, a_command, arg)

			key_press_actions.add (Current, a_command, arg)
			key_release_actions.add (Current, a_command, arg)
		end

feature -- Removal

	remove_input_action (a_command: COMMAND; arg: ANY)
			-- Remove `a_command' with `argument' from the list of action
			-- to be executed when a key is pressed or when a mouse button
			-- is pressed.
		do
			left_button_press_actions.remove (Current, a_command, arg)
			left_button_release_actions.remove (Current, a_command, arg)
			right_button_press_actions.remove (Current, a_command, arg)
			right_button_release_actions.remove (Current, a_command, arg)
			middle_button_press_actions.remove (Current, a_command, arg)
			middle_button_release_actions.remove (Current, a_command, arg)

			key_press_actions.remove (Current, a_command, arg)
			key_release_actions.remove (Current, a_command, arg)
		end

feature -- Basic operations

	output_to_printer (a_name: STRING)
		require
			a_name_valid: a_name /= Void and not a_name.is_empty
		local
			old_dc: WEL_DC
			printer_dc: WEL_DEFAULT_PRINTER_DC
			expose_data: EXPOSE_DATA
			coord: COORD_XY
			clip: CLIP
			msg_box: WEL_MSG_BOX
		do
			create printer_dc.make
			if printer_dc.exists then
				printer_dc.start_document (a_name)
				printer_dc.start_page
				printer_dc.set_map_mode (mm_isotropic)
				printer_dc.set_window_extent (width, height)
				printer_dc.set_viewport_extent (printer_dc.device_caps (horizontal_resolution), printer_dc.device_caps (vertical_resolution))
				painting := True
				old_dc := drawing_dc
				drawing_dc := printer_dc
				create coord
				coord.set (0, 0)
				create clip
				clip.set (coord, width, height)
				create expose_data.make (owner, clip, 0)
				expose_actions.execute (Current, expose_data)
				unset_drawing_dc
				printer_dc.end_page
				printer_dc.end_document
				drawing_dc := old_dc
				painting := False
			else
				create msg_box.make
				msg_box.basic_message_box (Void, "No default printer set. Printing unavailable.",
					"Printer Not Set", Mb_iconstop + Mb_ok)
			end
		end

	output_to_printer_dc (a_printer_dc: WEL_PRINTER_DC; a_name: STRING)
			-- Output to `a_printer_dc'.
		require
			a_name_valid: a_name /= Void and not a_name.is_empty
			a_printer_dc_not_void: a_printer_dc /= Void
			a_printer_dc_exists: a_printer_dc.exists
		local
			old_dc: WEL_DC
			expose_data: EXPOSE_DATA
			coord: COORD_XY
			clip: CLIP
		do
			a_printer_dc.start_document (a_name)
			a_printer_dc.start_page
			a_printer_dc.set_map_mode (mm_isotropic)
			a_printer_dc.set_window_extent (width, height)
			a_printer_dc.set_viewport_extent (a_printer_dc.device_caps (horizontal_resolution), a_printer_dc.device_caps (vertical_resolution))
			painting := True
			old_dc := drawing_dc
			drawing_dc := a_printer_dc
			create coord
			coord.set (0, 0)
			create clip
			clip.set (coord, width, height)
			create expose_data.make (owner, clip, 0)
			expose_actions.execute (Current, expose_data)
			unset_drawing_dc
			a_printer_dc.end_page
			a_printer_dc.end_document
			drawing_dc := old_dc
			painting := False
		end

	output_to_file (a_file_name: FILE_NAME)
		require
			a_file_name_valid: a_file_name /= Void and not a_file_name.is_empty
		local
			old_dc: WEL_DC
			virtual_dc: WEL_MEMORY_DC
			virtual_bitmap: WEL_BITMAP
			expose_data: EXPOSE_DATA
			coord: COORD_XY
			clip: CLIP
		do
			create virtual_dc.make_by_dc (drawing_dc)
			create virtual_bitmap.make_compatible (drawing_dc, width, height)
			virtual_dc.select_bitmap (virtual_bitmap)
			painting := True
			old_dc := drawing_dc
			drawing_dc := virtual_dc
			clear
			create coord
			coord.set (0, 0)
			create clip
			clip.set (coord, width, height)
			create expose_data.make (owner, clip, 0)
			expose_actions.execute (Current, expose_data)
			unset_drawing_dc
			drawing_dc := old_dc
			drawing_dc.save_bitmap (virtual_bitmap, a_file_name)
			painting := False
		end

feature -- WEL

	background_brush: WEL_BRUSH
			-- Brush used to paint the background.
			-- Need to be redefine to appear white.
		local
			windows_color: COLOR_IMP
		do
			if private_background_color = Void then
				create Result.make_by_sys_color (Color_windowtext)
			else
				windows_color ?= private_background_color.implementation
				Result := windows_color.brush
			end
		end

	background_pen: WEL_PEN
			-- Pen used to paint the background

	class_name: STRING_32
			-- Windows class name
		do
			Result := "EVisionDrawingArea"
		end

	on_paint (paint_dc: WEL_PAINT_DC; invalid_rect: WEL_RECT)
			-- Respond to a paint message.
		local
			clip: CLIP
			coord_xy: COORD_XY
			expose_data: EXPOSE_DATA
		do
			if drawing_dc /= Void then
				clear_rect (invalid_rect.left,
					invalid_rect.top, invalid_rect.right,
					invalid_rect.bottom)
			end
			create coord_xy
			coord_xy.set (invalid_rect.left, invalid_rect.top)
			create clip
			clip.set (coord_xy, invalid_rect.width, invalid_rect.height)
			create expose_data.make (widget_oui, clip, 0)
			expose_actions.execute (Current, expose_data)
		end

	wel_font: WEL_FONT
		do
		end

	wel_set_font (f: WEL_FONT)
		do
		end

	default_ex_style: INTEGER
		do
			Result := 768
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class DRAWING_AREA_IMP

