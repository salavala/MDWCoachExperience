INSERT INTO dbo.DimTime
(TimeSK, TimeValue, TimeHour, TimeMinute, TimeSecond, TimeMinuteOfDay, TimeSecondOfDay)
SELECT
	Number AS TimeSK,
	TimeValue,
	DATEPART(HOUR, TimeValue) AS TimeHour,
	DATEPART(MINUTE, TimeValue) AS TimeMinute,
	DATEPART(SECOND, TimeValue) AS TimeSecond,
	DATEPART(MINUTE, TimeValue) + (DATEPART(HOUR, TimeValue) * 60) AS TimeMinuteOfDay,
	DATEPART(SECOND, TimeValue) + ((DATEPART(MINUTE, TimeValue) + (DATEPART(HOUR, TimeValue) * 60)) * 60) AS TimeSecondOfDay
FROM
(
	SELECT Number, CAST(DATEADD(s, Number - 1, '2017-01-01') as time(7)) AS TimeValue
	FROM dbo.Numbers
	WHERE Number <= 86400
) AS T;
