indexing
	description:
		"Constants for server commands"

	status:	"See note at end of class"
	date: "$Date$"
	revision: "$Revision$"

class 
	TRANSFER_COMMAND_CONSTANTS

feature {NONE} -- Constants for FTP

	Ftp_user_command: STRING is "USER"

	Ftp_password_command: STRING is "PASS"

	Ftp_text_mode_command: STRING is "TYPE A"

	Ftp_binary_mode_command: STRING is "TYPE I"

	Ftp_port_command: STRING is "PORT"

	Ftp_passive_mode_command: STRING is "PASV"

	Ftp_retrieve_command: STRING is "RETR"

	Ftp_store_command: STRING is "STOR"
	
feature {NONE} -- Constants for HTTP

	Http_get_command: STRING is "GET"

	Http_version: STRING is "HTTP/1.0"
	
	Http_host_header: STRING is "Host"
	
	Http_Authorization_header: STRING is "Authorization"

	Http_end_of_header_line: STRING is "%R%N"

	Http_end_of_command: STRING is "%R%N%R%N"

end -- class TRANSFER_COMMAND_CONSTANTS

--|----------------------------------------------------------------
--| EiffelNet: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

