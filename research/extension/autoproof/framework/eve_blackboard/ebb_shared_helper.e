﻿note
	description: "Helper features used by different classes."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_SHARED_HELPER

feature {NONE} -- Helper functions

	features_written_in_class (a_class: CLASS_C): LIST [FEATURE_I]
			-- List of features written in class `a_class'.
		local
			l_feature: FEATURE_I
		do
			create {LINKED_LIST [FEATURE_I]} Result.make
			if a_class.has_feature_table and then a_class.feature_table /= Void then
				from
					a_class.feature_table.start
				until
					a_class.feature_table.after
				loop
					l_feature := a_class.feature_table.item_for_iteration
					if l_feature.written_in = a_class.class_id then
						Result.extend (l_feature)
					end
					a_class.feature_table.forth
				end
			end
		end

	is_feature_verified (a_feature: FEATURE_I): BOOLEAN
			-- Is feature `a_feature' verified?
		do
			Result := not a_feature.is_attribute and not a_feature.is_deferred and not a_feature.is_external
		end

	is_feature_data_verified (a_feature_data: EBB_FEATURE_DATA): BOOLEAN
			-- Is feature `a_feature_data' verified?
		do
			Result := is_feature_verified (a_feature_data.associated_feature)
		end

	feature_indexing_value (a_indexes: INDEXING_CLAUSE_AS; a_tag: STRING): ATOMIC_AS
		local
			l_index: INDEX_AS
		do
			if a_indexes /= Void then
				from
					a_indexes.start
				until
					a_indexes.after or Result /= Void
				loop
					l_index := a_indexes.item_for_iteration
					if l_index.tag /= Void and then l_index.tag.name_8.is_equal (a_tag) then
						if l_index.index_list /= Void and then not l_index.index_list.is_empty then
							Result := l_index.index_list.first
						end
					end
					a_indexes.forth
				end
			end
		end

	importance_weight (a_indexes: INDEXING_CLAUSE_AS): REAL
		do
			Result := 1.0
			if a_indexes /= Void then
				if attached {ID_AS} feature_indexing_value (a_indexes, "importance") as l_importance then
					if l_importance.name_8.same_string ("high") then
						Result := 2.0
					elseif l_importance.name_8.same_string ("low") then
						Result := 0.5
					end
				end
			end
		end

	correctness_override (a_indexes: INDEXING_CLAUSE_AS): TUPLE [value: REAL; is_set: BOOLEAN]
		local
			l_atomic: ATOMIC_AS
			l_value: REAL
			l_is_set: BOOLEAN
		do
			l_value := {REAL}.nan
			if attached a_indexes then
				l_atomic := feature_indexing_value (a_indexes, "correctness")
				if attached {INTEGER_AS} l_atomic as l_integer then
					l_value := (l_integer.integer_32_value / 100).truncated_to_real
					l_is_set := True
				elseif attached {REAL_AS} l_atomic as l_real then
					l_value := l_real.value.to_real
					l_is_set := True
				elseif attached {ID_AS} l_atomic as l_text then
					if l_text.name_8.same_string ("assumed") or l_text.name_8.same_string ("proven") then
						l_value := 1.0
						l_is_set := True
					elseif l_text.name_8.same_string ("tested") then
						l_value := 0.9
						l_is_set := True
					elseif l_text.name_8.same_string ("ignore") or l_text.name_8.same_string ("skip") then
						l_value := {REAL}.nan
						l_is_set := True
					elseif l_text.name_8.same_string ("failed") or l_text.name_8.same_string ("fault") then
						l_value := -1.0
						l_is_set := True
					end
				end
				if l_value > 1.0 then
					l_value := 1.0
				elseif l_value < -1.0 then
					l_value := -1.0
				end
			end
			Result := [l_value, l_is_set]
		end

	weight_override (a_indexes: INDEXING_CLAUSE_AS): REAL
		local
			l_atomic: ATOMIC_AS
		do
			Result := {REAL}.nan
			if a_indexes /= Void then
				l_atomic := feature_indexing_value (a_indexes, "weight")
				if attached {INTEGER_AS} l_atomic as l_integer then
					Result := l_integer.integer_32_value
				elseif attached {REAL_AS} l_atomic as l_real then
					Result := l_real.value.to_real
				end
				if Result < 0.0 then
					Result := 0.0
				end
			end
		end

	verification_list (a_indexes: INDEXING_CLAUSE_AS): ARRAYED_LIST [STRING]
		local
			l_index: INDEX_AS
		do
			create Result.make (1)
			if a_indexes /= Void then
				from
					a_indexes.start
				until
					a_indexes.after or not Result.is_empty
				loop
					l_index := a_indexes.item_for_iteration
					if l_index.tag /= Void and then l_index.tag.name_8.same_string ("verification") then
						if l_index.index_list /= Void then
							from
								l_index.index_list.start
							until
								l_index.index_list.after
							loop
								if attached {ID_AS} l_index.index_list.item as l_string then
									Result.extend (l_string.name_8)
								end
								l_index.index_list.forth
							end
						end
					end
					a_indexes.forth
				end
			end
			if Result.is_empty then
				Result.extend ("all")
			end
		end

end
