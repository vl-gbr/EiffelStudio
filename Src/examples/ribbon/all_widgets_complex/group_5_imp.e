note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GROUP_5_IMP

inherit
	EV_RIBBON_GROUP

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create spinner_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.spinner_1>>)
			create button_spinner_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.button_spinner_1>>)

			create buttons.make (1)
			buttons.extend (spinner_1)
			buttons.extend (button_spinner_1)

		end

feature -- Query

	spinner_1: SPINNER_1
	button_spinner_1: BUTTON_SPINNER_1


end

