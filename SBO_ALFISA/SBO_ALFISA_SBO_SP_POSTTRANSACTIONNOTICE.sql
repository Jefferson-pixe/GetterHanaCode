CREATE PROCEDURE "SBO_ALFISA".SBO_SP_PostTransactionNotice
(
	in object_type nvarchar(30), 				-- SBO Object Type
	in transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	in num_of_cols_in_key int,
	in list_of_key_cols_tab_del nvarchar(255),
	in list_of_cols_val_tab_del nvarchar(255)
)
LANGUAGE SQLSCRIPT
AS
-- Return values
error  int;				-- Result (0 for no error)
error_message nvarchar (200); 		-- Error string to be displayed

/*------Variables Addon de correos-----------*/
C_CardCode NVARCHAR(15);
C_CardName NVARCHAR(100);
C_DocNum INT;
C_DocDate DATE;
/*------Fin variables Addon de correos-----------*/

begin

error := 0;
error_message := N'Ok';

--------------------------------------------------------------------------------------------------------------------------------

-- Select the return values
select :error, :error_message FROM dummy;

end;