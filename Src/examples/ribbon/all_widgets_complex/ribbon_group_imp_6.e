note
	description: "[
					Generated by EiffelRibbon tool
					Don't edit this file, since it will be replaced by EiffelRibbon tool
					generated files everytime
																							]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RIBBON_GROUP_IMP_6

inherit
	EV_RIBBON_GROUP

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects
		do
			create combobox_1.make_with_command_list (<<{COMMAND_NAME_CONSTANTS}.combobox_1>>)

			create buttons.make (1)
			buttons.extend (combobox_1)

		end

feature -- Query

	combobox_1: COMBOBOX_1


end

