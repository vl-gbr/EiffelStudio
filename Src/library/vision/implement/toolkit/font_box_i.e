-- Eiffel class generated by the 2.3 to 3 translator.

--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------

-- 

indexing

	date: "$Date$";
	revision: "$Revision$"

deferred class FONT_BOX_I 

inherit

	TERMINAL_I



	
feature 

	add_apply_action (a_command: COMMAND; argument: ANY) is
			-- Add `a_command' to the list of action to execute when
			-- apply button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- add_apply_action

	add_cancel_action (a_command: COMMAND; argument: ANY) is
			-- Add `a_command' to the list of action to execute when
			-- cancel button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- add_cancel_action

	add_ok_action (a_command: COMMAND; argument: ANY) is
			-- Add `a_command' to the list of action to execute when
			-- ok button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- add_ok_action

	font: FONT is
			-- Font currently selected by the user
		deferred
		ensure
			not (Result = Void)
		end; -- font

	hide_apply_button is
			-- Make apply button invisible.
		deferred
		end; -- hide_apply_button

	hide_cancel_button is
			-- Make cancel button invisible.
		deferred
		end; -- hide_cancel_button

	hide_ok_button is
			-- Make ok button invisible.
		deferred
		end; -- hide_ok_button

	remove_apply_action (a_command: COMMAND; argument: ANY) is
			-- Remove `a_command' from the list of action to execute when
			-- apply button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- remove_apply_action

	remove_cancel_action (a_command: COMMAND; argument: ANY) is
			-- Remove `a_command' from the list of action to execute when
			-- cancel button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- remove_cancel_action

	remove_ok_action (a_command: COMMAND; argument: ANY) is
			-- Remove `a_command' from the list of action to execute when
			-- ok button is activated.
		require
			not_a_command_void: not (a_command = Void)
		deferred
		end; -- remove_ok_action

	set_font (a_font: FONT) is
			-- Edit `a_font'.
		require
			a_font_exists: not (a_font = Void)
		deferred
		end; -- set_font

	show_apply_button is
			-- Make apply button visible.
		deferred
		end; -- show_apply_button

	show_cancel_button is
			-- Make cancel button visible.
		deferred
		end; -- show_cancel_button

	show_ok_button is
			-- Make ok button visible.
		deferred
		end -- show_ok_button

end -- class FONT_BOX_I
