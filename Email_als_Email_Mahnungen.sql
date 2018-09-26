DECLARE @AdressNrADR INT 
DECLARE @Email CHAR(50) 
/****** Variable @LaufNr wird als nächste LaufNr von ADR_Kommunikation gesetzt ******/ 
DECLARE @LaufNr INT 

SET @LaufNr = (SELECT Max(laufnr) + 1 
               FROM   adr_kommunikation) 

DECLARE cursor_mahnungen CURSOR FOR 
  SELECT adressnradr AS Adressnr, 
         email 
  FROM   adr_adressen 
  WHERE  adr_adressen.email IS NOT NULL 
         AND adressnradr NOT IN (SELECT adressnradr 
                                 FROM   adr_kommunikation 
                                 WHERE  telefonbez = 'E-Mail Mahnung') 

OPEN cursor_mahnungen 

FETCH next FROM cursor_mahnungen INTO @AdressNrADR, @Email 

WHILE @@FETCH_STATUS = 0 
  BEGIN 
      INSERT INTO [dbo].[adr_kommunikation] 
                  ([adressnradr], 
                   [telefonbez], 
                   [telefonnr], 
                   [importnr], 
                   [erstelltam], 
                   [erstelltvon], 
                   [geaendertam], 
                   laufnr, 
                   [geaendertvon], 
                   [geaendert], 
                   [exportiert]) 
      VALUES      (@AdressNrADR, 
                   'E-Mail Mahnung', 
                   Replace(@Email, ' ', ''), 
                   0, 
                   Getdate(), 
                   'ADMIN', 
                   Getdate(), 
                   @LaufNr, 
                   'ADMIN', 
                   1, 
                   0) 

      SET @LaufNr=@LaufNr + 1 

      FETCH next FROM cursor_mahnungen INTO @AdressNrADR, @Email 
  END 

CLOSE cursor_mahnungen 

DEALLOCATE cursor_mahnungen 
