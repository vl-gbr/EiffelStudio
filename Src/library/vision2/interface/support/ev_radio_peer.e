indexing	
	description:
		"Facilities for managing peer relations between radio buttons.%N%
		%Base class for EV_RADIO_BUTTON, EV_RADIO_MENU_ITEM and%
		%EV_TOOL_BAR_RADIO_BUTTON."
	status: "See notice at end of class"
	keywords: "radio, item, menu, check, select"
	date: "$Date$"
	revision: "$Revision$"

deferred class 
	EV_RADIO_PEER

inherit
	EV_ANY
		redefine
			implementation,
			is_in_default_state
		end
	
feature -- Status report

	is_selected: BOOLEAN is
			-- Is this radio item checked?
		require
			not_destroyed: not is_destroyed
		deferred
		end

	peers: LINKED_LIST [like Current] is
			-- All radio items in the group `Current' is in.
			-- Includes `Current'.
		require
			not_destroyed: not is_destroyed
		do
			Result := implementation.peers
		ensure
			not_void: Result /= Void
			bridge_ok: Result.count = implementation.peers.count
		end

	selected_peer: like Current is
			-- Item in `peers' that is currently selected.
		require
			not_destroyed: not is_destroyed
		do
			Result := implementation.selected_peer
		ensure
			not_void: Result /= Void
			bridge_ok: Result.is_equal (implementation.selected_peer)
		end

feature -- Status setting

	enable_select is
			-- Change selected peer to `Current'.
		require
			not_destroyed: not is_destroyed
		deferred
		ensure
			selected_peer_is_current: selected_peer = Current
		end

feature {NONE} -- Contract support

	selected_count: INTEGER is
			-- Number of selected radio items in `peers'.
		local
			l: like peers
		do
			l := peers
			from
				l.start
			until
				l.off
			loop
				if l.item.is_selected then
					Result := Result + 1
				end
				l.forth
			end
		end

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
			-- Radio buttons are selected by default.
		do
			Result := Precursor and then is_selected
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_RADIO_PEER_I
			-- Responsible for interaction with native graphics toolkit.

invariant
	peers_not_void: is_usable implies (peers /= Void)
	selected_peer_not_void: is_usable implies (selected_peer /= Void)
	peers_returns_new_copy_of_list: is_usable implies (peers /= peers)
	peers_has_current: is_usable implies (peers.has (Current))
	is_selected_equals_selected_peer_is_current:
		is_usable implies (is_selected = (selected_peer = Current))
	one_radio_item_selected: is_usable implies (selected_count = 1)

end -- class EV_RADIO_PEER

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

