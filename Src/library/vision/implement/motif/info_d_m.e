indexing

	description: 
		"EiffelVision implemenation of Motif information dialog.";
	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"

class 
	INFO_D_M 

inherit

	INFO_D_I;

	MESSAGE_D_M
		undefine
			clean_up, create_widget
		redefine
			make, dialog_shell, screen_object
		end;

	MEL_INFORMATION_DIALOG
		rename
			make as mel_info_make,
			make_no_auto_unmanage as mel_info_make_no_auto,
			foreground_color as mel_foreground_color,
			background_color as mel_background_color,
			background_pixmap as mel_background_pixmap,
			set_background_color as mel_set_background_color,
			set_foreground_color as mel_set_foreground_color,
			set_background_pixmap as mel_set_background_pixmap,
			destroy as mel_destroy,
			screen as mel_screen,
            is_shown as shown
		undefine
			raise, lower, show, hide
		redefine
			dialog_shell, screen_object
		select 
			mel_info_make, mel_info_make_no_auto
		end

creation

	make

feature {NONE} -- Initialization

	make (an_information_dialog: INFO_D) is
			-- Create a motif information dialog.
		do
			widget_index := widget_manager.last_inserted_position;
			mel_info_make_no_auto (an_information_dialog.identifier,
				mel_parent (an_information_dialog, widget_index));
			an_information_dialog.set_dialog_imp (Current);
			action_target := screen_object;
			initialize (dialog_shell)
		end

feature -- Access

	dialog_shell: MEL_DIALOG_SHELL
			-- Dialog shell of the working dialog

	screen_object: POINTER
			-- Associated widget C pointer

end -- class INFO_D_M

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
