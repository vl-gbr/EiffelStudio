indexing
	description: "[
		A transitional popup window, to display something when switching between view states.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	ES_POPUP_TRANSITION_WINDOW

inherit
	ES_POPUP_WINDOW
		rename
			make as make_popup_window
		redefine
			on_after_initialized,
			border_color,
			is_focus_sensitive,
			is_pointer_sensitive
		end

create
	make,
	make_with_icon

feature {NONE} -- Initialization

	make (a_text: like text)
			-- Initialize a new transitional window
			--
			-- `a_text': The message text to display to the use.
		require
			not_a_text_is_empty: not a_text.is_empty
		do
			make_popup_window (True)
			set_text (a_text)
		ensure
			text_set: text.is_equal (a_text)
		end

	make_with_icon (a_text: like text; a_icon: !like icon)
			-- Initialize a new transitional window
			--
			-- `a_text': The message text to display to the use.
		require
			not_a_text_is_empty: not a_text.is_empty
		do
			make (a_text)
			set_icon (a_icon)
		ensure
			text_set: text.is_equal (a_text)
			icon_set: icon = a_icon
		end

	build_window_interface (a_container: EV_VERTICAL_BOX)
			-- Builds the windows's user interface.
			--
			-- `a_container': The dialog's container where the user interface elements should be extended.
		local
			l_hbox: EV_HORIZONTAL_BOX
			l_vbox: EV_HORIZONTAL_BOX
			l_padding: EV_CELL
		do
			create l_hbox
			l_hbox.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)

				-- Left padding
			create l_padding
			l_padding.set_minimum_width (padding_width)
			l_hbox.extend (l_padding)
			l_hbox.disable_item_expand (l_padding)

				-- Pixmap icon
			create l_vbox
			l_vbox.extend (create {EV_CELL})
			create icon_pixmap
			icon_pixmap.hide
			l_vbox.extend (icon_pixmap)
			l_vbox.disable_item_expand (icon_pixmap)
			l_vbox.extend (create {EV_CELL})

			l_hbox.extend (l_vbox)

				-- Message label
			create message_label
			message_label.align_text_left
			l_hbox.extend (message_label)

			a_container.extend (l_hbox)

				-- Set white background color
			propagate_colors (a_container, Void, colors.stock_colors.white, Void)
				-- Set white background color for icon pixmap because the propgation ignores pixmaps by default.
			icon_pixmap.set_background_color (colors.stock_colors.white)
			icon_pixmap.set_foreground_color (colors.stock_colors.white)
		end

	on_after_initialized
			-- <Precursor>
		do
			Precursor

				-- Set wait cursor on window
			register_kamikaze_action (show_actions, agent popup_window.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined ({EV_POINTER_STYLE_CONSTANTS}.wait_cursor)))
		end

feature -- Access

	text: !STRING_32 assign set_text
			-- Text message displayed on the transition window
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
		do
			create Result.make_from_string (message_label.text)
		end

feature {NONE} -- Access

	padding_width: INTEGER
			-- Transitional window padding width
		do
			Result := 30
		end

	border_color: EV_COLOR
			-- Pop up window border color.
		once
			Result := active_border_color
		end

feature -- Element change

	set_text (a_text: like text)
			-- Sets transitional text message for the window.
			--
			-- `a_text': A message to display to the user about the transitioning.
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
			not_a_text_is_empty: not a_text.is_empty
		local
			l_size: TUPLE [width: INTEGER_32; height: INTEGER_32; left_offset: INTEGER_32; right_offset: INTEGER_32]
		do
			message_label.set_text (a_text)
			l_size := message_label.font.string_size (a_text)
			message_label.set_minimum_size (l_size.width + padding_width, l_size.height + padding_width)
			message_label.refresh_now
		ensure
			text_set: text.is_equal (a_text)
		end

	set_icon (a_icon: !like icon)
			-- Sets icon image, appearring adjecent to the message.
			--
			-- `a_icon': An icon to set on the transitional window.
		require
			is_interface_usable: is_interface_usable
			is_initialized: is_initialized
			not_a_icon_is_detroyed: not a_icon.is_destroyed
		local
			l_pixmap: like icon_pixmap
			l_width: INTEGER
			l_height: INTEGER
		do
			l_pixmap := icon_pixmap
			l_width := a_icon.width
			l_height := a_icon.height

			l_pixmap.set_minimum_size (l_width, l_height)
			l_pixmap.set_size (l_width, l_height)
			l_pixmap.clear_rectangle (0, 0, l_width, l_height)
			l_pixmap.fill_rectangle (0, 0, l_width, l_height)
			l_pixmap.draw_sub_pixel_buffer (0, 0, a_icon, create {EV_RECTANGLE}.make (0, 0, l_width, l_height))
			l_pixmap.show

			icon := a_icon
		ensure
			icon_set: icon = a_icon
		end

feature -- Status report

	is_focus_sensitive: BOOLEAN = False
			-- Indicates if the window is sensitive to focus. By default, if the window loses focus then
			-- is it closed.

	is_pointer_sensitive: BOOLEAN  = False
			-- Indicates if the window is sensitive to having a mouse pointer. By default, if the mouse pointer leaves the
			-- window, is it remains open.

	is_recycled_on_closing: BOOLEAN
			-- Indicates if the foundation should be recycled on closing.
		do
			Result := True
		end

feature {NONE} -- User interface elements

	message_label: !EV_LABEL
			-- Label used to display the message to the user.

	icon: ?EV_PIXEL_BUFFER
			-- Icon displayed adjecent to the message.

	icon_pixmap: !EV_PIXMAP
			-- Pixmap place holder to render the icon on.

;indexing
	copyright:	"Copyright (c) 1984-2007, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
