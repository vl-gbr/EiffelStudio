indexing
	description: "Style to generate editor tokens for a given string"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_TEXT_EDITOR_TOKEN_STYLE

inherit
	EB_EDITOR_TOKEN_STYLE

feature -- Status report

	is_text_ready: BOOLEAN
			-- Is `text' ready to be returned?
		do
			Result := source_text /= Void
		end

feature -- Text

	text: LIST [EDITOR_TOKEN] is
			-- Editor token text generated by `Current' style
		local
			l_writer: like token_writer
		do
			l_writer := token_writer
			l_writer.new_line
			l_writer.add (source_text)
			Result := l_writer.last_line.content
		end

feature -- Access

	source_text: STRING
			-- Source text from which editor token will be generated

feature -- Setting

	set_source_text (a_source_text: like source_text) is
			-- Set `source_text' with `a_source_text'.
		do
			create source_text.make_from_string (a_source_text)
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end
