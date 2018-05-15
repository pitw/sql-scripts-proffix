DECLARE @AdressNrADR int
DECLARE @Email char(50)

/****** Variable @LaufNr als tiefste LaufNr aus ADR_Kommunikation setzen! ******/
DECLARE @LaufNr int = 16

DECLARE cursor_mahnungen CURSOR FOR
SELECT AdressNrADR,EMail FROM dbo.ADR_Adressen 
WHERE dbo.ADR_Adressen.EMail IS NOT NULL
OPEN cursor_mahnungen

FETCH NEXT FROM cursor_mahnungen
INTO @AdressNrADR, @Email

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO [dbo].[ADR_Kommunikation]
           ([AdressNrADR]
           ,[TelefonBez]
           ,[TelefonNr]
           ,[ImportNr]
           ,[ErstelltAm]
           ,[ErstelltVon]
           ,[GeaendertAm]
		   ,LaufNr
           ,[GeaendertVon]
           ,[Geaendert]
           ,[Exportiert])
     VALUES
           (@AdressNrADR
           ,'E-Mail Mahnung'
           ,REPLACE(@Email, ' ', '')
           ,0
           ,GETDATE()
           ,'ADMIN'
           ,GETDATE()
		   ,@LaufNr
           ,'ADMIN'
           ,1
           ,0)
SET @LaufNr=@LaufNr+1

    FETCH NEXT FROM my_cursor
INTO @AdressNrADR, @Email
END

CLOSE cursor_mahnungen
DEALLOCATE cursor_mahnungen
