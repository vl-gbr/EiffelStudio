note
	description: "Decoding of arbitrary objects graphs between sessions of programs %
		%containing the same types. It basically takes care of potential reordering %
		%of attributes from one system to the other."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SED_INDEPENDENT_DESERIALIZER

inherit
	SED_BASIC_DESERIALIZER
		redefine
			read_header,
			new_attribute_offset,
			read_persistent_field_count,
			clear_internal_data,
			is_transient_retrieval_required,
			has_version
		end

create
	make

feature {NONE} -- Implementation: access

	attributes_mapping: detachable SPECIAL [detachable SPECIAL [INTEGER]]
			-- Mapping for each dynamic type id between old attribute location
			-- and new attribute location.

	new_attribute_offset (a_new_type_id, a_old_offset: INTEGER): INTEGER
			-- Given attribute offset `a_old_offset' in the stored object whose dynamic type id
			-- is now `a_new_type_id', retrieve new offset in `a_new_type_id'.
		do
			if
				attached attributes_mapping as l_map and then l_map.valid_index (a_new_type_id) and then
				attached l_map.item (a_new_type_id) as l_entry and then l_entry.valid_index (a_old_offset)
			then
				Result := l_entry.item (a_old_offset)
			end
		end

feature {NONE} -- Status report

	is_transient_retrieval_required: BOOLEAN
			-- <Precursor>
		do
				-- We do not need transient attribute to be retrieved, only persistent one.			
			Result := False
		end

	has_version: BOOLEAN
			-- Does format support reading of a version number?
		do
				-- Because versioning was added after the initial release of SED, in order
				-- to not break existing storables, SED_INDEPENDENT_DESERIALIZER does not support
				-- the reading of a version.
		end

feature {NONE} -- Implementation

	read_header (a_count: NATURAL_32)
			-- Read header which contains mapping between dynamic type and their
			-- string representation.
		local
			i, nb: INTEGER
			l_deser: like deserializer
			l_int: like internal
			l_table: like dynamic_type_table
			l_old_dtype, l_new_dtype: INTEGER
			l_type_str: STRING
			l_old_version: detachable STRING
		do
			l_int := internal
			l_deser := deserializer

			if has_version then
				version := l_deser.read_compressed_natural_32
				inspect version
				when {SED_VERSIONS}.recoverable_version_6_6 then

				else
						-- Unknown version read or not a independent/recoverable format.
					set_error (error_factory.new_format_mismatch (version, {SED_VERSIONS}.session_version))
				end
			else
				version := 0
			end

			if not has_error then
					-- Number of dynamic types in storable
				nb := l_deser.read_compressed_natural_32.to_integer_32
				create l_table.make_filled (0, nb)
				create attributes_mapping.make_filled (Void, nb)

					-- Read table which will give us mapping between the old dynamic types
					-- and the new ones.
				from
					i := 0
				until
					i = nb
				loop
						-- Read old dynamic type
					l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

						-- Read type string associated to `l_old_dtype' and find dynamic type
						-- in current system.
					l_type_str := l_deser.read_string_8
					l_new_dtype := l_int.dynamic_type_from_string (l_type_str)
					if l_new_dtype = -1 then
						set_error (error_factory.new_missing_type_error (l_type_str))
						i := nb - 1 -- Jump out of loop
					else
						if not l_table.valid_index (l_old_dtype) then
							l_table := l_table.aliased_resized_area_with_default (0, (l_old_dtype + 1).max (l_table.count * 2))
						end
						l_table.put (l_new_dtype, l_old_dtype)

							-- Read the type storable version if format supports it.
						if version >= {SED_VERSIONS}.recoverable_version_6_6 then
								-- Do we have a version to read?
							if l_deser.read_boolean then
								l_old_version := l_deser.read_string_8
							else
								l_old_version := Void
							end
							if l_old_version /~ l_int.storable_version_of_type (l_new_dtype) then
								set_error (error_factory.new_storable_version_mismatch_error (l_new_dtype, l_old_version))
							end
						end
					end

					i := i + 1
				end

				if not has_error then
						-- Read table which will give us mapping between the old dynamic types
						-- and the new ones.
					from
						i := 0
						nb := l_deser.read_compressed_natural_32.to_integer_32
					until
						i = nb
					loop
							-- Read old dynamic type
						l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

							-- Read type string associated to `l_old_dtype' and find dynamic type
							-- in current system.
						l_type_str := l_deser.read_string_8
						l_new_dtype := l_int.dynamic_type_from_string (l_type_str)
						if l_new_dtype = -1 then
							set_error (error_factory.new_missing_type_error (l_type_str))
							i := nb - 1 -- Jump out of loop
						else
							if not l_table.valid_index (l_old_dtype) then
								l_table := l_table.aliased_resized_area_with_default (0, (l_old_dtype + 1).max (l_table.count * 2))
							end
							l_table.put (l_new_dtype, l_old_dtype)
						end
						i := i + 1
					end

					if not has_error then
							-- Now set `dynamic_type_table' as all old dynamic type IDs have
							-- be read and resolved.
						dynamic_type_table := l_table

							-- Read attributes map for each dynamic type.
						from
							i := 0
							nb := l_deser.read_compressed_natural_32.to_integer_32
						until
							i = nb
						loop
								-- Read old dynamic type.
							l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

								-- Read attributes description
							read_attributes (l_table.item (l_old_dtype))
							if has_error then
									-- We had an error while retrieving stored attributes
									-- for `l_old_dtype'.
								i := nb - 1	-- Jump out of loop
							end
							i := i + 1
						end

						if not has_error then
								-- Read object_table if any.
							read_object_table (a_count)
						end
					end
				end
			end
		end

	read_persistent_field_count (a_dtype: INTEGER): INTEGER
			-- Number of fields we are going to read from the retrieved system.
		do
			if
				attached attributes_mapping as l_map and then l_map.valid_index (a_dtype) and then
				attached l_map.item (a_dtype) as l_entry
			then
				Result := l_entry.count - 1
			else
				set_error (error_factory.new_internal_error ("Cannot retrieve stored count"))
			end
		end

	read_attributes (a_dtype: INTEGER)
			-- Read attribute description for `a_dtype' where `a_dtype' is a dynamic type
			-- from the current system.
		require
			a_dtype_non_negative: a_dtype >= 0
			attributes_mapping_not_void: attributes_mapping /= Void
		local
			l_deser: like deserializer
			l_map: like attributes_map
			l_mapping: SPECIAL [INTEGER]
			l_name: STRING
			l_old_dtype, l_dtype: INTEGER
			i, nb: INTEGER
			a: like attributes_mapping
			l_item: detachable TUPLE [position, dtype: INTEGER]
			l_attribute_type: INTEGER
		do
			l_deser := deserializer

				-- Compare count of attributes
			nb := l_deser.read_compressed_natural_32.to_integer_32
			if nb /= internal.persistent_field_count_of_type (a_dtype) then
					-- Stored type has a different number of attributes than the type
					-- from the retrieving system.
				set_error (error_factory.new_attribute_count_mismatch (a_dtype, nb))
			else
				from
					i := 1
					l_map := attributes_map (a_dtype)
					nb := nb + 1
					create l_mapping.make_empty (nb)
					l_mapping.extend (0)
				until
					i = nb
				loop
						-- Read attribute static type
					l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32
					l_dtype := new_dynamic_type_id (l_old_dtype)
						-- Read attribute name
					l_name := l_deser.read_string_8

					l_map.search (l_name)
					if l_map.found then
						l_item := l_map.found_item
						if l_item /= Void then
							l_attribute_type := l_item.dtype
							if l_attribute_type /= l_dtype then
								set_error (error_factory.new_attribute_mismatch (a_dtype, l_name, l_attribute_type, l_dtype))
								i := nb - 1 -- Jump out of loop
							else
								l_mapping.extend (l_item.position)
							end
						end
					else
						set_error (error_factory.new_missing_attribute_error (a_dtype, l_name))
						i := nb	- 1 -- Jump out of loop
					end
					i := i + 1
				end
				if not has_error then
					a := attributes_mapping
					if a /= Void then
						if not a.valid_index (a_dtype) then
							a := a.aliased_resized_area_with_default (Void, (a_dtype + 1).max (a.count * 2))
							attributes_mapping := a
						end
						a.put (l_mapping, a_dtype)
					end
				end
			end
		end

	attributes_map (a_dtype: INTEGER): HASH_TABLE [TUPLE [position, dtype: INTEGER], STRING]
			-- Attribute map for dynamic type `a_dtype' which records
			-- position and dynamic type for a given attribute name.
		require
			a_dtype_non_negative: a_dtype >= 0
		local
			l_int: like internal
			i, nb: INTEGER
		do
			l_int := internal

			from
				i := 1
				nb := l_int.field_count_of_type (a_dtype)
				create Result.make (nb)
				nb := nb + 1
			until
				i = nb
			loop
				Result.put (
					[i, l_int.field_static_type_of_type (i, a_dtype)],
					l_int.field_name_of_type (i, a_dtype))
				i := i + 1
			end
		ensure
			attributes_map_not_void: Result /= Void
		end

feature {NONE} -- Cleaning

	clear_internal_data
			-- Clear all allocated data
		do
			Precursor {SED_BASIC_DESERIALIZER}
			attributes_mapping := Void
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
