indexing
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_CUSTOMIZED_FORMATTER_DIALOG

inherit
	EB_CUSTOMIZED_FORMATTER_DIALOG_IMP

	EB_CUSTOMIZED_FORMATTER_UTILITY
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_CONSTANTS
		undefine
			copy,
			is_equal,
			default_create
		end

	EVS_GRID_TWO_WAY_SORTING_ORDER
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_SHARED_WINDOW_MANAGER
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			copy,
			is_equal,
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_formatter_getter: like formatter_getter) is
			-- Initialize `formatter_getter' with `a_formatter_getter'.
		require
			a_formatter_getter_attached: a_formatter_getter /= Void
		do
			formatter_getter := a_formatter_getter
			create ok_actions
			create cancel_actions
			create descriptors.make (10)
			create formatter_grid
			create formatter_grid_wrapper.make (formatter_grid)
			create descriptor_row_table.make (10)
			default_create
			next_new_formatter_index := 1
		end

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			select_formatter_label.set_text (interface_names.l_select_formatter)
			select_formatter_label.set_minimum_width (350)
			set_minimum_size (600, 400)
			set_title (interface_names.t_customized_formatter_setup)
			ok_button.set_text (interface_names.b_ok)
			ok_button.select_actions.extend (agent on_ok)
			cancel_button.set_text (interface_names.b_cancel)
			cancel_button.select_actions.extend (agent on_cancel)

			create helper_label
			helper_label.set_minimum_height (50)
			helper_label.align_text_left
			help_area.extend (helper_label)

			add_formatter_button.set_pixmap (pixmaps.icon_pixmaps.general_add_icon)
			add_formatter_button.set_tooltip (interface_names.f_add_formatter)
			add_formatter_button.select_actions.extend (agent on_add_formatter)

			remove_formatter_button.set_pixmap (pixmaps.icon_pixmaps.general_remove_icon)
			remove_formatter_button.set_tooltip (interface_names.f_remove_formatter)
			remove_formatter_button.select_actions.extend (agent on_remove_formatter)
			remove_formatter_button.disable_sensitive

				-- Setup `formatter_grid'.
			formatter_grid_area.extend (formatter_grid)
			setup_formatter_grid

				-- Setup `property_grid'.
			create property_grid.make_with_description (helper_label)
			property_grid_area.extend (property_grid)
			setup_property_grid

			show_actions.extend (agent on_shown)

			set_default_cancel_button (cancel_button)
		end

feature -- Access

	formatter_descriptors: LIST [EB_CUSTOMIZED_FORMATTER_DESP] is
			-- List of formatters descriptors defined in Current dialog
		local
			l_descriptors: like descriptors
			l_cursor: DS_ARRAYED_LIST_CURSOR [EB_CUSTOMIZED_FORMATTER_DESP]
		do

			create {LINKED_LIST [EB_CUSTOMIZED_FORMATTER_DESP]} Result.make
			l_descriptors := descriptors
			l_cursor := descriptors.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.extend (l_cursor.item)
				l_cursor.forth
			end
		ensure
			result_attached: Result /= Void
		end

	descriptors: DS_ARRAYED_LIST [EB_CUSTOMIZED_FORMATTER_DESP]
			-- List of formatters

	ok_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when "OK" button is pressed

	cancel_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be performed when "Cancel" button is pressed

	formatter_getter: FUNCTION [ANY, TUPLE, like formatter_descriptors]
			-- Agent to get formatter information

	tool_table: HASH_TABLE [TUPLE [display_name: STRING_GENERAL; pixmap: EV_PIXMAP], STRING] is
			-- Table of supported tools			
		local
			l_tool_info: like tool_info
			l_tools: LINKED_LIST [EB_TOOL]
			l_tool_manager: EB_DEVELOPMENT_WINDOW_TOOLS
		do
			create Result.make (20)
			l_tool_manager := window_manager.last_focused_development_window.tools
			create l_tools.make
			l_tools.extend (l_tool_manager.class_tool)
			l_tools.extend (l_tool_manager.features_relation_tool)
			l_tools.extend (l_tool_manager.dependency_tool)
			from
				l_tools.start
			until
				l_tools.after
			loop
				l_tool_info := tool_info (l_tools.item)
				Result.put ([l_tool_info.display_name, l_tool_info.pixmap], l_tool_info.store_name)
				l_tools.forth
			end
		ensure
			result_attached: Result /= Void
		end

	tool_info (a_tool: EB_TOOL): TUPLE [display_name: STRING_GENERAL; pixmap: EV_PIXMAP; store_name: STRING] is
			-- Return information about `a_tool'
		require
			a_tool_attached: a_tool /= Void
		do
			Result := [a_tool.title, a_tool.pixmap, a_tool.title_for_pre]
		ensure
			result_attached: Result /= Void
		end

	on_formatter_reloaded is
			-- Action to be performed when formatters are reloaded
		do
			set_is_loaded (False)
		end

feature -- Status report

	has_changed: BOOLEAN
			-- Has formatter definition changed?
			-- If True, formatter reloading is needed

	is_loaded: BOOLEAN
			-- Have `formatter_descriptors' been loaded in Current?

feature -- Setting

	set_has_changed (b: BOOLEAN) is
			-- Set `has_changed' with `b'.
		do
			has_changed := b
		ensure
			has_changed_set: has_changed = b
		end

	set_is_loaded (b: BOOLEAN) is
			-- Set `is_loaded' with `b'.
		do
			is_loaded := b
		ensure
			is_loaded_set: is_loaded = b
		end

	load_formatter_descriptors is
			-- Load formatters retrieved from `formatter_getter' into Current.
			-- Keep a copy of retrieved formatters so modification done in Current dialog don't mess up the source.
		local
			l_original_desps: like formatter_descriptors
			l_desps: like formatter_descriptors
		do
			descriptors.wipe_out
			l_original_desps := formatter_getter.item (Void)
			l_desps := descriptors_from_document (xml_document_for_formatter (l_original_desps))
			check l_desps.count = l_original_desps.count end
			from
				l_original_desps.start
				l_desps.start
			until
				l_original_desps.after
			loop
				if l_original_desps.item.is_global_scope then
					l_desps.item.enable_global_scope
				else
					l_desps.item.enable_target_scope
				end
				l_original_desps.forth
				l_desps.forth
			end
			l_desps.do_all (agent descriptors.force_last)
			set_has_changed (False)
		ensure
			not_changed: not has_changed
		end

feature{NONE} -- Actions

	on_shown is
			-- Action to be performed when Current is displayed
		do
			if not is_loaded then
				refresh
			end
			try_resume_last_selection
			set_has_changed (False)
		end

	on_ok is
			-- Action to be performed when "OK" button is pressed
		do
			if is_displayed then
				hide
			end
			ok_actions.call (Void)
		end

	on_cancel is
			-- Action to be performed when "Cancel" button is pressed
		do
			if is_displayed then
				hide
			end
			if has_changed then
				set_is_loaded (False)
			end
			cancel_actions.call (Void)
		end

	on_add_formatter is
			-- Action to be performed to add a new customized formatter
		local
			l_descriptor: EB_CUSTOMIZED_FORMATTER_DESP
			l_name: STRING
			l_grid_row: EV_GRID_ROW
			l_grid: like formatter_grid
		do
			l_name := new_formatter_name.twin
			l_name.append (next_new_formatter_index.out)
			create l_descriptor.make (l_name)

			l_descriptor.set_header (string_8_from_string_32 (interface_names.l_formatter_default_header (interface_names.l_ellipsis)))
			l_descriptor.set_temp_header (string_8_from_string_32 (interface_names.l_formatter_default_temp_header (interface_names.l_ellipsis)))
			l_descriptor.enable_global_scope
			descriptors.force_last (l_descriptor)

			l_grid := formatter_grid
			l_grid.column (1).header_item.remove_pixmap
			l_grid.insert_new_row (l_grid.row_count + 1)
			l_grid_row := l_grid.row (l_grid.row_count)
			bind_formatter (l_descriptor, l_grid_row)
			l_grid.remove_selection
			l_grid_row.enable_select
			resize_formatter_grid
			set_has_changed (True)
			next_new_formatter_index := next_new_formatter_index + 1
			descriptor_row_table.put (l_grid_row, l_descriptor)
		ensure
			formatter_index_increased: next_new_formatter_index = old next_new_formatter_index + 1
			changed: has_changed
		end

	on_remove_formatter is
			-- Action to be performed to remove selected customized formatter
		local
			l_row: EV_GRID_ROW
			l_descriptor: EB_CUSTOMIZED_FORMATTER_DESP
			l_grid: like formatter_grid
			l_row_index: INTEGER
			l_row_count: INTEGER
		do
			if not formatter_grid.selected_rows.is_empty then
				l_row := formatter_grid.selected_rows.first
				l_row_index := l_row.index
				l_descriptor ?= l_row.data
				check l_descriptor /= Void end
				descriptor_row_table.remove (l_descriptor)
				descriptors.start
				descriptors.search_forth (l_descriptor)
				if not descriptors.after then
					descriptors.remove_at
				end
				l_grid := formatter_grid
				l_grid.remove_row (l_row_index)
				l_row_count := l_grid.row_count
				if l_row_index > l_row_count then
					l_row_index := l_row_count
				end
				if l_row_index > 0 then
					l_grid.row (l_row_index).enable_select
				else
					on_formatter_deselected (Void)
				end
				set_has_changed (True)
			end
		end

	on_formatter_selected (a_row: EV_GRID_ROW) is
			-- Action to be performed when a formatter contained in `a_row' is selected in `formatter_grid'
		require
			a_row_attached: a_row /= Void
		local
			l_descriptor: EB_CUSTOMIZED_FORMATTER_DESP
		do
			l_descriptor ?= a_row.data
			check l_descriptor /= Void end
			bind_property_grid (l_descriptor)
			set_last_selected_descriptor (l_descriptor)
			select_formatter_label.hide
			property_grid.show
			remove_formatter_button.enable_sensitive
		end

	on_formatter_deselected (a_row: EV_GRID_ROW) is
			-- Action to be performed if `a_row' is deselected in `formatter_grid'
		do
			if formatter_grid.selected_rows.is_empty then
				property_grid.hide
				select_formatter_label.show
				remove_formatter_button.disable_sensitive
			end
		end

	on_displayer_change (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP; a_new_value: HASH_TABLE [TUPLE [view_name: STRING; sorting: STRING], STRING]) is
			-- Action to be performed when displayer/tool of `a_descriptor' changed
		require
			a_descriptor_attached: a_descriptor /= Void
			a_new_value_attached: a_new_value /= Void
		do
			set_has_changed (True)
			a_descriptor.wipe_out_tools
			from
				a_new_value.start
			until
				a_new_value.after
			loop
				a_descriptor.extend_tool (a_new_value.key_for_iteration, a_new_value.item_for_iteration.view_name, a_new_value.item_for_iteration.sorting)
				a_new_value.forth
			end
			refresh_grid_for_descriptor (a_descriptor)
		end

	on_data_change (a_new_data: STRING_32; a_setter: PROCEDURE [ANY, TUPLE [STRING]]; a_refresher: PROCEDURE [ANY, TUPLE]) is
			-- Action to be performed when `a_new_data' changes.
			-- Invoke `a_setter' to set this new data.
			-- After setting, invoke `a_referesh' to refresh Current dialog if `a_refresher' is not Void.
		require
			a_new_data_attached: a_new_data /= Void
			a_setter_attached: a_setter /= Void
		do
			set_has_changed (True)
			a_setter.call ([string_8_from_string_32 (a_new_data)])
			if a_refresher /= Void then
				a_refresher.call (Void)
			end
		end

	on_filter_change (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP; a_filter: BOOLEAN) is
			-- Action to be performed if metric filter status changed for `a_descrptor' from `property_grid'
		require
			a_descriptor_attached: a_descriptor /= Void
		do
			set_has_changed (True)
			a_descriptor.set_is_filter_enabled (a_filter)
		end

	on_scope_change  (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP; a_scope: STRING_32) is
			-- Action to be performed if formatter scope status changed for `a_descrptor' from `property_grid'
		require
			a_descriptor_attached: a_descriptor /= Void
			a_scope_attached: a_scope /= Void
		do
			set_has_changed (True)
			if a_scope.is_equal (interface_names.l_eiffelstudio) then
				a_descriptor.enable_global_scope
			else
				a_descriptor.enable_target_scope
			end
		end

	on_metric_change  (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP; a_metric: STRING_32) is
			-- Action to be performed if formatter metric changed for `a_descrptor' from `property_grid'
		require
			a_descriptor_attached: a_descriptor /= Void
			a_metric_attached: a_metric /= Void
		local
			l_tool_value: HASH_TABLE [TUPLE [view_name: STRING; sorting: STRING], STRING]
			l_metric_name: STRING
			l_metric: EB_METRIC
			l_displayers: EB_FORMATTER_DISPLAYERS
		do
			if property_grid.is_displayed then
					-- Set formatter name.
				if is_default_formatter_name (string_32_from_string_8 (formatter_name_property.value)) and then formatter_name_property /= Void then
					formatter_name_property.set_value (interface_names.first_character_as_upper (a_metric))
				end
					-- Set header.
				if header_property /= Void and then header_property.text.is_equal (interface_names.l_formatter_default_header (interface_names.l_ellipsis).as_string_32) then
					header_property.set_value (interface_names.l_formatter_default_header (interface_names.first_character_as_upper (a_metric)))
				end
					-- Set temp header.
				if temp_header_property /= Void and then temp_header_property.text.is_equal (interface_names.l_formatter_default_temp_header (interface_names.l_ellipsis).as_string_32) then
					temp_header_property.set_value (interface_names.l_formatter_default_temp_header (interface_names.string_general_as_lower (a_metric)))
				end
					-- Set default tools.
				if displayed_in_tools_property /= Void then
					l_tool_value := displayed_in_tools_property.value
					if l_tool_value = Void or else l_tool_value.is_empty then
						l_metric_name := string_8_from_string_32 (a_metric)
						if metric_manager.has_metric (l_metric_name) and then metric_manager.is_metric_valid (l_metric_name) then
							l_metric := metric_manager.metric_with_name (l_metric_name)
							if l_metric.unit = class_unit or l_metric.unit = feature_unit then
								create l_tool_value.make (1)
								create l_displayers
								l_tool_value.put ([l_displayers.domain_displayer, ""], window_manager.last_focused_development_window.tools.class_tool.title_for_pre)
							end
							if l_tool_value /= Void then
								displayed_in_tools_property.set_value (l_tool_value)
								refresh_grid_for_descriptor (a_descriptor)
							end
						end
					end
				end
			end
			set_has_changed (True)
			a_descriptor.set_metric_name (string_32_from_string_8 (a_metric))
		end

	on_key_pressed_in_formatter_grid (a_key: EV_KEY) is
			-- Action to be performed if `a_key' is pressed in `formatter_grid'
		require
			a_key_attached: a_key /= Void
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_insert then
				on_add_formatter
			elseif a_key.code = {EV_KEY_CONSTANTS}.key_delete and then remove_formatter_button.is_sensitive then
				on_remove_formatter
			end
		end

feature {NONE} -- Implementation/Data

	formatter_grid: ES_GRID
			-- Grid to display formatter list

	property_grid: PROPERTY_GRID
			-- Grid to display properties of a formatter

	helper_label: ES_LABEL
			-- Label to display help information

	pixmap_from_file (a_file: STRING): EV_PIXMAP is
			-- Pixmap from file `a_file'.			
			-- If file loading failed, we use a default icon for formatter.
		require
			a_file_attached: a_file /= Void
		local
			l_retried: BOOLEAN
			l_buffer: EV_PIXEL_BUFFER
			l_raw_file: RAW_FILE
		do
			if not l_retried and then not a_file.is_empty then
				create l_raw_file.make (a_file)
				if l_raw_file.exists and then l_raw_file.is_readable then
					create l_buffer
					l_buffer.set_with_named_file (a_file)
					Result := l_buffer.sub_pixmap (create {EV_RECTANGLE}.make (0, 0, l_buffer.width, l_buffer.height))
					Result.stretch (16, 16)
				end
			end
			if Result = Void then
				Result := pixmaps.icon_pixmaps.diagram_export_to_png_icon
			end
		rescue
			l_retried := True
			Result := Void
			retry
		end

	new_formatter_name: STRING is "New formatter #"
			-- Base name for new created formatters

	next_new_formatter_index: INTEGER
			-- Index of next created new formatter

	string_8_from_string_32 (a_string_32: STRING_32): STRING_8 is
			-- STRING_8 from STRING_32
		require
			a_string_32_attached: a_string_32 /= Void
		do
			Result := a_string_32.as_string_8
--			Result := utf16_encoding.convert_to (utf8_encoding, a_string_32).as_string_8
		end

	string_32_from_string_8 (a_string_8: STRING_8): STRING_32 is
			-- STRING_32 from STRING_8
		require
			a_string_8_attached: a_string_8 /= Void
		do
			Result := a_string_8.as_string_32
--			Result := utf16_encoding.convert_to (utf16_encoding, a_string_8).as_string_32
		end

--	utf16_encoding: ENCODING is
--			-- UTF16 encoding
--		once
--			create Result.make ((create {CODE_PAGE_CONSTANTS}).utf16)
--		ensure
--			result_attached: Result /= Void
--		end

--	utf8_encoding: ENCODING is
--			-- UTF8 encoding
--		once
--			create Result.make ((create {CODE_PAGE_CONSTANTS}).utf8)
--		ensure
--			result_attached: Result /= Void
--		end

	display_value (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP): HASH_TABLE [TUPLE [view_name: STRING; sorting: STRING], STRING] is
			-- Displayer value from `a_descriptor'
		require
			a_descriptor_attached: a_descriptor /= Void
		local
			l_tools: HASH_TABLE [STRING, STRING]
			l_sorting: HASH_TABLE [STRING, STRING]
		do
			create Result.make (2)
			l_tools := a_descriptor.tools
			l_sorting := a_descriptor.sorting_orders
			from
				l_tools.start
			until
				l_tools.after
			loop
				Result.put ([l_tools.item_for_iteration, l_sorting.item (l_tools.key_for_iteration)], l_tools.key_for_iteration)
				l_tools.forth
			end
		ensure
			result_attached: Result /= Void
		end

	last_selected_descriptor: EB_CUSTOMIZED_FORMATTER_DESP
			-- Last selected descriptor

	set_last_selected_descriptor (a_descriptor: like last_selected_descriptor) is
			-- Set `last_selected_descriptor' with `a_descriptor'.
		do
			last_selected_descriptor := a_descriptor
		ensure
			last_selected_descriptor_set: last_selected_descriptor = a_descriptor
		end

	formatter_grid_wrapper: EVS_GRID_WRAPPER [EB_CUSTOMIZED_FORMATTER_DESP]
			-- Wrapper for `formatter_grid' to support sorting

	descriptor_row_table: HASH_TABLE [EV_GRID_ROW, EB_CUSTOMIZED_FORMATTER_DESP]
			-- Table of grid rows for descriptors
			-- [Grid row, Formatter descriptor displayed in that row]

	formatter_name_property: STRING_PROPERTY [STRING_32]
			-- Property for formatter name

	header_property: STRING_PROPERTY [STRING_32]
			-- Property for formatter header

	temp_header_property: STRING_PROPERTY [STRING_32]
			-- Property for formatter temporary header

	displayed_in_tools_property: DIALOG_PROPERTY [HASH_TABLE [TUPLE [view_name: STRING; sorting: STRING], STRING]]
			-- Property for formatter displayed-in

	displayer_dialog: EB_DISPLAYER_DIALOG
			-- Displayer dialog

feature{NONE} -- Sorting

	formatter_name_tester (a_formatter, b_formatter: EB_CUSTOMIZED_FORMATTER_DESP; a_order: INTEGER): BOOLEAN is
			-- Tester to decide order between `a_formatter' and `b_formatter' according sorting order specified by `a_order'
		do
			if a_order = ascending_order then
				Result := a_formatter.name <= b_formatter.name
			elseif a_order = descending_order then

				Result := a_formatter.name > b_formatter.name
			end
		end

	sort_agent (a_column_list: LIST [INTEGER]; a_comparator: AGENT_LIST_COMPARATOR [EB_CUSTOMIZED_FORMATTER_DESP]) is
			-- Action to be performed when sort `a_column_list' using `a_comparator'.
		require
			a_column_list_attached: a_column_list /= Void
			not_a_column_list_is_empty:
		local
			l_sorter: DS_QUICK_SORTER [EB_CUSTOMIZED_FORMATTER_DESP]
		do
			create l_sorter.make (a_comparator)
			l_sorter.sort (descriptors)
			bind_formatter_grid
			try_resume_last_selection
		end

feature {NONE} -- Implementation

	refresh is
			-- Refresh Current dialog to display `formatter_descriptors'.
		do
			load_formatter_descriptors
			set_is_loaded (True)
			set_last_selected_descriptor (Void)
			formatter_grid_wrapper.disable_auto_sort_order_change
			formatter_grid_wrapper.sort (0, 0, 1, 0, 0, 0, 0, 0, 1)
			formatter_grid_wrapper.enable_auto_sort_order_change
		end

	bind_formatter_grid is
			-- Bind formatters in `descriptors' in `formatter_grid'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [EB_CUSTOMIZED_FORMATTER_DESP]
			l_formatter_grid: like formatter_grid
			l_row_table: like descriptor_row_table
			l_grid_row: EV_GRID_ROW
		do
			l_row_table := descriptor_row_table
			l_row_table.wipe_out
			l_formatter_grid := formatter_grid
			if l_formatter_grid.row_count > 0 then
				l_formatter_grid.remove_rows (1, l_formatter_grid.row_count)
			end
			l_cursor := descriptors.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_formatter_grid.insert_new_row (l_formatter_grid.row_count + 1)
				l_grid_row := l_formatter_grid.row (l_formatter_grid.row_count)
				l_row_table.put (l_grid_row, l_cursor.item)
				bind_formatter (l_cursor.item, l_grid_row)
				l_cursor.forth
			end

			resize_formatter_grid
		end

	bind_property_grid (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP) is
			-- Load information of `a_descriptor' in `property_grid'.
		require
			a_descriptor_attached: a_descriptor /= Void
		local
			l_grid: like property_grid
			l_name: STRING_PROPERTY [STRING_32]
			l_tooltip: STRING_PROPERTY [STRING_GENERAL]
			l_header: STRING_PROPERTY [STRING_32]
			l_temp_header: STRING_PROPERTY [STRING_32]
			l_pixmap: FILE_PROPERTY
			l_metric: MENU_PROPERTY [STRING_GENERAL]
			l_metric_filter: BOOLEAN_PROPERTY
			l_scope: STRING_CHOICE_PROPERTY [STRING_GENERAL]

			l_tools: like displayed_in_tools_property
			l_dialog: like displayer_dialog
			l_displayer_value: like display_value
		do
			l_grid := property_grid
			l_grid.clear_description
			l_grid.reset
				-- Build "General" section.
			l_grid.add_section (interface_names.l_general)

			create l_name.make (interface_names.l_name)
			l_name.set_value (string_32_from_string_8 (a_descriptor.name))
			l_name.change_value_actions.extend (agent on_data_change (?, agent a_descriptor.set_name, agent refresh_grid_for_descriptor (a_descriptor)))
			formatter_name_property := l_name
			l_grid.add_property (l_name)

			create l_tooltip.make (interface_names.l_tooltip_lbl)
			l_tooltip.set_value (string_32_from_string_8 (a_descriptor.tooltip))
			l_tooltip.change_value_actions.extend (agent on_data_change (?, agent a_descriptor.set_tooltip, Void))
			l_grid.add_property (l_tooltip)

			create l_header.make (interface_names.l_header)
			l_header.set_value (string_32_from_string_8 (a_descriptor.header))
			l_header.change_value_actions.extend (agent on_data_change (?, agent a_descriptor.set_header, Void))
			l_header.set_description (metric_names.concatenated_string ((<<interface_names.l_formatter_header_help, interface_names.l_formatter_placeholder>>).linear_representation, " "))
			header_property := l_header
			l_grid.add_property (l_header)

			create l_temp_header.make (interface_names.l_temp_header)
			l_temp_header.set_value (string_32_from_string_8 (a_descriptor.temp_header))
			l_temp_header.change_value_actions.extend (agent on_data_change (?, agent a_descriptor.set_temp_header, Void))
			l_temp_header.set_description (metric_names.concatenated_string ((<<interface_names.l_formatter_temp_header_help, interface_names.l_formatter_placeholder>>).linear_representation, " "))
			temp_header_property := l_temp_header
			l_grid.add_property (l_temp_header)

			create l_pixmap.make (interface_names.l_pixmap_file)
			l_pixmap.set_value (string_32_from_string_8 (a_descriptor.pixmap_location))
			l_pixmap.change_value_actions.extend (agent on_data_change (?, agent a_descriptor.set_pixmap_location, Void))
			l_grid.add_property (l_pixmap)

			l_grid.current_section.expand

				-- Build "Metric" section.
			l_grid.add_section (interface_names.l_tab_metrics)

			create l_metric.make_with_menu (interface_names.l_tab_metrics, metric_menu)
			l_metric.set_value (string_32_from_string_8 (a_descriptor.metric_name))
			l_metric.change_value_actions.extend (agent on_metric_change (a_descriptor, ?))
			l_metric.set_value_retriever (agent (a_menu_item: EV_MENU_ITEM): STRING_GENERAL do Result := a_menu_item.text end)
			l_metric.set_value_converter (agent (a_text: STRING_32): STRING_GENERAL do Result := a_text end)
			l_metric.set_description (interface_names.l_formatter_metric_help)
			l_metric.enable_auto_set_data
			l_metric.enable_text_editing
			l_grid.add_property (l_metric)

			create l_metric_filter.make_with_value (interface_names.l_metric_filter, a_descriptor.is_filter_enabled)
			l_metric_filter.change_value_actions.extend (agent on_filter_change (a_descriptor, ?))
			l_metric_filter.set_description (interface_names.l_formatter_filter_help)
			l_grid.add_property (l_metric_filter)

			l_grid.current_section.expand

				-- Build "Layout" section.
			l_grid.add_section (interface_names.l_layout)

			create l_scope.make_with_choices (interface_names.l_scope, <<interface_names.l_eiffelstudio, interface_names.l_target>>)
			if a_descriptor.is_global_scope then
				l_scope.set_value (interface_names.l_eiffelstudio)
			else
				l_scope.set_value (interface_names.l_target)
			end
			l_scope.set_description (interface_names.l_formatter_scope_help)
			l_scope.change_value_actions.extend (agent on_scope_change (a_descriptor, ?))
			l_grid.add_property (l_scope)

			create l_dialog.make (string_32_from_string_8 (a_descriptor.name), tool_table)
			create l_tools.make_with_dialog (interface_names.l_displayed_in, l_dialog)
			l_tools.set_display_agent (agent tools_display_function)
			l_tools.set_description (interface_names.l_formatter_displayed_in_help)
			l_displayer_value := display_value (a_descriptor)
			l_dialog.set_value (l_displayer_value)
			l_tools.set_value (l_displayer_value)
			l_dialog.data_change_actions.extend (agent l_tools.set_value)
			displayer_dialog := l_dialog
			l_tools.change_value_actions.extend (agent on_displayer_change (a_descriptor, ?))
			displayed_in_tools_property := l_tools
			l_grid.add_property (l_tools)
			l_grid.current_section.expand

			l_metric.enable_select
		end

	refresh_grid_for_descriptor (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP) is
			-- Refresh grid item for `a_descriptor'.
		local
			l_grid_row: EV_GRID_ROW
			l_selected: BOOLEAN
		do
			formatter_grid.row_select_actions.block
			formatter_grid.row_deselect_actions.block
			l_grid_row := descriptor_row_table.item (a_descriptor)
			check l_grid_row /= Void end
			l_selected := l_grid_row.is_selected
			bind_formatter (a_descriptor, l_grid_row)
			if l_selected then
				l_grid_row.enable_select
			end
			formatter_grid.row_select_actions.resume
			formatter_grid.row_deselect_actions.resume
			if displayer_dialog /= Void then
				displayer_dialog.set_formatter_name (a_descriptor.name)
			end
		end

	tools_display_function (a_tool_value: like display_value): STRING_32 is
			-- String representation of `a_tool_value' for grid display
		require
			a_tool_value_attached: a_tool_value /= Void
		local
			l_tool_table: like tool_table
			i: INTEGER
			l_cnt: INTEGER
		do
			create Result.make (64)
			l_tool_table := tool_table
			from
				i := 1
				l_cnt := a_tool_value.count
				a_tool_value.start
			until
				a_tool_value.after
			loop
				Result.append (l_tool_table.item (a_tool_value.key_for_iteration).display_name)
				if i < l_cnt then
					Result.append (", ")
				end
				i := i + 1
				a_tool_value.forth
			end
		ensure
			result_attached: Result /= Void
		end

	resize_formatter_grid is
			-- Resize `formatter_grid'.
		local
			l_size_table: HASH_TABLE [TUPLE [INTEGER, INTEGER], INTEGER]
		do
			create l_size_table.make (1)
			l_size_table.put ([100, 200], 1)
			formatter_grid_wrapper.auto_resize_columns (formatter_grid, l_size_table)
		end

	bind_formatter (a_descriptor: EB_CUSTOMIZED_FORMATTER_DESP; a_grid_row: EV_GRID_ROW) is
			-- Bind `a_descriptor' in `a_grid_row'.
		local
			l_formatter_item: EV_GRID_LABEL_ITEM
			l_tools_item: ES_GRID_LIST_ITEM
			l_tool_table: like tool_table
			l_tools: HASH_TABLE [STRING, STRING]
			l_pixmap_component: ES_GRID_PIXMAP_COMPONENT
			l_tool_info: TUPLE [displayed_name: STRING_GENERAL; pixmap: EV_PIXMAP]
		do
				-- Build formatter name grid item.
			create l_formatter_item.make_with_text (string_32_from_string_8 (a_descriptor.name))
			l_formatter_item.set_pixmap (pixmap_from_file (a_descriptor.pixmap_location))
			a_grid_row.set_item (1, l_formatter_item)

				-- Build formatter displayed tools grid item.
			create l_tools_item
			l_tools_item.set_component_padding (4)
			l_tools_item.enable_component_pebble
			l_tool_table := tool_table
			l_tools := a_descriptor.tools
			from
				l_tools.start
			until
				l_tools.after
			loop
				l_tool_info := l_tool_table.item (l_tools.key_for_iteration)
				if l_tool_info /= Void then
					create l_pixmap_component.make (l_tool_info.pixmap)
					l_tools_item.insert_component (l_pixmap_component, l_tools_item.component_count + 1)
					l_pixmap_component.set_general_tooltip (displayed_in_tooltip (l_tool_info.displayed_name, l_pixmap_component, l_tools_item))
				end
				l_tools.forth
			end
			a_grid_row.set_item (2, l_tools_item)
			a_grid_row.set_data (a_descriptor)
		end

	displayed_in_tooltip (a_tool_name: STRING_GENERAL; a_component: ES_GRID_ITEM_COMPONENT; a_item: ES_GRID_LISTABLE_ITEM): EVS_GENERAL_TOOLTIP is
			-- Tooltip for `a_tool_name'.
		require
			a_tool_name_attached: a_tool_name /= Void
		local
			l_toolname: STRING_GENERAL
			l_tooltip: EVS_WIDGET_TOOLTIP
		do
			l_toolname := a_tool_name.twin
			l_toolname.append (" ")
			l_toolname.append (interface_names.string_general_as_lower (interface_names.t_tool_name))
			create l_tooltip.make (a_component.pointer_enter_actions, a_component.pointer_leave_actions, agent (a_item.grid_item).is_destroyed, create {EV_LABEL}.make_with_text (l_toolname))
			l_tooltip.unify_background_color
			l_tooltip.enable_repeat_tooltip_display
			l_tooltip.set_tooltip_window_related_window_agent (agent (window_manager.last_focused_development_window).window)
			Result := l_tooltip
		ensure
			result_attached: Result /= Void
		end

	setup_formatter_grid is
			-- Setup `formatter_grid'.
		local
			l_grid: like formatter_grid
			l_sorting_status: ARRAYED_LIST [TUPLE [INTEGER, INTEGER]]
		do
			l_grid := formatter_grid
			l_grid.set_column_count_to (2)
			l_grid.set_minimum_width (150)
			l_grid.column (1).set_title (interface_names.l_formatter)
			l_grid.column (2).set_title (interface_names.l_displayed_in)
			l_grid.enable_single_row_selection
			l_grid.row_select_actions.extend (agent on_formatter_selected)
			l_grid.row_deselect_actions.extend (agent on_formatter_deselected)

				-- Setup sorting information.			
			formatter_grid_wrapper.set_sort_info (1, create {EVS_GRID_TWO_WAY_SORTING_INFO [EB_CUSTOMIZED_FORMATTER_DESP]}.make (agent formatter_name_tester, ascending_order))
			create l_sorting_status.make (1)
			l_sorting_status.extend ([1, ascending_order])
			formatter_grid_wrapper.set_sorting_status (l_sorting_status)
			formatter_grid_wrapper.enable_auto_sort_order_change
			formatter_grid_wrapper.set_sort_action (agent sort_agent)

			l_grid.key_press_actions.extend (agent on_key_pressed_in_formatter_grid)
		end

	setup_property_grid is
			-- Setup `property_grid'.
		do
			property_grid.add_section (interface_names.l_general)
			property_grid.add_section (interface_names.l_Tab_metrics)
			property_grid.add_section (interface_names.l_layout)
			property_grid.set_minimum_width (350)
			property_grid.hide
		end

	try_resume_last_selection is
			-- Try to select last selected row.
		local
			l_formatter_grid: like formatter_grid
		do
			if last_selected_descriptor /= Void and then descriptor_row_table.has (last_selected_descriptor) then
				descriptor_row_table.item (last_selected_descriptor).enable_select
			else
				l_formatter_grid := formatter_grid
				if l_formatter_grid.selected_rows.is_empty and then l_formatter_grid.row_count > 0 then
					l_formatter_grid.row (1).enable_select
					l_formatter_grid.set_focus
				end
			end
		end

	is_default_formatter_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a default formatter name?
			-- A default formatter name is like "New formatter #xxx" where "xxx" is an index integer.
		require
			a_name_attached: a_name /= Void
		local
			l_count: INTEGER
			l_index: STRING
		do
			l_count := new_formatter_name.count
			if a_name.count > l_count then
				Result := a_name.substring (1, l_count).is_equal (new_formatter_name)
				if Result then
					l_index := a_name.substring (l_count + 1, a_name.count)
					l_index.left_adjust
					l_index.right_adjust
					Result := l_index.is_integer
				end
			end
		end

invariant
	formatter_grid_attached: formatter_grid /= Void
	property_grid_attached: property_grid /= Void
	helper_label_attached: helper_label /= Void
	formatter_getter_attached: formatter_getter /= Void
	ok_actions_attached: ok_actions /= Void
	cancel_actions_attached: cancel_actions /= Void
	formatter_grid_wrapper_attached: formatter_grid_wrapper /= Void
	descriptor_row_table_attached: descriptor_row_table /= Void
end
