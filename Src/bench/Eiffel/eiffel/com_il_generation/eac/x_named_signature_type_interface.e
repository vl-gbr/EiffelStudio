indexing
	description: " Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	X_NAMED_SIGNATURE_TYPE_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	to_string_user_precondition: BOOLEAN is
			-- User-defined preconditions for `to_string'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	equals_user_precondition (obj: POINTER_REF): BOOLEAN is
			-- User-defined preconditions for `equals'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	get_hash_code_user_precondition: BOOLEAN is
			-- User-defined preconditions for `get_hash_code'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	get_type_user_precondition: BOOLEAN is
			-- User-defined preconditions for `get_type'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	internal_external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `internal_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	internal_type_full_external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `internal_type_full_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	internal_type_eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `internal_type_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	internal_eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `internal_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	make1_user_precondition: BOOLEAN is
			-- User-defined preconditions for `make1'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_eiffel_name_user_precondition (a_name: STRING): BOOLEAN is
			-- User-defined preconditions for `set_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_external_name_user_precondition (a_name: STRING): BOOLEAN is
			-- User-defined preconditions for `set_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	type_eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `type_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_type_full_external_name_user_precondition (a_name: STRING): BOOLEAN is
			-- User-defined preconditions for `set_type_full_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_type_eiffel_name_user_precondition (a_name: STRING): BOOLEAN is
			-- User-defined preconditions for `set_type_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	type_full_external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `type_full_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	x_internal_internal_external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `x_internal_internal_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set__internal_internal_external_name_user_precondition (p_ret_val: STRING): BOOLEAN is
			-- User-defined preconditions for `set__internal_internal_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	x_internal_internal_type_full_external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `x_internal_internal_type_full_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set__internal_internal_type_full_external_name_user_precondition (p_ret_val: STRING): BOOLEAN is
			-- User-defined preconditions for `set__internal_internal_type_full_external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	x_internal_internal_type_eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `x_internal_internal_type_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set__internal_internal_type_eiffel_name_user_precondition (p_ret_val: STRING): BOOLEAN is
			-- User-defined preconditions for `set__internal_internal_type_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	x_internal_internal_eiffel_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `x_internal_internal_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set__internal_internal_eiffel_name_user_precondition (p_ret_val: STRING): BOOLEAN is
			-- User-defined preconditions for `set__internal_internal_eiffel_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	to_string: STRING is
			-- No description available.
		require
			to_string_user_precondition: to_string_user_precondition
		deferred

		end

	equals (obj: POINTER_REF): BOOLEAN is
			-- No description available.
			-- `obj' [in].  
		require
			non_void_obj: obj /= Void
			valid_obj: obj.item /= default_pointer
			equals_user_precondition: equals_user_precondition (obj)
		deferred

		end

	get_hash_code: INTEGER is
			-- No description available.
		require
			get_hash_code_user_precondition: get_hash_code_user_precondition
		deferred

		end

	get_type: INTEGER is
			-- No description available.
		require
			get_type_user_precondition: get_type_user_precondition
		deferred

		end

	internal_external_name: STRING is
			-- No description available.
		require
			internal_external_name_user_precondition: internal_external_name_user_precondition
		deferred

		end

	internal_type_full_external_name: STRING is
			-- No description available.
		require
			internal_type_full_external_name_user_precondition: internal_type_full_external_name_user_precondition
		deferred

		end

	internal_type_eiffel_name: STRING is
			-- No description available.
		require
			internal_type_eiffel_name_user_precondition: internal_type_eiffel_name_user_precondition
		deferred

		end

	internal_eiffel_name: STRING is
			-- No description available.
		require
			internal_eiffel_name_user_precondition: internal_eiffel_name_user_precondition
		deferred

		end

	make1 is
			-- No description available.
		require
			make1_user_precondition: make1_user_precondition
		deferred

		end

	set_eiffel_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		require
			set_eiffel_name_user_precondition: set_eiffel_name_user_precondition (a_name)
		deferred

		end

	external_name: STRING is
			-- No description available.
		require
			external_name_user_precondition: external_name_user_precondition
		deferred

		end

	eiffel_name: STRING is
			-- No description available.
		require
			eiffel_name_user_precondition: eiffel_name_user_precondition
		deferred

		end

	set_external_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		require
			set_external_name_user_precondition: set_external_name_user_precondition (a_name)
		deferred

		end

	type_eiffel_name: STRING is
			-- No description available.
		require
			type_eiffel_name_user_precondition: type_eiffel_name_user_precondition
		deferred

		end

	set_type_full_external_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		require
			set_type_full_external_name_user_precondition: set_type_full_external_name_user_precondition (a_name)
		deferred

		end

	set_type_eiffel_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		require
			set_type_eiffel_name_user_precondition: set_type_eiffel_name_user_precondition (a_name)
		deferred

		end

	type_full_external_name: STRING is
			-- No description available.
		require
			type_full_external_name_user_precondition: type_full_external_name_user_precondition
		deferred

		end

	x_internal_internal_external_name: STRING is
			-- No description available.
		require
			x_internal_internal_external_name_user_precondition: x_internal_internal_external_name_user_precondition
		deferred

		end

	set__internal_internal_external_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		require
			set__internal_internal_external_name_user_precondition: set__internal_internal_external_name_user_precondition (p_ret_val)
		deferred

		end

	x_internal_internal_type_full_external_name: STRING is
			-- No description available.
		require
			x_internal_internal_type_full_external_name_user_precondition: x_internal_internal_type_full_external_name_user_precondition
		deferred

		end

	set__internal_internal_type_full_external_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		require
			set__internal_internal_type_full_external_name_user_precondition: set__internal_internal_type_full_external_name_user_precondition (p_ret_val)
		deferred

		end

	x_internal_internal_type_eiffel_name: STRING is
			-- No description available.
		require
			x_internal_internal_type_eiffel_name_user_precondition: x_internal_internal_type_eiffel_name_user_precondition
		deferred

		end

	set__internal_internal_type_eiffel_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		require
			set__internal_internal_type_eiffel_name_user_precondition: set__internal_internal_type_eiffel_name_user_precondition (p_ret_val)
		deferred

		end

	x_internal_internal_eiffel_name: STRING is
			-- No description available.
		require
			x_internal_internal_eiffel_name_user_precondition: x_internal_internal_eiffel_name_user_precondition
		deferred

		end

	set__internal_internal_eiffel_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		require
			set__internal_internal_eiffel_name_user_precondition: set__internal_internal_eiffel_name_user_precondition (p_ret_val)
		deferred

		end

end -- X_NAMED_SIGNATURE_TYPE_INTERFACE

