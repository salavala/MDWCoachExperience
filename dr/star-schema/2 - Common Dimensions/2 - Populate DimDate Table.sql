INSERT INTO dbo.DimDate
(DateSK, DateValue, DateYear, DateMonth, DateDay, DateDayOfWeek, DateDayOfYear, DateWeekOfYear)
SELECT 
	Number AS DateSK,
	DateValue, 
	YEAR(DateValue) AS DateYear,
	MONTH(DateValue) AS DateMonth,
	DAY(DateValue) AS DateDay,
	DATEPART(WeekDay, DateValue) AS DateDayOfWeek,
	DATEPART(DayOfYear, DateValue) AS DateDayOfYear,
	DATEPART(Week, DateValue) AS DateWeekOfYear
FROM
(
	SELECT Number, DATEADD(d, Number - 1, '2017-01-01') AS DateValue
	FROM
	(
		SELECT Number
		FROM dbo.Numbers
		WHERE Number <= 365
	) AS N
) AS D;
