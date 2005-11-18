-- Block of invariant assertions

class INVARIANT_B

inherit
	ASSERT_TYPE

	BYTE_NODE
		redefine
			generate_il
		end

	IDABLE
		rename
			id as class_id,
			set_id as set_class_id
		end

	SHARED_BODY_ID

feature -- Visitor

	process (v: BYTE_NODE_VISITOR) is
			-- Process current element.
		do
			v.process_invariant_b (Current)
		end

feature -- Access

	byte_list: BYTE_LIST [BYTE_NODE]
			-- Invariant byte code list

	once_manifest_string_count: INTEGER
			-- Number of once manifest strings in class invariant

feature -- Settings

	set_byte_list (b: like byte_list) is
			-- Assign `b' to `byte_list'.
		do
			byte_list := b
		ensure
			byte_list_set: byte_list = b
		end

	set_once_manifest_string_count (oms_count: like once_manifest_string_count) is
			-- Set `once_manifest_string_count' to `oms_count'.
		require
			valid_oms_count: oms_count >= 0
		do
			once_manifest_string_count := oms_count
		ensure
			once_manifest_string_count_set: once_manifest_string_count = oms_count
		end

feature

	associated_class: CLASS_C is
			-- Associated class
		do
			Result := System.class_of_id (class_id)
		end

	generate_invariant_routine is
			-- Generate invariant routine
		require
			has_invariant: byte_list /= Void
		local
			i: INTEGER;
			body_index: INTEGER;
			internal_name: STRING;
			buf: GENERATION_BUFFER
		do
			buf := buffer

				-- Set the control flag for enlarging the assertions
			context.set_assertion_type (In_invariant);

			byte_list.enlarge_tree;
			byte_list.analyze;
				-- For invariant, we always need the GC hook.
			context.force_gc_hooks

				--| Always mark current as used in all modes
			context.mark_current_used;

				-- Routine's name				
			if context.final_mode then
				body_index := Invariant_body_index;
			else
				body_index := associated_class.invariant_feature.body_index;
			end;
			context.set_original_body_index (body_index)

				-- Generate extern clauses for once manifest strings.
			context.generate_once_manifest_string_import (once_manifest_string_count)

			internal_name := Encoder.feature_name (
				System.class_type_of_id (context.current_type.type_id).static_type_id,
				body_index)

			buf.generate_function_signature ("void", internal_name,
					True, Context.header_buffer,
					<<"Current", "where">>, <<"EIF_REFERENCE", "int">>);

			buf.indent;

				-- Generation of temporary variables under the control
				-- of the GC
			context.generate_temporary_ref_variables;
				-- Dynamic type of Current
			if context.dftype_current > 1 then
				buf.put_string ("RTCFDT;");
				buf.put_new_line;
			end;
			if context.dt_current > 1 then
				buf.put_string ("RTCDT;");
				buf.put_new_line;
			end;

				-- Generation of the local variable array
			i := context.ref_var_used;
			if i > 0 then
				buf.put_string ("RTLD;");
				buf.put_new_line;
			end;

				-- Separate declarations and body with a blank line
			buf.put_new_line;

				-- Generate GC hooks
			context.generate_gc_hooks (True);

				-- Allocate memory for once manifest strings.
			context.generate_once_manifest_string_allocation (once_manifest_string_count)

			byte_list.generate;

				-- Remove gc hooks
			i := context.ref_var_used;
			if i > 0 then
				buf.put_string ("RTLE;%N");
			end;
				-- End of C routine
			buf.exdent;
			buf.put_string ("}%N%N");
		end;

feature -- IL code generation

	generate_il is
			-- Generate IL code for a class invariant clause.
		local
			end_of_invariant: IL_LABEL
			body_index: INTEGER
		do
			context.local_list.wipe_out
			context.set_assertion_type (In_invariant)

			body_index := associated_class.invariant_feature.body_index
			context.set_original_body_index (body_index)

				-- Allocate memory for once manifest strings if required
			if once_manifest_string_count > 0 then
				il_generator.generate_once_string_allocation (once_manifest_string_count)
			end

			end_of_invariant := il_label_factory.new_label

			il_generator.generate_invariant_checked_for (end_of_invariant)
			byte_list.generate_il
			il_generator.generate_inherited_invariants

			il_generator.mark_label (end_of_invariant)
			il_generator.generate_return (False)
		end

invariant
	valid_once_manifest_string_count: once_manifest_string_count >= 0

end
