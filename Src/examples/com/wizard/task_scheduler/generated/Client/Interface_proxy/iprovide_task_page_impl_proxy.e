note
	description: "Implemented `IProvideTaskPage' interface."
	generator: "Automatically generated by the EiffelCOM Wizard."

class
	IPROVIDE_TASK_PAGE_IMPL_PROXY

inherit
	IPROVIDE_TASK_PAGE_INTERFACE

	ECOM_QUERIABLE

create
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (a_object: POINTER)
			-- Make from pointer
		do
			initializer := ccom_create_iprovide_task_page_impl_proxy_from_pointer(a_object)
			item := ccom_item (initializer)
		end

feature -- Basic Operations

	get_page (tp_type: INTEGER; f_persist_changes: INTEGER; ph_page: CELL [POINTER])
			-- Retrieves the property sheet pages associated with a task.
			-- `tp_type' [in]. See ECOM_X_TASKPAGE_ENUM for possible `tp_type' values. 
			-- `f_persist_changes' [in].  
			-- `ph_page' [out].  
		do
			ccom_get_page (initializer, tp_type, f_persist_changes, ph_page)
		end

feature {NONE}  -- Implementation

	delete_wrapper
			-- Delete wrapper
		do
			ccom_delete_iprovide_task_page_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_get_page (a_object: POINTER; tp_type: INTEGER; f_persist_changes: INTEGER; ph_page: CELL [POINTER])
			-- Retrieves the property sheet pages associated with a task.
		external
			"C++ [ecom_MS_TaskSched_lib::IProvideTaskPage_impl_proxy %"ecom_MS_TaskSched_lib_IProvideTaskPage_impl_proxy.h%"](EIF_INTEGER,EIF_INTEGER,EIF_OBJECT)"
		end

	ccom_delete_iprovide_task_page_impl_proxy (a_pointer: POINTER)
			-- Release resource
		external
			"C++ [delete ecom_MS_TaskSched_lib::IProvideTaskPage_impl_proxy %"ecom_MS_TaskSched_lib_IProvideTaskPage_impl_proxy.h%"]()"
		end

	ccom_create_iprovide_task_page_impl_proxy_from_pointer (a_pointer: POINTER): POINTER
			-- Create from pointer
		external
			"C++ [new ecom_MS_TaskSched_lib::IProvideTaskPage_impl_proxy %"ecom_MS_TaskSched_lib_IProvideTaskPage_impl_proxy.h%"](IUnknown *)"
		end

	ccom_item (a_object: POINTER): POINTER
			-- Item
		external
			"C++ [ecom_MS_TaskSched_lib::IProvideTaskPage_impl_proxy %"ecom_MS_TaskSched_lib_IProvideTaskPage_impl_proxy.h%"](): EIF_POINTER"
		end

end -- IPROVIDE_TASK_PAGE_IMPL_PROXY


