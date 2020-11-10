-- Check out the distinct ratings

SELECT DISTINCT [Rating] FROM [dbo].ConformedCatalog

-- Output: PG-13, G, R, PG=13, PG
-- Notice the typo of PG=13. The business would likely want to cleanse this for reporting purposes.

DECLARE @MaxSK INTEGER;
SELECT @MaxSK = ISNULL(MAX(MovieRatingSK),0) FROM [dbo].DimRatings

INSERT INTO [dbo].DimRatings(
	MovieRatingDescription,
	MovieRatingSK)
SELECT * FROM (
	SELECT 
		c.Rating AS MovieRatingDescription,
		@MaxSK + ROW_NUMBER() OVER (ORDER BY c.Rating) AS MovieRatingSK
	FROM 
		(SELECT
			DISTINCT CASE
				WHEN [Rating] = 'PG=13' THEN 'PG-13'
				ELSE [Rating]
			END AS Rating
		FROM
			[dbo].ConformedCatalog) c
) CleansedRatings
WHERE
	CleansedRatings.MovieRatingDescription NOT IN (SELECT MovieRatingDescription FROM [dbo].DimRatings)

SELECT * FROM [dbo].DimRatings