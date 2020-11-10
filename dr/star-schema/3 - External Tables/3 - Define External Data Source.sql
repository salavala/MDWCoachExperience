CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'change_me_123';

-- 'Managed Service Identity' is a literal string which produces magic, so don't change it
CREATE DATABASE SCOPED CREDENTIAL msi_cred WITH IDENTITY = 'Managed Service Identity';

-- Change the filesys and stoacct in the LOCATION below, such that they are
-- the file system and storage account established by the team
CREATE EXTERNAL DATA SOURCE ABFS
WITH
(
    TYPE=HADOOP,
    LOCATION='abfss://filesys@stoacct.dfs.core.windows.net',
    CREDENTIAL=msi_cred
);
GO

CREATE EXTERNAL FILE FORMAT [ParquetFormat]
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);  