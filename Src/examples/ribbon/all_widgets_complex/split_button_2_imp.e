﻿note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SPLIT_BUTTON_2_IMP

inherit
	EV_RIBBON_SPLIT_BUTTON
			redefine
				create_interface_objects
			end
			
feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			Precursor
			create button_6.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.button_6>>)
			create button_7.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.button_7>>)

			create buttons.make (1)
			buttons.extend (button_6)
			buttons.extend (button_7)

		end

feature -- Query

	button_6: BUTTON_6
	button_7: BUTTON_7


end

