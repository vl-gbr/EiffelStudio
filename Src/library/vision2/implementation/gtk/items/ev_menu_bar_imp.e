indexing
	description: "Eiffel Vision menu bar. GTK+ implementation."
	status: "See notice at end of class"
	date: "$Date$"
	revision: "$Revision$"
	
class
	EV_MENU_BAR_IMP
	
inherit
	EV_MENU_BAR_I
		redefine
			interface
		end

	EV_MENU_ITEM_LIST_IMP
		redefine
			interface,
			insert_menu_item
		end
	
create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is False

	make (an_interface: like interface) is
		do
			base_make (an_interface)
			set_c_object (feature {EV_GTK_EXTERNALS}.gtk_menu_bar_new)
			feature {EV_GTK_EXTERNALS}.gtk_menu_bar_set_shadow_type (c_object, feature {EV_GTK_EXTERNALS}.gTK_SHADOW_NONE_ENUM)
			feature {EV_GTK_EXTERNALS}.gtk_widget_show (c_object)
		end
		
feature {EV_WINDOW_IMP} -- Implementation

	set_parent_window_imp (a_wind: EV_WINDOW_IMP) is
			-- Set `parent_window' to `a_wind'.
		require
			a_wind_not_void: a_wind /= Void
		do
			parent_imp := a_wind
		end
		
	parent: EV_WINDOW is
			-- Parent window of Current.
		do
			if parent_imp /= Void then
				Result := parent_imp.interface
			end
		end
	
	remove_parent_window is
			-- Set `parent_window' to Void.
		do
			parent_imp := Void
		end
		
	parent_imp: EV_WINDOW_IMP

feature {NONE} -- Implementation

	insert_menu_item (an_item_imp: EV_MENU_ITEM_IMP; pos: INTEGER) is
			-- Generic menu item insertion.
		local
			menu_imp: EV_MENU_IMP
			a_cs: EV_GTK_C_STRING
		do
			create a_cs.make ("activate_item")
			if parent_imp /= Void then
				menu_imp ?= an_item_imp
				if menu_imp /= Void and then menu_imp.key /= 0 then
					feature {EV_GTK_EXTERNALS}.gtk_widget_add_accelerator (menu_imp.c_object,
						a_cs.item,
						parent_imp.accel_group,
						menu_imp.key,
						feature {EV_GTK_EXTERNALS}.gdk_mod1_mask_enum,
						0)
				end			
			end

			an_item_imp.set_item_parent_imp (Current)
			feature {EV_GTK_EXTERNALS}.gtk_menu_shell_insert (list_widget, an_item_imp.c_object, pos - 1)
			child_array.go_i_th (pos)
			child_array.put_left (an_item_imp.interface)
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_MENU_BAR

end -- class EV_MENU_BAR_IMP

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

