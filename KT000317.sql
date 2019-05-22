--/*FCRMVH Pedidos activos
DECLARE @CODEMP VARCHAR (6), @CODTRA VARCHAR (12), @NROLOT VARCHAR (3)
SET @NROLOT = '59'
SET @CODTRA = 'KT317'
SET @CODEMP = 'L2001'
--*/
SELECT 1 FLD001,
	   '####' FLD002,
	   FCRMVH_NROFOR FLD003,
	   SPACE(1) FLD004,
	   SPACE(1) FLD005,
	   FCRMVH_NROCTA FLD006,
	   VTMCLH_NOMBRE FLD007,
	   SPACE(1) FLD008,
	   RTRIM(CONVERT(VARCHAR,FCRMVI_TIPORI))+RTRIM(CONVERT(VARCHAR,FCRMVI_ARTORI)) FLD009,
	   STMPDH_DESCRP FLD010,
	   SUM(FCRMVI_CANTID) FLD011,
	   0 FLD012,
	   (select cast(datepart(day,F1.FCRMVH_FCHMOV)as varchar) + '-'+ cast(datepart(month,F1.FCRMVH_FCHMOV) as varchar)  + '-'+  Right(cast(datepart(year,F1.FCRMVH_FCHMOV) as varchar),2) 
	   from FCRMVH F1 WHERE F1.FCRMVH_CODEMP = FCRMVH.FCRMVH_CODEMP  and F1.FCRMVH_MODFOR = FCRMVH.FCRMVH_MODFOR and F1.FCRMVH_CODFOR = FCRMVH.FCRMVH_CODFOR
		AND F1.FCRMVH_NROFOR = FCRMVH.FCRMVH_NROFOR) FLD013,
	   FCRMVI_NROINI FLD014,
	   CONVERT(VARCHAR,FCRMVI_NROFOR) + RIGHT('000005' +CONVERT(VARCHAR,FCRMVI_NROITM),5) + '0' FLD015,
	   ';' FLD016,
 (CONVERT(VARCHAR,VTMCLH_NROCTA))+CONVERT(VARCHAR,1) FLD099 /*Orden de Registro*/
 
FROM  FCRMVH
INNER JOIN FCTCIH ON FCTCIH_CIRCOM = FCRMVH_CIRCOM AND  FCTCIH_CIRAPL = FCRMVH_CIRAPL 
INNER JOIN VTMCLH ON VTMCLH_NROCTA = FCRMVH_NROCTA AND  USR_VTMCLH_CODEMP =  @CODEMP
INNER JOIN FCRMVI ON FCRMVI_CODEMP = @CODEMP and FCRMVI_MODFOR = FCRMVH_MODFOR and FCRMVI_CODFOR = FCRMVH_CODFOR
AND FCRMVI_NROFOR = FCRMVH_NROFOR AND FCRMVI_TIPCPT = 'A'
INNER JOIN STMPDH ON STMPDH_TIPPRO = FCRMVI_TIPORI AND STMPDH_ARTCOD = FCRMVI_ARTORI

WHERE
ISNULL(USR_FCRMVH_ENVTAS,'N') = 'N' AND 
ISNULL(USR_FCTCIH_ENVIAR,'N') = 'S' AND
EXISTS(select * from STTTPH WHERE STTTPH_TIPPRO = FCRMVI_TIPORI AND  STTTPH_STOCKS = 'S') AND  
FCRMVH_CODEMP = @CODEMP
group by FCRMVH_NROFOR,
FCRMVH_NROCTA,
VTMCLH.VTMCLH_NROCTA,
VTMCLH_NOMBRE,
FCRMVI_NROFOR,
FCRMVI_NROITM,
STMPDH_DESCRP,
FCRMVI_TIPORI,
FCRMVI_ARTORI,
 FCRMVI_NROINI,
 FCRMVH_CODEMP,
 FCRMVH.FCRMVH_MODFOR,
 FCRMVH.FCRMVH_CODFOR,
 FCRMVH.FCRMVH_NROFOR
 Having SUM(FCRMVI_CANTID)>0
