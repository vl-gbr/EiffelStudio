--|---------------------------------------------------------------
--|   Copyright (C) Interactive Software Engineering, Inc.      --
--|    270 Storke Road, Suite 7 Goleta, California 93117        --
--|                   (805) 685-1006                            --
--| All rights reserved. Duplication or distribution prohibited --
--|---------------------------------------------------------------

-- Information given by ArchiVision when a window is mapped.
-- X event associated: `MapNotify'

indexing

	date: "$Date$";
	revision: "$Revision$"

class MAPNOT_DATA 

inherit

	CONTEXT_DATA
		undefine
			make
		end

creation

	make

feature 

	make (a_widget: WIDGET) is
			-- Create a context_data for `MapNotify' event.
		do
			widget := a_widget
		end

end
