indexing

	description: 
		"EiffelVision text area, gtk implementation."
	status: "See notice at end of class"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"
	
class
	EV_TEXT_IMP
	
inherit
	EV_TEXT_I
		redefine
			interface,
			text_length
		end

	EV_TEXT_COMPONENT_IMP
		redefine
			interface,
			insert_text,
			initialize,
			create_change_actions,
			dispose,
			text_length,
			remove_selection_on_lose_focus
		end
		
	EV_FONTABLE_IMP
		redefine
			interface,
			visual_widget,
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create a gtk text view.
		do
			base_make (an_interface)
			set_c_object (feature {EV_GTK_EXTERNALS}.gtk_event_box_new)
			scrolled_window := feature {EV_GTK_EXTERNALS}.gtk_scrolled_window_new (NULL, NULL)
			feature {EV_GTK_EXTERNALS}.gtk_widget_show (scrolled_window)
			feature {EV_GTK_EXTERNALS}.gtk_container_add (c_object, scrolled_window)
			text_view := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_new
			feature {EV_GTK_EXTERNALS}.gtk_widget_show (text_view)
			feature {EV_GTK_EXTERNALS}.gtk_container_add (scrolled_window, text_view)
			text_buffer := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_get_buffer (text_view)
			feature {EV_GTK_EXTERNALS}.object_ref (text_buffer)
			feature {EV_GTK_EXTERNALS}.gtk_widget_set_usize (text_view, 1, 1)
				-- This is needed so the text doesn't influence the size of the whole widget itself.
		end
		
	create_change_actions: EV_NOTIFY_ACTION_SEQUENCE is
			-- Hook up the change actions for the text widget
		do
			Result := Precursor {EV_TEXT_COMPONENT_IMP}
			real_signal_connect (text_buffer, "changed", agent (App_implementation.gtk_marshal).text_component_change_intermediary (c_object), Void)
		end
		
	initialize is
			-- Initialize `Current'
		do
			enable_word_wrapping
			set_editable (True)
			Precursor {EV_TEXT_COMPONENT_IMP}
		end
		
feature -- Access

	clipboard_content: STRING is
			-- `Result' is current clipboard content.
		do
			Result := App_implementation.clipboard.text
		end

feature -- Status report

	line_number_from_position (i: INTEGER): INTEGER is
			-- Line containing caret position `i'.
		local
			a_text_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			from
				create a_text_iter.make
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_text_iter.item, i - 1)
			until
				not feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_backward_display_line (text_view, a_text_iter.item)
			loop
				Result := Result + 1
			end
			Result := Result.max (1)
		end

	is_editable: BOOLEAN
			-- Is the text editable by the user?

	has_selection: BOOLEAN is
			-- Does `Current' have a selection?
		do
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_selection_bounds (text_buffer, NULL, NULL)
		end

	selection_start: INTEGER is
			-- Index of the first character selected.
		do
			Result := selection_start_internal
		end

	selection_end: INTEGER is
			-- Index of the last character selected.
		do
			Result := selection_end_internal
		end

feature -- Status setting
	
	set_editable (flag: BOOLEAN) is
			-- if `flag' then make the component read-write.
			-- if not `flag' then make the component read-only.
		do
			is_editable := flag
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_set_editable (text_view, flag)
		end

	set_caret_position (pos: INTEGER) is
			-- set current insertion position
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_iter.item, pos - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_place_cursor (text_buffer, a_iter.item)
		end

feature -- Basic operation

	select_region (start_pos, end_pos: INTEGER) is
			-- Select (hilight) the text between 
			-- `start_pos' and `end_pos'. Both `start_pos' and
			-- `end_pos' are selected.
		local
			a_start_iter, a_end_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_start_iter.make
			create a_end_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_start_iter.item, start_pos - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_end_iter.item, end_pos)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_move_mark (
										text_buffer,
										feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_selection_bound (text_buffer),
										a_start_iter.item
			)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_move_mark (
										text_buffer,
										feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_insert (text_buffer),
										a_end_iter.item
			)
		end	

	deselect_all is
			-- Unselect the current selection.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_mark (
											text_buffer,
											a_iter.item,
											feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_insert (text_buffer)
			)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_move_mark (
										text_buffer,
										feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_selection_bound (text_buffer),
										a_iter.item
			)
		end	

	delete_selection is
			-- Delete the current selection.
		do
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_delete_selection (text_buffer, True, True)
		end

	cut_selection is
			-- Cut `selected_region' by erasing it from
			-- the text and putting it in the Clipboard to paste it later.
			-- If `selectd_region' is empty, it does nothing.
		local
			clip_imp: EV_CLIPBOARD_IMP
		do
			if has_selection then
				clip_imp ?= App_implementation.clipboard.implementation
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_cut_clipboard (text_buffer, clip_imp.clipboard, True)
			end
		end

	copy_selection is
			-- Copy `selected_region' into the Clipboard.
			-- If the `selected_region' is empty, it does nothing.
		local
			clip_imp: EV_CLIPBOARD_IMP
		do
			if has_selection then
				clip_imp ?= App_implementation.clipboard.implementation
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_copy_clipboard (text_buffer, clip_imp.clipboard)				
			end
		end

	paste (index: INTEGER) is
			-- Insert the contents of the clipboard 
			-- at `index' postion of `text'.
			-- If the Clipboard is empty, it does nothing.
		local
			clip_imp: EV_CLIPBOARD_IMP
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			clip_imp ?= App_implementation.clipboard.implementation
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_iter.item, index - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_paste_clipboard (text_buffer, clip_imp.clipboard, a_iter.item, True)
		end		

feature -- Access

	text: STRING is
		local
			a_start_iter, a_end_iter: EV_GTK_TEXT_ITER_STRUCT
			temp_text: POINTER
			a_cs: EV_GTK_C_STRING
		do
			create a_start_iter.make
			create a_end_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_bounds (text_buffer, a_start_iter.item, a_end_iter.item)
			temp_text := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_text (text_buffer, a_start_iter.item, a_end_iter.item, False)
			create a_cs.make_from_pointer (temp_text)
			Result := a_cs.string
			feature {EV_GTK_EXTERNALS}.g_free (temp_text)
		end

	line (a_line: INTEGER): STRING is
			-- Returns the content of line `a_line'.
		local
			a_start_iter: EV_GTK_TEXT_ITER_STRUCT
			a_end_iter: POINTER
			temp_text: POINTER
			a_success: BOOLEAN
			i: INTEGER
			a_cs: EV_GTK_C_STRING
		do
			create a_start_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_start_iter (text_buffer, a_start_iter.item)
			from
				i := 1
			until
				i = a_line
			loop
				a_success := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line (text_view, a_start_iter.item)
				i := i + 1
			end
			
			a_end_iter := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_copy (a_start_iter.item)
			a_success := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line_end (text_view, a_end_iter)
			
			if feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_ends_line (a_end_iter) then
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_forward_char (a_end_iter)
			end

			
			temp_text := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_text (text_buffer, a_start_iter.item, a_end_iter, True)--False)
			create a_cs.make_from_pointer (temp_text)
			Result := a_cs.string
			
			feature {EV_GTK_EXTERNALS}.g_free (temp_text)
			feature {EV_GTK_EXTERNALS}.g_free (a_end_iter)
		end
		
	first_position_from_line_number (a_line: INTEGER): INTEGER is
			-- Position of the first character on line `a_line'.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
			a_success: BOOLEAN
			i: INTEGER
		do
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_start_iter (text_buffer, a_iter.item)
			from
				i := 1
			until
				i = a_line
			loop
				a_success := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line (text_view, a_iter.item)
				i := i + 1
			end
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_iter.item) + 1
		end

	last_position_from_line_number (a_line: INTEGER): INTEGER is
			-- Position of the last character on line `a_line'.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
			a_success: BOOLEAN
			i: INTEGER
		do
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_start_iter (text_buffer, a_iter.item)
			from
				i := 1
			until
				i = a_line
			loop
				a_success := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line (text_view, a_iter.item)
				i := i + 1
			end
			a_success := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line_end (text_view, a_iter.item)
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_iter.item) + 1
		end

feature -- Status report

	text_length: INTEGER is
			-- Number of characters in `Current'
		do
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_char_count (text_buffer)
		end

	line_count: INTEGER is
			-- Number of display lines present in widget.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
			
		do
			from
				Result := 1
				create a_iter.make
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_start_iter (text_buffer, a_iter.item)
			until
				not feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_forward_display_line (text_view, a_iter.item)
			loop
				Result := Result + 1
			end
		end

	current_line_number: INTEGER is
			-- Returns the number of the display line the cursor currently
			-- is on.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			-- Count the number of iterations from insert marker to end of text.
			from
				create a_iter.make
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_mark (
									text_buffer,
									a_iter.item,
									feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_insert (text_buffer)
				)
			until
				not feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_backward_display_line (text_view, a_iter.item)
			loop
				Result := Result + 1
			end			
			Result := Result.max (1)
		end

	caret_position: INTEGER is
			-- Current position of the caret.
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_iter.make
			-- Initialize out iter with the current caret/insert position.
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_mark (
								text_buffer,
								a_iter.item,
								feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_insert (text_buffer)
			)
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_iter.item) + 1
		end
		
	has_word_wrapping: BOOLEAN
			-- Does `Current' have word wrapping enabled?

feature -- Status setting
	
	insert_text (a_text: STRING) is
		local
			a_cs: EV_GTK_C_STRING
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_cs.make (a_text)
			create a_iter.make
			-- Initialize out iter with the current caret/insert position.
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_mark (
								text_buffer,
								a_iter.item,
								feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_insert (text_buffer)
			)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_insert (text_buffer, a_iter.item, a_cs.item, -1)
		end
	
	set_text (a_text: STRING) is
		local
			a_cs: EV_GTK_C_STRING
		do
			create a_cs.make (a_text)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_set_text (text_buffer, a_cs.item, -1)
		end
		
	append_text (a_text: STRING) is
			-- Append `a_text' to `text'.
		do
			append_text_internal (text_buffer, a_text)
		end

	prepend_text (a_text: STRING) is
			-- Prepend 'txt' to `text'.
		local
			a_cs: EV_GTK_C_STRING
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_cs.make (a_text)
			create a_iter.make
			-- Initialize out iter with the current caret/insert position.
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_start_iter (text_buffer, a_iter.item)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_insert (text_buffer, a_iter.item, a_cs.item, -1)
		end
	
	delete_text (start, finish: INTEGER) is
			-- Delete the text between `start' and `finish' index
			-- both sides include.
		local
			a_start_iter, a_end_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_start_iter.make
			create a_end_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_start_iter.item, start - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_offset (text_buffer, a_end_iter.item, finish - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_delete (text_buffer, a_start_iter.item, a_end_iter.item)
		end

feature -- Basic operation

	scroll_to_line (i: INTEGER) is
		local
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_iter.make
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_iter_at_line (text_buffer, a_iter.item, i - 1)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_scroll_to_iter (text_view, a_iter.item,  0.0, False, 0.0, 0.0)
		end
		
	enable_word_wrapping is
			-- 
		do
			-- Make sure only vertical scrollbar is showing
			feature {EV_GTK_EXTERNALS}.gtk_scrolled_window_set_policy (
				scrolled_window, 
				feature {EV_GTK_EXTERNALS}.GTK_POLICY_AUTOMATIC_ENUM,
				feature {EV_GTK_EXTERNALS}.GTK_POLICY_ALWAYS_ENUM
			)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_set_wrap_mode (text_view, feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_wrap_word_enum)
			has_word_wrapping := True
		end
		
	disable_word_wrapping is
			--
		do
			-- Make sure both scrollbars are showing
			feature {EV_GTK_EXTERNALS}.gtk_scrolled_window_set_policy (
				scrolled_window, 
				feature {EV_GTK_EXTERNALS}.GTK_POLICY_ALWAYS_ENUM,
				feature {EV_GTK_EXTERNALS}.GTK_POLICY_ALWAYS_ENUM
			)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_view_set_wrap_mode (text_view, feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_wrap_none_enum)
			has_word_wrapping := False
		end
		
feature {NONE} -- Implementation

	remove_selection_on_lose_focus: BOOLEAN is
			-- Should `Current' lose selection when focus is lost?
		do
			Result := False
		end

	selection_start_internal: INTEGER is
			-- Index of the first character selected.
		local
			a_start_iter, a_end_iter: EV_GTK_TEXT_ITER_STRUCT
			a_selected: BOOLEAN
			a_start_offset, a_end_offset: INTEGER
		do
			create a_start_iter.make
			create a_end_iter.make
			a_selected := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_selection_bounds (text_buffer, a_start_iter.item, a_end_iter.item)
			if a_selected then
				a_start_offset := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_start_iter.item)
				a_end_offset := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_end_iter.item)
				Result := a_start_offset.min (a_end_offset) + 1
			end
		end

	selection_end_internal: INTEGER is
			-- Index of the last character selected.
		local
			a_start_iter, a_end_iter: EV_GTK_TEXT_ITER_STRUCT
			a_selected: BOOLEAN
			a_start_offset, a_end_offset: INTEGER
		do
			create a_start_iter.make
			create a_end_iter.make
			a_selected := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_selection_bounds (text_buffer, a_start_iter.item, a_end_iter.item)
			if a_selected then
				a_start_offset := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_start_iter.item)
				a_end_offset := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_iter_get_offset (a_end_iter.item)
				Result := a_start_offset.max (a_end_offset)
			end
		end

	dispose is
			-- Clean up `Current'
		do
			Precursor {EV_TEXT_COMPONENT_IMP}
			feature {EV_GTK_EXTERNALS}.object_unref (text_buffer)
		end

	on_change_actions is
			-- The text within the widget has changed.
		do
			change_actions_internal.call (App_implementation.gtk_marshal.Empty_tuple)
		end

	append_text_internal (a_text_buffer: POINTER; a_text: STRING) is
			-- Append `txt' to `text'.
		local
			a_cs: EV_GTK_C_STRING
			a_iter: EV_GTK_TEXT_ITER_STRUCT
		do
			create a_cs.make (a_text)
			create a_iter.make
			-- Initialize out iter with the current caret/insert position.
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_end_iter (a_text_buffer, a_iter.item)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_insert (a_text_buffer, a_iter.item, a_cs.item, -1)
		end
		
	text_view: POINTER
		-- Pointer to the GtkTextView widget
		
	scrolled_window: POINTER
		-- Pointer to the GtkScrolledWindow

	text_buffer: POINTER
		-- Pointer to the GtkTextBuffer.

feature {EV_ANY_I} -- Implementation

	interface: EV_TEXT

end -- class EV_TEXT_IMP

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

