indexing
	description: "This class represents a MS_WINDOWS Ownerdraw button";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class
	PICT_COLOR_BUTTON_WINDOWS

inherit
	OWNER_DRAW_BUTTON_WINDOWS
		redefine
			set_default_size,
			set_background_pixmap
		end
		
	PICT_COL_B_I

	WEL_DIB_COLORS_CONSTANTS
		export
			{NONE} all
		end
	
creation
	make

feature -- Initialization

	make (a_picture_color_button: PICT_COLOR_B; oui_parent: COMPOSITE; man: BOOLEAN) is
			-- Create the pict color b
		do
			!! private_attributes
			parent ?= oui_parent.implementation
			managed := True
			a_picture_color_button.set_font_imp (Current)
			managed := man
		end

feature -- Access

	pixmap: PIXMAP
			-- Pixmap to be drawn on button

feature -- Status setting

	set_pixmap, set_background_pixmap (a_pixmap: PIXMAP) is
			-- Set the pixmap for the button
		do
			pixmap := a_pixmap
			if (fixed_size_flag and (pixmap.height + 6 > height or pixmap.width + 6 > width)) or not fixed_size_flag then 
				set_form_width (pixmap.width + 6)
				set_form_height (pixmap.height + 6)
			end
			if exists then
				invalidate
			end
		end

	set_default_size is
			-- Set default of button
		do
			if pixmap /= Void then
				set_form_width (pixmap.width + 6)
				set_form_height (pixmap.height + 6)
			end
		end

feature -- Element change 

	add_draw_item_action (a_command: COMMAND; arg: ANY) is
			-- Action for a draw item.
		do
			draw_item_actions.add (Current, a_command, arg)
		end

feature -- Removal

	remove_draw_item_action (a_command: COMMAND; arg: ANY) is
			-- Remove actions for draw_item event
		do
			draw_item_actions.remove (Current, a_command, arg)
		end

feature {NONE} -- Implementation

	draw_selected (a_dc: WEL_DC) is
		local
			bitmap: WEL_BITMAP
			pixmap_w: PIXMAP_WINDOWS
			dib: WEL_DIB
			pixmap_x, pixmap_y : INTEGER
		do
			if pixmap /= Void then
				pixmap_w ?= pixmap.implementation
				dib := pixmap_w.dib
				check
					dib_exists: dib /= Void
				end
				!! bitmap.make_by_dib (a_dc, dib, dib_rgb_colors)
				if alignment_type = center_alignment_type then
					pixmap_x := (4 + ((internal_width - bitmap.width) // 2)).max (4)
					pixmap_y := (4 + ((internal_height - bitmap.height) // 2)).max (4)
					a_dc.draw_bitmap (bitmap, pixmap_x, pixmap_y, internal_width, internal_height)
				else
					a_dc.draw_bitmap (bitmap, 4, 4, internal_width, internal_height)
				end
			end
		end

	draw_unselected (a_dc: WEL_DC) is
		local
			bitmap: WEL_BITMAP
			pixmap_w: PIXMAP_WINDOWS
			dib: WEL_DIB
			pixmap_x, pixmap_y : INTEGER
		do
			if pixmap /= Void then
				pixmap_w ?= pixmap.implementation
				dib := pixmap_w.dib
				check
					dib_exists: dib /= Void
				end
				!! bitmap.make_by_dib (a_dc, dib, dib_rgb_colors)
				if alignment_type = center_alignment_type then
					pixmap_x := (2 + ((internal_width - bitmap.width) // 2)).max (2)
					pixmap_y := (2 + ((internal_height - bitmap.height) // 2)).max (2)
					a_dc.draw_bitmap (bitmap, pixmap_x, pixmap_y, internal_width, internal_height)
				else
					a_dc.draw_bitmap (bitmap, 2, 2, internal_width, internal_height)
				end
			end
		end

	internal_width: INTEGER is
		require
			exists: exists
		do
			Result := (width - 6).max (0)
		ensure
			positive_result: Result >= 0
		end

	internal_height: INTEGER is
		require
			exists: exists
		do
			Result := (height - 6).max (0)
		ensure
			positive_result: Result >= 0
		end


end -- class PICT_COLOR_BUTTON_WINDOWS

--|---------------------------------------------------------------- 
--| EiffelVision: library of reusable components for ISE Eiffel 3. 
--| Copyright (C) 1989, 1991, 1993, 1994, Interactive Software
--|   Engineering Inc. 
--| All rights reserved. Duplication and distribution prohibited. 
--| 
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA 
--| Telephone 805-685-1006 
--| Fax 805-685-6869 
--| Electronic mail <info@eiffel.com> 
--| Customer support e-mail <support@eiffel.com> 
--|---------------------------------------------------------------- 
