-- Eiffel class generated by the 2.3 to 3 translator.

--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------

-- A timer manager implementation.

indexing

	date: "$Date$";
	revision: "$Revision$"

deferred class TIMER_I 

inherit

	G_ANY
		export
			{NONE} all
		end



	
feature 

	is_call_back_set: BOOLEAN is
			-- Is a call back already set ?
		deferred
		end; -- is_call_back_set

	is_regular_call_back: BOOLEAN is
			-- Is the call back set a regular one ?
		require
			is_call_back_set
		deferred
		end; -- is_regular_call_back

	set_next_call_back (a_delay: INTEGER; a_command: COMMAND; an_argument: ANY) is            -- Set `a_command' with `argument' to execute when `a_delay';
			-- in milliseconds has expired.
		require
			no_call_back_already_set: not is_call_back_set;
			a_delay_positive_and_not_null: a_delay > 0;
			not_a_command_void: not (a_command = Void)
		deferred
		ensure
			is_call_back_set and (not is_regular_call_back)
		end; -- set_next_call_back

	set_no_call_back is
			-- Remove any call-back already set.
		require
			a_call_back_must_be_set: is_call_back_set
		deferred
		ensure
			not is_call_back_set
		end; -- set_no_call_back

	set_regular_call_back (a_time: INTEGER; a_command: COMMAND; an_argument: ANY) is
			-- Set `a_command' with `argument' to execute all the `a_time'
			-- milliseconds.
		require
			no_call_back_already_set: not is_call_back_set;
			a_time_positive_and_not_null: a_time >0;
			not_a_command_void: not (a_command = Void)
		deferred
		ensure
			is_call_back_set and is_regular_call_back
		end -- set_regular_call_back

end -- class TIMER_I
