indexing
	description: " Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	NAMED_SIGNATURE_TYPE_PROXY

inherit
	X_NAMED_SIGNATURE_TYPE_INTERFACE

	INAMED_SIGNATURE_TYPE_INTERFACE
		rename
			set_eiffel_name as inamed_signature_type_set_eiffel_name1,
			set_eiffel_name_user_precondition as inamed_signature_type_set_eiffel_name1_user_precondition,
			external_name as inamed_signature_type_external_name1,
			external_name_user_precondition as inamed_signature_type_external_name1_user_precondition,
			eiffel_name as inamed_signature_type_eiffel_name1,
			eiffel_name_user_precondition as inamed_signature_type_eiffel_name1_user_precondition,
			set_external_name as inamed_signature_type_set_external_name1,
			set_external_name_user_precondition as inamed_signature_type_set_external_name1_user_precondition
		end

	ISIGNATURE_TYPE_INTERFACE
		rename
			type_eiffel_name as isignature_type_type_eiffel_name1,
			type_eiffel_name_user_precondition as isignature_type_type_eiffel_name1_user_precondition,
			set_type_full_external_name as isignature_type_set_type_full_external_name1,
			set_type_full_external_name_user_precondition as isignature_type_set_type_full_external_name1_user_precondition,
			set_type_eiffel_name as isignature_type_set_type_eiffel_name1,
			set_type_eiffel_name_user_precondition as isignature_type_set_type_eiffel_name1_user_precondition,
			type_full_external_name as isignature_type_type_full_external_name1,
			type_full_external_name_user_precondition as isignature_type_type_full_external_name1_user_precondition
		end

	ECOM_QUERIABLE

creation
	make,
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make is
			-- Creation
		do
			initializer := ccom_create_named_signature_type_coclass
			item := ccom_item (initializer)
		end

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_named_signature_type_coclass_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	to_string: STRING is
			-- No description available.
		do
			Result := ccom_to_string (initializer)
		end

	get_hash_code: INTEGER is
			-- No description available.
		do
			Result := ccom_get_hash_code (initializer)
		end

	get_type: INTEGER is
			-- No description available.
		do
			Result := ccom_get_type (initializer)
		end

	internal_external_name: STRING is
			-- No description available.
		do
			Result := ccom_internal_external_name (initializer)
		end

	internal_type_full_external_name: STRING is
			-- No description available.
		do
			Result := ccom_internal_type_full_external_name (initializer)
		end

	internal_type_eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_internal_type_eiffel_name (initializer)
		end

	internal_eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_internal_eiffel_name (initializer)
		end

	external_name: STRING is
			-- No description available.
		do
			Result := ccom_external_name (initializer)
		end

	eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_eiffel_name (initializer)
		end

	type_eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_type_eiffel_name (initializer)
		end

	type_full_external_name: STRING is
			-- No description available.
		do
			Result := ccom_type_full_external_name (initializer)
		end

	x_internal_internal_external_name: STRING is
			-- No description available.
		do
			Result := ccom_x_internal_internal_external_name (initializer)
		end

	x_internal_internal_type_full_external_name: STRING is
			-- No description available.
		do
			Result := ccom_x_internal_internal_type_full_external_name (initializer)
		end

	x_internal_internal_type_eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_x_internal_internal_type_eiffel_name (initializer)
		end

	x_internal_internal_eiffel_name: STRING is
			-- No description available.
		do
			Result := ccom_x_internal_internal_eiffel_name (initializer)
		end

	inamed_signature_type_external_name1: STRING is
			-- No description available.
		do
			Result := ccom_inamed_signature_type_external_name1 (initializer)
		end

	inamed_signature_type_eiffel_name1: STRING is
			-- No description available.
		do
			Result := ccom_inamed_signature_type_eiffel_name1 (initializer)
		end

	isignature_type_type_eiffel_name1: STRING is
			-- No description available.
		do
			Result := ccom_isignature_type_type_eiffel_name1 (initializer)
		end

	isignature_type_type_full_external_name1: STRING is
			-- No description available.
		do
			Result := ccom_isignature_type_type_full_external_name1 (initializer)
		end

feature -- Basic Operations

	equals (obj: POINTER_REF): BOOLEAN is
			-- No description available.
			-- `obj' [in].  
		do
			Result := ccom_equals (initializer, obj.item)
		end

	make1 is
			-- No description available.
		do
			ccom_make1 (initializer)
		end

	set_eiffel_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_set_eiffel_name (initializer, a_name)
		end

	set_external_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_set_external_name (initializer, a_name)
		end

	set_type_full_external_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_set_type_full_external_name (initializer, a_name)
		end

	set_type_eiffel_name (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_set_type_eiffel_name (initializer, a_name)
		end

	set__internal_internal_external_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		do
			ccom_set__internal_internal_external_name (initializer, p_ret_val)
		end

	set__internal_internal_type_full_external_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		do
			ccom_set__internal_internal_type_full_external_name (initializer, p_ret_val)
		end

	set__internal_internal_type_eiffel_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		do
			ccom_set__internal_internal_type_eiffel_name (initializer, p_ret_val)
		end

	set__internal_internal_eiffel_name (p_ret_val: STRING) is
			-- No description available.
			-- `p_ret_val' [in].  
		do
			ccom_set__internal_internal_eiffel_name (initializer, p_ret_val)
		end

	inamed_signature_type_set_eiffel_name1 (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_inamed_signature_type_set_eiffel_name1 (initializer, a_name)
		end

	inamed_signature_type_set_external_name1 (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_inamed_signature_type_set_external_name1 (initializer, a_name)
		end

	isignature_type_set_type_full_external_name1 (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_isignature_type_set_type_full_external_name1 (initializer, a_name)
		end

	isignature_type_set_type_eiffel_name1 (a_name: STRING) is
			-- No description available.
			-- `a_name' [in].  
		do
			ccom_isignature_type_set_type_eiffel_name1 (initializer, a_name)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_named_signature_type_coclass(initializer)
		end

feature {NONE}  -- Externals

	ccom_to_string (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_equals (cpp_obj: POINTER; obj: POINTER): BOOLEAN is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](VARIANT *): EIF_BOOLEAN"
		end

	ccom_get_hash_code (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_INTEGER"
		end

	ccom_get_type (cpp_obj: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_INTEGER"
		end

	ccom_internal_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_internal_type_full_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_internal_type_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_internal_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_make1 (cpp_obj: POINTER) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"]()"
		end

	ccom_set_eiffel_name (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set_external_name (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_type_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set_type_full_external_name (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_set_type_eiffel_name (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_type_full_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_x_internal_internal_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set__internal_internal_external_name (cpp_obj: POINTER; p_ret_val: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_x_internal_internal_type_full_external_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set__internal_internal_type_full_external_name (cpp_obj: POINTER; p_ret_val: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_x_internal_internal_type_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set__internal_internal_type_eiffel_name (cpp_obj: POINTER; p_ret_val: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_x_internal_internal_eiffel_name (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_set__internal_internal_eiffel_name (cpp_obj: POINTER; p_ret_val: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_inamed_signature_type_set_eiffel_name1 (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_inamed_signature_type_external_name1 (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_inamed_signature_type_eiffel_name1 (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_inamed_signature_type_set_external_name1 (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_isignature_type_type_eiffel_name1 (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_isignature_type_set_type_full_external_name1 (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_isignature_type_set_type_eiffel_name1 (cpp_obj: POINTER; a_name: STRING) is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](EIF_OBJECT)"
		end

	ccom_isignature_type_type_full_external_name1 (cpp_obj: POINTER): STRING is
			-- No description available.
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](): EIF_REFERENCE"
		end

	ccom_create_named_signature_type_coclass: POINTER is
			-- Creation
		external
			"C++ [new ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"]()"
		end

	ccom_delete_named_signature_type_coclass (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"]()"
		end

	ccom_create_named_signature_type_coclass_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_ISE_Reflection_EiffelComponents::NamedSignatureType %"ecom_ISE_Reflection_EiffelComponents_NamedSignatureType.h%"]():EIF_POINTER"
		end

end -- NAMED_SIGNATURE_TYPE_PROXY

