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


/*-------------------------Addon de correos---------------------------------*/
IF (:object_type = '46'  AND :transaction_type='A') 
THEN
	
	SELECT 
	T0."CardName",T0."CardCode",T0."DocNum",T0."DocDate"
	INTO C_CardName,C_CardCode,C_DocNum,C_DocDate
	FROM "SBO_ALFISA"."OVPM" T0
	INNER JOIN "SBO_ALFISA"."@CONFI_CORREO" T1 ON T1."U_Activo"='Y'
	INNER JOIN "SBO_ALFISA"."OCRD" T2 ON T0."CardCode"=T2."CardCode" AND IFNULL(T2."E_Mail",'')!='' 
	WHERE
	T0."DataSource"='A' AND
	T0."Status"='Y' AND
	T0."DocEntry"= :list_of_cols_val_tab_del;
	
	IF(IFNULL(:C_DocNum,0)!=0)
	THEN
		INSERT INTO "SBO_ALFISA"."@LOG_CORREOS" ("Code","Name","U_CardCode","U_DocEntryP","U_DocNumP","U_Fecha","U_Comentarios")
		VALUES ("SBO_ALFISA".CORREOS_S.NEXTVAL,:C_CardName,:C_CardCode,:list_of_cols_val_tab_del,:C_DocNum,:C_DocDate,null);
	END IF;
			
END IF; 
/*-------------------------Fin Addon de correos v2---------------------------------*/



-- Select the return values
select :error, :error_message FROM dummy;

end;