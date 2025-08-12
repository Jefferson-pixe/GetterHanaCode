CREATE PROCEDURE "SBO_ALFISA".SBO_SP_TransactionNotification
(
	IN object_type 				NVARCHAR(30), 				-- SBO Object Type
	IN transaction_type 		NCHAR(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
	IN num_of_cols_in_key 		INT,
	IN list_of_key_cols_tab_del NVARCHAR(255),
	IN list_of_cols_val_tab_del NVARCHAR(255)
)
LANGUAGE SQLSCRIPT
AS
	-- Return values
	error  			INT;				-- 	Result (0 for no error)
	error_message 	NVARCHAR(200); 		-- 	Error string to be displayed
	x1 				INT;				-- 	numero inicial del while
	x2 				INT;				-- 	numero final del while
	username 		NVARCHAR(50);		-- 	obtener el usuario del documento
	docdate 		DATE;				-- 	obtener fecha del documento
	countsar 		INT;				-- 	cuenta los registros de la tabla correlativos sar
	checksar 		NCHAR(2);			-- 	revisar si aun tiene numeracion autorizada
	Err 			INT;

BEGIN
	error 			:= 0;
	error_message 	:= N'';
	checksar 		:= N'N';



/*******************************************************************************************************************/
/*********************************************** DOCUMENTOS DE COMPRA **********************************************/
/*******************************************************************************************************************/


/******************************* SOLICITUD DE COMPRA (1470000113) **********************************/

/* Inicio error 147113001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de solicitud de compra */
Err := 0;
IF ( 		(:transaction_type = 'A' OR :transaction_type = 'U') 
		AND :object_type ='112'
	) THEN
	SELECT 	COUNT(*) 
	INTO 	Err 
	FROM 	"ODRF" T0
			INNER JOIN "DRF1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE		T0."ObjType" 	= 	'1470000113'
			AND	T0."DocType"	=	'S' 
			AND T0."DocEntry" 	=  	:list_of_cols_val_tab_del
			AND (		IFNULL(T1."OcrCode2",'')='' 
					OR 	IFNULL(T1."AcctCode",'')='' 
					OR 	IFNULL(T1."OcrCode",'')=''
				);
				
	IF Err > 0 THEN
		error := 147113001;
		error_message := 'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 147113001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de solicitud de compra */	


/* Inicio error 147113002: Validacion de Cuenta,Sucursal y Centros de costo en solicitud de compra */
Err := 0;
IF ( 	(		:transaction_type = 'A' OR :transaction_type = 'U') 
			AND :object_type ='1470000113'
		) THEN
	SELECT 	COUNT(*) 
	INTO 	Err 
	FROM 	"OPRQ" T0
			INNER JOIN "PRQ1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE		T0."DocEntry" 	=  	:list_of_cols_val_tab_del
			AND	T0."DocType"	=	'S' 
			AND (		IFNULL(T1."OcrCode2",'')=	'' 
					OR 	IFNULL(T1."AcctCode",'')=	'' 
					OR 	IFNULL(T1."OcrCode",'')	=	''
				);
				
	IF Err > 0 THEN
		error := 147113002;
		error_message := N'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 147113002: Validacion de Cuenta,Sucursal y Centros de costo en solicitud de compra */	


/* Inicio error 147113003: Validacion para evitar la modificación de la fecha de contabilización. */
Err := 0;
IF ( 		:transaction_type = 'U' 
		AND :object_type ='1470000113'
	) THEN
	SELECT	COUNT(T0."DocEntry") 
	INTO 	Err
	FROM 	"OPRQ" T0		
			LEFT JOIN	(	SELECT 	ROW_NUMBER()OVER(PARTITION BY A1."DocEntry" ORDER BY A1."DocEntry",A1."LogInstanc" Desc) AS "Fila",    
									A1."LogInstanc",
									A1."DocEntry",
									A1."DocDate"
							FROM 	"ADOC" A1
							WHERE 	A1."ObjType"='1470000113'  																
						) T1 ON T0."DocEntry" = T1."DocEntry" AND T1."Fila" = 1  	   
	WHERE		T0."DocEntry" = :list_of_cols_val_tab_del
			AND T0."DocDate"!=T1."DocDate";

	IF Err > 0 THEN
		error := 147113003;
		error_message := N'No puede modificar la fecha de contabilización.';
	END IF;
END IF;	
/* Fin error 147113003: Validacion para evitar la modificación de la fecha de contabilización. */	



/******************************* FIN SOLICITUD DE COMPRA (1470000113) **********************************/




/******************************* OFERTA DE COMPRA (540000006) **********************************/

/* Inicio error 546000001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de Oferta de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='112') THEN
	SELECT COUNT(*) INTO Err 
	FROM "ODRF" T0
	INNER JOIN "DRF1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE 
	T0."ObjType" = '540000006' 
	AND T0."DocEntry" =  list_of_cols_val_tab_del
	AND	T0."DocType"	=	'S'
	AND (IFNULL(T1."OcrCode2",'')='' OR IFNULL(T1."AcctCode",'')='' OR IFNULL(T1."OcrCode",'')='');
	IF Err > 0 THEN
		error := 546000001;
		error_message := N'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 546000001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de Oferta de compra */	


/* Inicio error 546000002: Validacion de Cuenta,Sucursal y Centros de costo en Oferta de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='540000006') THEN
	SELECT COUNT(*) INTO Err 
	FROM "OPQT" T0
	INNER JOIN "PQT1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE 
	T0."DocEntry" =  list_of_cols_val_tab_del
	AND	T0."DocType"	=	'S'
	AND (IFNULL(T1."OcrCode2",'')='' OR IFNULL(T1."AcctCode",'')='' OR IFNULL(T1."OcrCode",'')='');
	IF Err > 0 THEN
		error := 546000002;
		error_message := N'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 546000002: Validacion de Cuenta,Sucursal y Centros de costo en Oferta de compra */	


/* Inicio error 546000003: Validacion para evitar la modificación de la fecha de contabilización. */
Err := 0;
IF ( transaction_type = 'U' AND object_type ='540000006') THEN
	SELECT COUNT(T0."DocEntry") INTO Err
	FROM "OPQT" T0		
	LEFT JOIN 
		(SELECT ROW_NUMBER() OVER(PARTITION BY A1."DocEntry" ORDER BY A1."DocEntry",A1."LogInstanc" Desc) AS "Fila",    
			A1."LogInstanc",A1."DocEntry",A1."DocDate"
			FROM "ADOC" A1
			WHERE A1."ObjType"='540000006'  																
		) T1 ON T0."DocEntry" = T1."DocEntry" AND T1."Fila" = 1  	   
	WHERE 
	T0."DocEntry" = :list_of_cols_val_tab_del
	AND T0."DocDate"!=T1."DocDate";
	IF Err > 0 THEN
		error := 546000003;
		error_message := N'No puede modificar la fecha de contabilización.';
	END IF;
END IF;	
/* Fin error 546000003: Validacion para evitar la modificación de la fecha de contabilización. */	



/* Inicio error 546000005: Validacion de encargado de compras en Oferta de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='540000006') THEN
	SELECT COUNT(*) INTO Err 
	FROM "OPQT" T0
	WHERE 
	T0."DocEntry" =  list_of_cols_val_tab_del
	AND T0."SlpCode"=-1;
	IF Err > 0 THEN
		error := 546000005;
		error_message := N'Debe Seleccionar un empleado del departamento de compras';
	END IF;
END IF;	
/* Fin error 546000005: Validacion de encargado de compras en Oferta de compra */	


/******************************* FIN OFERTA DE COMPRA (540000006) **********************************/





/******************************* ORDEN DE COMPRA - PEDIDO (22) **********************************/

/* Inicio error 220000001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de Orden de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='112') THEN
	SELECT COUNT(*) INTO Err 
	FROM "ODRF" T0
	INNER JOIN "DRF1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE 
	T0."ObjType" = '22' 
	AND T0."DocEntry" =  list_of_cols_val_tab_del
	AND	T0."DocType"	=	'S'
	AND (IFNULL(T1."OcrCode2",'')='' OR IFNULL(T1."AcctCode",'')='' OR IFNULL(T1."OcrCode",'')='');
	IF Err > 0 THEN
		error := 220000001;
		error_message := N'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 220000001: Validacion de Cuenta,Sucursal y Centros de costo en BORRADORES de Orden de compra */	


/* Inicio error 220000002: Validacion de Cuenta,Sucursal y Centros de costo en Orden de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='22') THEN
	SELECT COUNT(*) INTO Err 
	FROM "OPOR" T0
	INNER JOIN "POR1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE 
		T0."DocEntry" =  list_of_cols_val_tab_del
	AND	T0."DocType"	=	'S' 
	AND (IFNULL(T1."OcrCode2",'')='' OR IFNULL(T1."AcctCode",'')='' OR IFNULL(T1."OcrCode",'')='');
	IF Err > 0 THEN
		error := 220000002;
		error_message := N'Debe colocar Cuenta Contable, Sucursal y Centro de costo';
	END IF;
END IF;	
/* Fin error 220000002: Validacion de Cuenta,Sucursal y Centros de costo en Orden de compra */	


/* Inicio error 220000003: Validacion para evitar la modificación de la fecha de contabilización. */
Err := 0;
IF ( transaction_type = 'U' AND object_type ='22') THEN
	SELECT COUNT(T0."DocEntry") INTO Err
	FROM "OPOR" T0		
	LEFT JOIN 
		(SELECT ROW_NUMBER() OVER(PARTITION BY A1."DocEntry" ORDER BY A1."DocEntry",A1."LogInstanc" Desc) AS "Fila",    
			A1."LogInstanc",A1."DocEntry",A1."DocDate"
			FROM "ADOC" A1
			WHERE A1."ObjType"='22'  																
		) T1 ON T0."DocEntry" = T1."DocEntry" AND T1."Fila" = 1  	   
	WHERE 
	T0."DocEntry" = :list_of_cols_val_tab_del
	AND T0."DocDate"!=T1."DocDate";
	IF Err > 0 THEN
		error := 220000003;
		error_message := N'No puede modificar la fecha de contabilización.';
	END IF;
END IF;	
/* Fin error 220000003: Validacion para evitar la modificación de la fecha de contabilización. */	





/* Inicio error 220000004: Valida que en las lineas se establezcan los dias ETAS en la Orden de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='22') THEN
	SELECT 	COUNT(*) 
	INTO 	Err 
	FROM 	"OPOR" T0
			INNER JOIN "POR1" T1 ON T0."DocEntry" = T1."DocEntry"
	WHERE 		T0."DocEntry" =  list_of_cols_val_tab_del
			AND	T0."DocDate" >= '20240718'
			AND IFNULL(T1."U_diasETA",0) = 0;
	
	
	IF Err > 0 THEN
		error := 220000004;
		error_message := N'Debe colocar los dias ETA por cada linea de la Orden';
	END IF;
END IF;	
/* Finaliza error 220000004: Valida que en las lineas se establezcan los dias ETAS en la Orden de compra */









/* Inicio error 220000005: Validacion de encargado de compras en BORRADORES de Orden de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='112') THEN
	SELECT COUNT(*) INTO Err 
	FROM "ODRF" T0
	WHERE 
	T0."ObjType" = '22' 
	AND T0."DocEntry" =  list_of_cols_val_tab_del
	AND T0."SlpCode"=-1;
	IF Err > 0 THEN
		error := 220000005;
		error_message := N'Debe Seleccionar un empleado del departamento de compras';
	END IF;
END IF;	
/* Fin error 220000005: Validacion de encargado de compras en BORRADORES de Orden de compra */	


/* Inicio error 220000006:  Validacion de encargado de compras en Orden de compra */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='22') THEN
	SELECT COUNT(*) INTO Err 
	FROM "OPOR" T0
	WHERE 
	T0."DocEntry" =  list_of_cols_val_tab_del
	AND T0."SlpCode"=-1;
	IF Err > 0 THEN
		error := 220000006;
		error_message := N'Debe Seleccionar un empleado del departamento de compras';
	END IF;
END IF;	
/* Fin error 220000006:  Validacion de encargado de compras en Orden de compra */	


/******************************* FIN ORDEN DE COMPRA - PEDIDO (22) **********************************/





/******************************* FACTURA PROVEEDORES (18) **********************************/


/* Inicio error 180000003: Validacion de encargado de compras. */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='18') THEN
	SELECT COUNT(T0."DocEntry") INTO Err
	FROM "SBO_ALFISA"."OPCH" T0		
	WHERE 
	T0."DocEntry" = :list_of_cols_val_tab_del
	AND T0."SlpCode"=-1;
	IF Err > 0 THEN
		error := 180000003;
		error_message := N'Debe Seleccionar un empleado del departamento de compras.';
	END IF;
END IF;	
/* Fin error 180000003: Validacion de encargado de compras. */	


--AC--

/******** REQUIERE ANEXAR DOCUMENTO EN ACUERDO GLOBAL COMPRAS**************/	
/* Inicio error 1250000025: Acuerdo Global, debe Anexar imágenes o documentos relacionado a convenio con el Proveedor */

Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='1250000025') THEN

	SELECT COUNT(*) INTO Err 
	FROM "SBO_ALFISA"."OOAT" T0 
	WHERE T0."AbsID" =  list_of_cols_val_tab_del
	AND IFNULL(T0."AtchEntry",0) = 0
	AND T0."BpType" = 'S'; -- Aplicable a Proeedores
	IF Err > 0 THEN
		error := 1250000025;
		error_message := N'Acuerdo Global, debe Anexar imagen o documento relacionado a convenio con el Proveedor.';
	END IF;
END IF;	

/* Fin error 1250000025: Acuerdo Global, debe Anexar imagen o documento relacionado a convenio con el Proveedor.*/	

--***********************************************************************************************

--AC--
/* Inicio Validacion de Nota de Crédito Proveedor en ANEXOS / Objeto (19) */


Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='19') THEN
	SELECT COUNT(*) INTO Err 
	FROM "SBO_ALFISA"."ORPC" T0
		WHERE T0."DocEntry" =  list_of_cols_val_tab_del
		AND IFNULL(T0."AtcEntry",0) = 0
		AND T0."U_TCO" = 'I' ; -- Proveedor Extranjero (Importación)
		
	IF Err > 0 THEN
		error :=1;
		error_message := N'Para crear Nota de crédito a Proveedor del EXTERIOR, primero debe seleccionar Tipo de compra Importación y Anexar comprobante de transferencia en la Pestaña ANEXOS.';
	END IF;
END IF;	
/* Fin Validacion de Nota de crédito a Proveedores del EXTERIOR en ANEXOS */


/******************************* FIN ANEXOS Nota de Crédito PROVEEDORES (19) **********************************/


--AC--

/* Inicio error 1470000113: Validacion de ANEXOS en Solicitud de Compras Proveedor */
/*
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='1470000113') THEN
	SELECT COUNT(*) INTO Err 
	FROM "SBO_ALFISA"."OPRQ" T0 
	WHERE T0."DocEntry" =  list_of_cols_val_tab_del
	--AND T0."U_TipoTrabajo"='BLINDAJE'
	AND T0."DocType" = 'I'	-- Solicitud de comprar por artículos.
	AND IFNULL(T0."AtcEntry",0) = 0;
	IF Err > 0 THEN
		error := 1470000113;
		error_message := N'Solicitud de Compra, debe Anexar imagen de la pieza de repuesto o boleta de revisión del vehículo.';
	END IF;
END IF;	
/* Fin error 1470000113: Validacion de Factura del Proveedor en ANEXOS */


/******************************* FIN valiación ANEXOS en Solicitud de compras PROVEEDOR (1470000113) **********************************/



/*******************************************************************************************************************/
/***************************************************** UDOS ********************************************************/
/*******************************************************************************************************************/


/************************************* UDO ADDON CORREOS ***************************************/


/* Inicio error -900000001: Validacion para mantener solo una configuracion activa. */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='CONFI_CORREO') THEN
	SELECT COUNT(T0."Code") INTO Err
	FROM "SBO_ALFISA"."@CONFI_CORREO" T0	
	WHERE
	T0."U_Activo"='Y';
	IF Err > 1 THEN
		error := -900000001;
		error_message := N'Solo puede tener activa una configuración.';
	END IF;
END IF;	
/* Fin error -900000001: Validacion para mantener solo una configuracion activa. */	


/*********************************** FIN UDO ADDON CORREOS *************************************/

/************************************* UDO ADDON P2TOBANK ***************************************/


/* Inicio error -900000002: Validacion dos registros con mismo CIF. */
Err := 0;
IF ( (transaction_type = 'A' OR transaction_type = 'U') AND object_type ='P2BANK') THEN
	SELECT COUNT(*) INTO Err
	FROM "@P2BANK" T0
	INNER JOIN "@P2BANK" T1 ON T0."U_CIF" = T1."U_CIF" AND T1."Canceled" = 'N'
	WHERE
	T0."DocEntry" = :list_of_cols_val_tab_del;
	IF Err > 1 THEN
		error := -900000002;
		error_message := N'Ya existe un registro con este codigo de pago.';
	END IF;
END IF;
/* Fin error -900000002: Validacion dos registros con mismo CIF. */	


/*********************************** FIN UDO ADDON P2TOBANK *************************************/



	-- Validaciones Methos1
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	IF :error = 0	THEN
		error_message := '';
		CALL "M1_TransactionNotification"(:object_type, :transaction_type, :num_of_cols_in_key, :list_of_key_cols_tab_del, :list_of_cols_val_tab_del, error, error_message);
	END IF;	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
--------------------------------------------------------------------------------------------------------------------------------
	--error:=1;
	--error_message := 'Migración';
	
	 -- Select the return values
		SELECT 	:error, 
				:error_message 
		FROM 	DUMMY;

END;