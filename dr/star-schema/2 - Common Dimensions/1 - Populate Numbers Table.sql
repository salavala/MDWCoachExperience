-- Declare local variables...
DECLARE
	@MaxNumber integer = 1;

-- Insert the seed number...
INSERT INTO dbo.Numbers
(Number)
VALUES
(1);

-- Loop through and insert additional data up to 1,048,576...
WHILE (@MaxNumber < 1000000)
BEGIN
	INSERT INTO dbo.Numbers
	(Number)
	SELECT Number + @MaxNumber
	FROM dbo.Numbers;

	SELECT @MaxNumber = MAX(Number)
	FROM dbo.Numbers;
END
