indexing
	description: "[
		Checked entity that describes and examines an assembly type method.
	]"
	author     : "$Author$"
	date       : "$Date$"
	revision   : "$Revision$"

class
	EC_CHECKED_MEMBER_METHOD

inherit
	EC_CHECKED_MEMBER_METHOD_BASE
		redefine
			member,
			check_extended_compliance,
			check_eiffel_compliance
		end

create
	make

feature -- Access {EC_CHECKED_MEMBER}
		
	member: METHOD_INFO
			-- Member that was examined.

feature -- Access	
			
	checked_return_type: EC_CHECKED_TYPE is
			-- `member' field type checked type.
		local
			l_member: like member
		do
			l_member := member
			if l_member.return_type /= Void then
				Result := checked_type (l_member.return_type)
			end
		end
			
feature {NONE} -- Basic Operations {EC_CHECKED_MEMBER}

	check_extended_compliance is
			-- Checks entity's CLS-compliance.
		local
			l_member: like member
			l_compliant: BOOLEAN
		do
			l_member := member
			if l_member.is_public or l_member.is_family or l_member.is_family_or_assembly then
				Precursor {EC_CHECKED_MEMBER_METHOD_BASE}
				if internal_is_compliant and not internal_is_marked then
					l_compliant := is_cls_member_name (l_member)
					if l_compliant then
						l_compliant := are_parameters_compliant (False)
						if l_compliant then
							if l_member.return_type /= Void then
								l_compliant := checked_return_type.is_compliant
								if not l_compliant then
									non_compliant_reason := non_compliant_reasons.reason_method_returns_non_complaint_type
								end
							end
						else
							non_compliant_reason := non_compliant_reasons.reason_parameters_uses_non_complaint_types
						end
					else
						non_compliant_reason := non_compliant_reasons.reason_method_name_is_non_compliant
					end
					internal_is_compliant := l_compliant
				end
			else
				internal_is_compliant := True
				internal_is_marked := True
			end
		end

	check_eiffel_compliance is
			-- Checks entity to see if it is Eiffel-compliant.
		local
			l_member: like member
			l_compliant: BOOLEAN
		do
			l_member := member	
			if (l_member.is_public or l_member.is_family or l_member.is_family_or_assembly) then
				Precursor {EC_CHECKED_MEMBER_METHOD_BASE}
				if internal_is_eiffel_compliant then
					l_compliant := are_parameters_compliant (True)
					if l_compliant then
						if l_member.return_type /= Void then
							l_compliant := checked_return_type.is_eiffel_compliant
							if not l_compliant then
								non_eiffel_compliant_reason := non_compliant_reasons.reason_method_returns_non_complaint_type
							end
						end
					else
						non_eiffel_compliant_reason := non_compliant_reasons.reason_parameters_uses_non_complaint_types
					end
				end
				internal_is_eiffel_compliant := l_compliant
			end
		end
			
end -- class EC_CHECKED_MEMBER_METHOD
