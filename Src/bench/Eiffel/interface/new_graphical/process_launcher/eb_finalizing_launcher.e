indexing
	description: "Object which is response for launching c compiler in finalization mode."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_FINALIZING_LAUNCHER

inherit
	EB_C_COMPILER_LAUNCHER
		redefine
			on_start, generation_path
		end

create
	make

feature{NONE} -- Actions

	on_start is
			-- Handler called before c compiler starts
		do
			Precursor
			idle_printing_manager.add_printer ({EB_IDLE_PRINTING_MANAGER}.finalizing_printer)
		end

feature{NONE} -- Data storage

	data_storage: EB_PROCESS_IO_STORAGE is
		do
			Result := finalizing_storage
		end

feature{NONE} -- Generation path

	generation_path: STRING is
			-- Path on which c compiler will be launched.
			-- Used when we need to open a console there.
		do
			Result := final_generation_path
		end



end
