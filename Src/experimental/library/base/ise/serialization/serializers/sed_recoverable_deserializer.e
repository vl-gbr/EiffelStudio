note
	description: "Decoding of arbitrary objects graphs between sessions of programs %
		%containing the same types. It basically takes care of potential reordering %
		%of attributes from one system to the other."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SED_RECOVERABLE_DESERIALIZER

inherit
	SED_INDEPENDENT_DESERIALIZER
		redefine
			has_version
		end

create
	make

feature {NONE} -- Status report

	has_version: BOOLEAN
			-- Recoverable format needs to read the version from the storable.
		do
			Result := True
		end

note
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2008, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
