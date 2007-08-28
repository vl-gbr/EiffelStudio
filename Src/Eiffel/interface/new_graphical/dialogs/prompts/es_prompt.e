indexing
	description: "[
		A dialog prompt base, to inform the user or to ask them as question.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$date$";
	revision: "$revision$"

deferred class
	ES_PROMPT

inherit
	ES_DIALOG
		rename
			make as make_dialog
		export
			{NONE} set_is_modal, is_modal, icon
		redefine
			dialog_border_width,
			on_handle_key
		end

feature {NONE} -- Initialization

	make (a_text: like text; a_buttons: like buttons; a_default: like default_button)
			-- Initialize a prompt using required information
			--
			-- `a_text': The text to display on the prompt; empty or void to display none
			-- `a_buttons': A list of button ids corresponding created from {ES_DIALOG_BUTTONS}.
			-- `a_default': The prompt's default button.
		require
			a_text_attached: a_text /= Void
			a_buttons_attached: a_buttons /= Void
			not_a_buttons_is_empty: not a_buttons.is_empty
			a_buttons_contains_valid_ids: a_buttons.for_all (agent dialog_buttons.is_valid_button_id)
			a_buttons_contains_a_default: a_buttons.has (a_default)
		local
			l_init: BOOLEAN
		do
			l_init := is_initializing
			is_initializing := True

			buttons := a_buttons

				-- Set default buttons
			set_default_button (a_default)
			dialog_buttons.abort_retry_ignore_buttons.do_if (
				agent set_default_cancel_button,
				agent (a_item: INTEGER): BOOLEAN
					do
							-- Detemine if cancel button has already been set
						Result := default_cancel_button = 0 and buttons.has (a_item)
					end)

			make_dialog
			set_text (a_text)

				-- Prompts cannot be resized
			dialog.disable_user_resize

			is_initializing := l_init
		ensure
			text_set: format_text (a_text).is_equal (text)
			default_button_set: default_button = a_default
			buttons_set: buttons = a_buttons
		end

	make_standard (a_text: like text)
			-- Initialize a standard warning prompt using required information.
			--
			-- `a_text': The text to display on the prompt.
		require
			a_text_attached: a_text /= Void
		do
			make (a_text, standard_buttons, standard_default_button)
		ensure
			text_set: format_text (a_text).is_equal (text)
			default_button_set: default_button = standard_default_button
			buttons_set: buttons = standard_buttons
		end

feature {NONE} -- User interface initialization

	frozen build_dialog_interface (a_container: EV_VERTICAL_BOX) is
			-- Builds the dialog's user interface.
			--
			-- `a_container': The dialog's container where the user interface elements should be extended
		local
			l_vbox, l_container: EV_VERTICAL_BOX
			l_hbox: EV_HORIZONTAL_BOX
			l_cell: EV_CELL
			l_icon: EV_PIXMAP
		do
			create l_vbox
			create l_hbox
			create l_container

			a_container.set_background_color (colors.prompt_banner_color)

				-- Prompt icon
			l_icon := large_icon.to_pixmap
			l_icon.set_minimum_size (l_icon.minimum_width.max (32), l_icon.minimum_height.max (32))
			l_vbox.extend (l_icon)
			l_vbox.disable_item_expand (l_icon)
			l_vbox.extend (create {EV_CELL})

				-- Box for icon with room for expansion
			l_hbox.set_padding ({ES_UI_CONSTANTS}.prompt_horizontal_icon_spacing)
			l_hbox.extend (l_vbox)
			l_hbox.disable_item_expand (l_vbox)

			l_container.set_padding ({ES_UI_CONSTANTS}.prompt_vertical_padding)
			l_hbox.extend (l_container)

				-- Build prompt interface
			build_prompt_interface (l_container)

				-- Create padding for right of prompt
			create l_cell
			l_cell.set_minimum_width (25)
			l_hbox.extend (l_cell)
			l_hbox.disable_item_expand (l_cell)

			a_container.extend (l_hbox)
			a_container.parent.extend (create {EV_HORIZONTAL_SEPARATOR})

			a_container.propagate_background_color
		end

	build_prompt_interface (a_container: EV_VERTICAL_BOX)
			-- Builds the dialog's user interface.
			--
			-- `a_container': The dialog's container where the user interface elements should be extended
		require
			a_container_attached: a_container /= Void
			not_a_container_is_destoryed: not a_container.is_destroyed
			not_is_initialized: not is_initialized
			is_initializing: is_initializing
		do
				-- Prompt sub title
			create prompt_sub_title_label
			prompt_sub_title_label.align_text_left
			prompt_sub_title_label.set_font (fonts_and_colors.prompt_sub_title_font)
			prompt_sub_title_label.set_foreground_color (fonts_and_colors.prompt_sub_title_forground_color)
			prompt_sub_title_label.hide

				-- Prompt text
			create prompt_text
			prompt_text.align_text_left
			prompt_text.set_font (fonts_and_colors.prompt_text_font)
			prompt_text.set_foreground_color (fonts_and_colors.prompt_text_forground_color)
			prompt_text.hide

				-- Extend widgets
			a_container.extend (prompt_sub_title_label)
			a_container.extend (prompt_text)
		ensure
			prompt_sub_title_label_attached: prompt_sub_title_label /= Void
			prompt_text_attached: prompt_text /= Void
		end

feature -- Access

	title: STRING_32 assign set_title
			-- The prompt's dialog title
		do
			Result := dialog.title
			if Result = Void then
				create Result.make_empty
			end
		end

	sub_title: STRING_32 assign set_sub_title
			-- The prompt's sub text
		do
			Result := prompt_sub_title_label.text
			if Result = Void then
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

	text: STRING_32 assign set_text
			-- The prompt's main text
		do
			Result := prompt_text.text
			if Result = Void then
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
			not_result_is_empty: not Result.is_empty
		end

	buttons: DS_SET [INTEGER]
			-- Set of button id's for dialog
			-- Note: Use {ES_DIALOG_BUTTONS} or `dialog_buttons' to determine the id's correspondance.

	default_button: INTEGER assign set_default_button
			-- The dialog's default action button

	default_cancel_button: INTEGER assign set_default_cancel_button
			-- The dialog's default cancel button

feature {NONE} -- Access

	icon: EV_PIXEL_BUFFER
			-- The dialog's large icon, shown on the left
		do
			Result := large_icon
		end

	large_icon: EV_PIXEL_BUFFER
			-- The dialog's large icon, shown on the left
		deferred
		ensure
			result_attached: Result /= Void
		end

	standard_buttons: DS_HASH_SET [INTEGER]
			-- Standard set of buttons for a current prompt
		deferred
		ensure
			result_attached: Result /= Void
			not_result_is_empty: not Result.is_empty
			result_contains_valid_items: Result.for_all (agent dialog_buttons.is_valid_button_id)
		end

	standard_default_button: INTEGER
			-- Standard buttons `standard_buttons' default button
		deferred
		ensure
			result_is_valid_button_id: dialog_buttons.is_valid_button_id (Result)
			standard_buttons_contains_result: standard_buttons.has (Result)
		end

	dialog_border_width: INTEGER
			-- Dialog border width
		do
			Result := {ES_UI_CONSTANTS}.prompt_border
		end

feature -- Element change

	set_title (a_text: like title)
			-- Sets prompt's title text
		require
			a_text_attached: a_text /= Void
		do
			dialog.set_title (a_text)
		ensure
			title_set: a_text.is_equal (title)
		end

	set_text (a_text: like text)
			-- Sets prompt's main text
		require
			a_text_attached: a_text /= Void
		do
			if a_text.is_empty then
				prompt_text.set_text ("")
				prompt_text.hide
			else
				prompt_text.set_text (format_text (a_text))
				prompt_text.show
			end
		ensure
			text_set: format_text (a_text).is_equal (text)
			prompt_text_label_visible_respected: prompt_text.is_show_requested = not a_text.is_empty
		end

	set_sub_title (a_text: like sub_title)
			-- Sets prompt's sub text
		require
			a_text_attached: a_text /= Void
		do
			if a_text.is_empty then
				prompt_sub_title_label.set_text ("")
				prompt_sub_title_label.hide
			else
				prompt_sub_title_label.set_text (a_text)
				prompt_sub_title_label.show
			end
		ensure
			sub_title_set: a_text.is_equal (sub_title)
			prompt_sub_title_label_visible_respected: prompt_sub_title_label.is_show_requested = not a_text.is_empty
		end

	set_default_button (a_id: INTEGER)
			-- Sets prompt's default button
		require
			a_id_is_valid_button_id: dialog_buttons.is_valid_button_id (a_id)
			buttons_contains_a_id: buttons.has (a_id)
		local
			l_button: EV_BUTTON
		do
			default_button := a_id
			l_button := dialog_window_buttons.item (a_id)
			if l_button.is_displayed then
				l_button.set_focus
			else
				dialog.show_actions.extend (agent l_button.set_focus)
			end
		ensure
			default_button_set: default_button = a_id
		end

	set_default_cancel_button (a_id: INTEGER)
			-- Sets prompt's default button
		require
			a_id_is_valid_button_id: dialog_buttons.is_valid_button_id (a_id)
			a_id_is_cancel_button: dialog_buttons.default_cancel_buttons.has (a_id)
			buttons_contains_a_id: buttons.has (a_id)
		do
			default_cancel_button := a_id
			dialog.set_default_cancel_button (dialog_window_buttons.item (a_id))
		ensure
			default_cancel_button_set: default_cancel_button = a_id
		end

feature {NONE} -- Helpers

	frozen os_stock_pixmaps: EV_STOCK_PIXMAPS
			-- Operation system stock pixmaps
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- User interface elements

	prompt_sub_title_label: ES_LABEL
			-- Label for prompts main text

	prompt_text: ES_LABEL
			-- Label for prompts sub-text, if any

feature {NONE} -- Basic operations

	activate_button_using_key (a_key: EV_KEY)
			-- Attempts to perform the activation (selection) of a button using the key `a_key'
		local
			l_keys: EV_KEY_CONSTANTS
			l_buttons: DS_SET_CURSOR [INTEGER]
			l_dialog_buttons: like dialog_window_buttons
			l_button_id: INTEGER
			l_button: EV_BUTTON
			l_string: STRING_32
			l_text: STRING_32
			l_used_character: DS_ARRAYED_LIST [CHARACTER_32]
			l_count, i: INTEGER
			l_bc, c: CHARACTER_32
			l_stop: BOOLEAN
		do
			create l_keys
			if l_keys.valid_key_code (a_key.code) then
				l_string := l_keys.key_strings [a_key.code]
				if l_string.count = 1 then
					c := l_string.item (1).as_lower
					create l_used_character.make (buttons.count)

					l_buttons := buttons.new_cursor
					l_dialog_buttons := dialog_window_buttons
					from l_buttons.start until l_buttons.after or l_stop  loop
							-- Locate button
						l_button_id := l_buttons.item
						l_button := l_dialog_buttons.item (l_button_id)
						check l_button_attached: l_button /= Void end

							-- Retrieve and search text
						l_text := l_button.text
						l_count := l_text.count
						from i := 1 until i > l_count or l_stop loop
							l_bc := l_text.item (i).as_lower
							if l_bc.is_character_8 and then l_bc.to_character_8.is_alpha_numeric then
								if not l_used_character.has (l_bc) then
										-- Usable character
									l_stop := l_bc = c
									if not l_stop then
										l_used_character.force_last (l_bc)
											-- Force exit in searching text, as we have found a usable character
										i := l_count
									end
								end
							end
							i := i + 1
						end
						l_buttons.forth
					end
				end
			end

			if l_stop and then l_button /= Void then
				l_button.select_actions.call ([])
			end
		end

	move_to_previous_dialog_button
			-- Moves to a previous dialog button, if a dialog button has focus
		local
			l_buttons: DS_SET_CURSOR [INTEGER]
			l_dialog_buttons: like dialog_window_buttons
			l_button: EV_BUTTON
			l_prev_button: EV_BUTTON
			l_stop: BOOLEAN
			l_count: INTEGER
		do
			l_count := buttons.count
			if l_count > 1 then
				l_buttons := buttons.new_cursor
				l_dialog_buttons := dialog_window_buttons
				from l_buttons.start until l_buttons.after or l_stop loop
					l_prev_button := l_button
					l_button := l_dialog_buttons.item (l_buttons.item)
					if l_button.has_focus then
						l_stop := True
						if l_buttons.is_first then
							from until l_buttons.after loop
								l_button := l_dialog_buttons.item (l_buttons.item)
								l_buttons.forth
							end
						else
							l_button := l_prev_button
						end
						check l_button_attached: l_button /= Void end
						l_button.set_focus
					else
						l_buttons.forth
					end
				end
			end
		end

	move_to_next_dialog_button
			-- Moves to a previous dialog button, if a dialog button has focus
		local
			l_buttons: DS_SET_CURSOR [INTEGER]
			l_dialog_buttons: like dialog_window_buttons
			l_button: EV_BUTTON
			l_first_button: EV_BUTTON
			l_stop: BOOLEAN
			l_count: INTEGER
		do
			l_count := buttons.count
			if l_count > 1 then
				l_buttons := buttons.new_cursor
				l_dialog_buttons := dialog_window_buttons
				from l_buttons.start until l_buttons.after or l_stop loop
					l_button := l_dialog_buttons.item (l_buttons.item)
					if l_buttons.is_first then
						l_first_button := l_button
					end
					if l_button.has_focus then
						l_stop := True
						l_buttons.forth
						if l_buttons.after then
							l_button := l_first_button
						else
							l_button := l_dialog_buttons.item (l_buttons.item)
						end
						check l_button_attached: l_button /= Void end
						l_button.set_focus
					else
						l_buttons.forth
					end
				end
			end
		end

feature {NONE} -- Formatting

	format_text (a_text: STRING_32): STRING_32
			-- Format text to remove trailing new lines
		require
			a_text_attached: a_text /= Void
		do
			Result := a_text.twin
			if not Result.is_empty then
				Result.prune_all_trailing ('%N')
			end
		ensure
			result_attached: Result /= Void
			result_free_of_trailing_new_lines: not Result.is_empty implies Result.item (Result.count) /= '%N'
		end

feature {NONE} -- Action handlers

	on_handle_key (a_key: EV_KEY; a_alt: BOOLEAN; a_ctrl: BOOLEAN; a_shift: BOOLEAN; a_released: BOOLEAN): BOOLEAN
			-- Called when the dialog recieve a key event
			--
			-- `a_key': The key pressed.
			-- `a_alt': True if the ALT key was pressed; False otherwise
			-- `a_ctrl': True if the CTRL key was pressed; False otherwise
			-- `a_shift': True if the SHIFT key was pressed; False otherwise
			-- `a_released': True if the key event pertains to the release of a key, False to indicate a press.
		do
			if a_released and not a_alt and not a_ctrl and not a_shift then
				Result := True
				inspect a_key.code
				when {EV_KEY_CONSTANTS}.key_left then
					move_to_previous_dialog_button
				when {EV_KEY_CONSTANTS}.key_right then
					move_to_next_dialog_button
				else
					activate_button_using_key (a_key)
					Result := not is_shown
					Result := False
				end
			end

			if not Result then
				Result := Precursor {ES_DIALOG} (a_key, a_alt, a_ctrl, a_shift, a_released)
			end
		end

invariant
	prompt_sub_title_label_attached: prompt_sub_title_label /= Void
	prompt_text_attached: prompt_text /= Void


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
