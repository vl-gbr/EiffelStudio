indexing
	description: "Objects that represent the generation tab in the project settings."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GB_SYSTEM_GENERATION_TAB

inherit
	
	GB_SYSTEM_TAB
	
	GB_NAMING_UTILITIES
		undefine
			is_equal, copy, default_create
		end
	
	GB_SHARED_TOOLS
		undefine
			is_equal, copy, default_create
		end
		
	GB_CONSTANTS

feature {NONE} -- Initialization

	initialize is
			-- Initialize `Current' and build widget structure.
		local
			label: EV_LABEL
			frame: EV_FRAME
			vertical_box: EV_VERTICAL_BOX
		do
			create local_check_button.make_with_text ("Local declarations grouped?")
			extend (local_check_button)
			create attributes_local_check_button.make_with_text ("attributes declared as locals?")
			extend (attributes_local_check_button)
			create debugging_check_button.make_with_text ("Generate debugging information?")
			extend (debugging_check_button)
--			create frame.make_with_text ("Build type")
--			extend (frame)
--			create vertical_box
--			frame.extend (vertical_box)
--			create project_radio_button.make_with_text ("Project")
--			vertical_box.extend (project_radio_button)
--			create class_radio_button.make_with_text ("Class")
--			vertical_box.extend (class_radio_button)
--			create label.make_with_text ("Window class name:")
--			extend (label)
--			create main_window_class_name_field
--			extend (main_window_class_name_field)
--			main_window_class_name_field.change_actions.extend (agent update_file_entry)
--			create label.make_with_text ("Window file name:")
--			extend (label)
--			create main_window_file_name_field
--			extend (main_window_file_name_field)
--			create frame.make_with_text ("Code Generation")
--			create local_check_button.make_with_text ("Local declarations grouped?")
--			frame.extend (local_check_button)
--			extend (frame)

			is_initialized := True
			disable_all_items (Current)
			align_labels_left (Current)
		end
		
feature -- Access

	name: STRING is "Generation"
		-- Name to be displayed for `Current'.
		
feature -- Status setting

	update_attributes (project_settings: GB_PROJECT_SETTINGS) is
			-- Update all attributes of `Current' to reflect information
			-- in `project_settings'.
		do
--			main_window_class_name_field.set_text (project_settings.main_window_class_name)
--			main_window_file_name_field.set_text (project_settings.main_window_file_name)
--			if project_settings.complete_project then
--				project_radio_button.enable_select
--			else
--				class_radio_button.enable_select
--			end
			if project_settings.grouped_locals then
				local_check_button.enable_select
			else
				local_check_button.disable_select
			end
		end
		
	save_attributes (project_settings: GB_PROJECT_SETTINGS) is
			-- Save all attributes of `Current' into `project_settings'.
		do
--			project_settings.set_main_window_class_name (main_window_class_name_field.text)
--			project_settings.set_main_window_file_name (main_window_file_name_field.text)
--			if project_radio_button.is_selected then
--				project_settings.enable_complete_project
--			else
--				project_settings.disable_complete_project
--			end
			if local_check_button.is_selected then
				project_settings.enable_grouped_locals
			else
				project_settings.disable_grouped_locals
			end
		end	

feature {GB_SYSTEM_WINDOW} -- Implementation

	validate is
			-- Validate input fields of `Current'.
		local
			warning_dialog: EV_WARNING_DIALOG
		do
			validate_successful := True
--			if not valid_class_name (main_window_class_name_field.text) then
--				select_in_parent
--				create warning_dialog.make_with_text (main_window_class_name_field.text + Class_invalid_name_warning)
--				warning_dialog.show_modal_to_window (main_window)
--				validate_successful := False
--			elseif main_window_file_name_field.text.is_empty then
--				select_in_parent
--				create warning_dialog.make_with_text ("Please enter a file name.")
--				warning_dialog.show_modal_to_window (main_window)
--				validate_successful := False
--			end
		end
		

feature {NONE} -- Implementation

--	update_file_entry is
--			-- Update the file name according to the class name.
--		local
--			str: STRING
--		do
--			str := main_window_class_name_field.text
--			if str /= Void then
--				str.right_adjust
--				str.left_adjust
--			end
--			if str = Void or else str.is_empty then
--				main_window_file_name_field.remove_text
--			else
--				str.to_lower
--				str.append (".e")
--				main_window_file_name_field.set_text (str)
--			end
--		end

--	project_radio_button: EV_RADIO_BUTTON
--		-- Selects the generate project option.
--	
--	class_radio_button: EV_RADIO_BUTTON
--		-- Selects the generate class option.
--		
--	main_window_class_name_field: EV_TEXT_FIELD
--		-- Holds the name used for the generated window class.
--	
--	main_window_file_name_field: EV_TEXT_FIELD
--		-- Holds the name used for gnerated window file name.
--		
	local_check_button: EV_CHECK_BUTTON
		-- Holds whether the locals should be grouped or on a single line.

	attributes_local_check_button: EV_CHECK_BUTTON
		-- Should all locals be declared in `initialize' or as attributes of class?
		
	debugging_check_button: EV_CHECK_BUTTON
		-- Should debugging information be generated for events?

end -- class GB_SYSTEM_GENERATION_TAB
