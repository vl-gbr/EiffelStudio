﻿note
	description: "Eiffel test suite options"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class EW_TEST_SUITE_OPTIONS

create
	make

feature {NONE} -- Creation

	make
		do
			create {EW_FILTER_ALL} filter
			max_threads := -1
			display_summary := True
		end

feature  -- Properties

	keep_all: BOOLEAN
			-- Should output from all tests be retained,
			-- regardless of whether they passed or failed?

	keep_passed: BOOLEAN
			-- Should output from only passed tests be retained?

	keep_failed: BOOLEAN
			-- Should output from only failed tests be retained?

	is_cleanup_requested: BOOLEAN
			-- Should EIFGEN tree for retained directories
			-- be deleted?

	filter: EW_EIFFEL_TEST_FILTER
			-- Execute only tests selected by this filter

	max_threads: INTEGER
			-- Maximum number of worker threads to use
			-- to execute tests (ignored if single threaded)

	max_c_processes: INTEGER
			-- Maximum number of processes to use for
			-- one test for any required C compilations

	results_in_catalog_order: BOOLEAN
			-- Should test execution results be reported
			-- in order tests appear in catalog?
			-- If not, test results are reported as soon as
			-- they are available.
			-- Ignored if single threaded

	display_summary: BOOLEAN
			-- Should a summary of a test be shown?

feature -- Modification

	set_keep_all
		do
			keep_all := True
			keep_passed := False
			keep_failed := False
		ensure
			keep_option_set: keep_all
		end

	set_keep_passed
		do
			keep_all := False
			keep_passed := True
			keep_failed := False
		ensure
			keep_option_set: keep_passed
		end

	set_keep_failed
		do
			keep_all := False
			keep_passed := False
			keep_failed := True
		ensure
			keep_option_set: keep_failed
		end

	set_cleanup_requested (b: BOOLEAN)
		do
			is_cleanup_requested := b
		end

	set_filter (f: EW_EIFFEL_TEST_FILTER)
		do
			filter := f
		ensure
			filter_set: filter = f
		end

	set_max_threads (n: INTEGER)
		do
			max_threads := n
		ensure
			max_threads_set: max_threads = n
		end

	set_max_c_processes (n: INTEGER)
		do
			max_c_processes := n
		ensure
			max_c_processes_set: max_c_processes = n
		end

	set_results_in_catalog_order (b: BOOLEAN)
		do
			results_in_catalog_order := b
		ensure
			results_in_catalog_order_set: results_in_catalog_order = b
		end

	set_display_summary (value: BOOLEAN)
			-- Set `display_summary` to `value`.
		do
			display_summary := value
		ensure
			display_summary_set: display_summary = value
		end

note
	copyright: "[
			Copyright (c) 1984-2018, University of Southern California, Eiffel Software and contributors.
			All rights reserved.
		]"
	license:   "Your use of this work is governed under the terms of the GNU General Public License version 2"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"

end
