DROP EXTERNAL TABLE [dbo].ConformedCatalog

CREATE EXTERNAL TABLE [dbo].ConformedCatalog
    (
        [SourceSystemId] VARCHAR(2),
		[SourceSystemMovieId] VARCHAR(38),
		[SouthridgeMovieId] VARCHAR(38),
		[PhysicalAvailabilityDate] DATETIME,
		[StreamingAvailabilityDate] DATETIME,
		[Genre] VARCHAR(50),
		[Title] VARCHAR(255),
		[Rating] VARCHAR(10),
		[RuntimeMinutes] BIGINT,
		[TheatricalReleaseYear] BIGINT,
        [ActorName] VARCHAR(100),
		[ActorId] VARCHAR(38),
        [ActorGender] CHAR(1),
		[CatalogId] VARCHAR(38)
    )
WITH
    (
        LOCATION = '/conformed/catalog',  
        DATA_SOURCE = ABFS,  
        FILE_FORMAT = [ParquetFormat]  
    )  
GO

SELECT TOP 100 * FROM [dbo].ConformedCatalog