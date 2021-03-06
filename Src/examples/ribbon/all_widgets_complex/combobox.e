note
	description: "[
					Generated by EiffelRibbon tool
																							]"
	date: "$Date$"
	revision: "$Revision$"

class
	COMBOBOX

inherit
	COMBOBOX_IMP
		redefine
			create_interface_objects
		end

create
	{EV_RIBBON_GROUP} make_with_command_list

feature -- Query

	text: STRING_32 = "Combo box 1"
			-- This is generated by EiffelRibbon tool

feature {NONE} -- Initialization

	create_interface_objects
			-- <Precursor>
		local
       		l_list: ARRAYED_LIST [EV_RIBBON_COMBO_BOX_ITEM]
       		l_item: EV_RIBBON_COMBO_BOX_ITEM
		do
			Precursor
	       create l_list.make (4)
	       create l_item
	       l_item.set_label ("First item")
	       l_item.select_actions.extend (agent do
	       										print ("%N First item selected")
	       									end)
	       l_list.extend (l_item)

	       create l_item
	       l_item.set_label ("Second item")
	       l_item.select_actions.extend (agent do
	       										print ("%N Second item selected")
	       									end)
	       l_list.extend (l_item)

	       create l_item
	       l_item.set_label ("Third item")
	       l_item.select_actions.extend (agent do
	       										print ("%N Third item selected")
	       									end)
	       l_list.extend (l_item)

	       create l_item
	       l_item.set_label ("Forth item")
	       l_item.select_actions.extend (agent do
	       											print ("%N Forth item selected")
	       										end)
	       l_list.extend (l_item)

			set_item_source (l_list)
		end

end

