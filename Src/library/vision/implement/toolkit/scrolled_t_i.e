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

deferred class SCROLLED_T_I 

inherit

	TEXT_I



	
feature 

	show_vertical_scrollbar is
			-- Make vertical scrollbar visible.
		deferred
		end; -- show_vertical_scrollbar

	hide_vertical_scrollbar is
			-- Make vertical scrollbar invisible.
		deferred
		end; -- hide_vertical_scrollbar

	show_horizontal_scrollbar is
			-- Make horizontal scrollbar visible.
		deferred
		end; -- show_horizontal_scrollbar

	hide_horizontal_scrollbar is
			-- Make horizontal scrollbar invisible.
		deferred
		end; -- hide_horizontal_scrollbar

	is_vertical_scrollbar: BOOLEAN is
			-- Is vertical scrollbar visible?
		deferred
		end; -- is_vertical_scrollbar

	is_horizontal_scrollbar: BOOLEAN is
			-- Is horizontal scrollbar visible?
		deferred
		end -- is_horizontal_scrollbar

end -- class SCROLLED_T_I
