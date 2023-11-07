use [VehclAcc]
select* from [dbo].[accident]
select* from [dbo].[vehicle]


--How many accidents happen in the uraban areas?

SELECT 
  Area, 
  COUNT(AccidentIndex) as 'Total Accidents' 
from 
  [dbo].[accident] 
group by 
  Area


--Which day of the week has highest number of accidents
SELECT TOP 1
    DAY,
    COUNT(AccidentIndex) AS 'Total Accidents'
FROM
    [dbo].[accident]
GROUP BY
    DAY
ORDER BY
    COUNT(AccidentIndex) DESC;




--What is the avg age of the vehciles involved in accidents based on their type?
SELECT VehicleType
	,COUNT(AccidentIndex) AS 'Total Accidents'
	,AVG(AgeVehicle) AS 'Average Age'
FROM [dbo].[vehicle]
WHERE AgeVehicle IS NOT NULL
GROUP BY VehicleType
ORDER BY [Total Accidents] DESC


--Can we find any trends in the accidents based on the vehicle type?
SELECT Agegroup,
COUNT([AccidentIndex]) AS 'Total Accidents',
AVG([AgeVehicle]) AS 'Average Age'
FROM(
SELECT
	[AccidentIndex],
	[AgeVehicle],
	CASE
		WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'NEW'
		WHEN [AgeVehicle] BETWEEN 6 AND 10 THEN 'REGULAR'
		ELSE 'OLD'
		END AS 'Agegroup'
	FROM [dbo].[vehicle] )
AS Subquery
Group by Agegroup



-- Are there any weather conditions for severe accidents?

DECLARE @Severity varchar(100)
SET @Severity = 'Fatal' --this severit can be changed accordingly Severe/Slight/Fatal
SELECT  WeatherConditions AS 'Total Accidents',COUNT (Severity) AS 'Severity'
FROM
[dbo].[accident]
where Severity = @Severity
GROUP BY WeatherConditions
order by Severity desc


--Do accidents often involve impacts on left hand side of the vehicles?
SELECT
	LeftHand,COUNT(AccidentIndex)
FROM
	[dbo].[vehicle]
GROUP BY LeftHand
HAVING
	LeftHand IS NOT NULL


--Are there any relationships between purpose of the journey and severity of the accidents?
select 
  V.[JourneyPurpose], 
  COUNT(A.[Severity]) as 'Total Accidents', 
  CASE WHEN COUNT(A.[Severity]) BETWEEN 0 
  AND 1000 THEN 'LOW' WHEN COUNT(A.[Severity]) BETWEEN 1001 
  AND 3000 THEN 'MODERATE' ELSE 'HIGH' END AS 'LEVEL' 
from 
  [dbo].[accident] A 
  join [dbo].[vehicle] V on V.[AccidentIndex] = A.[AccidentIndex] 
GROUP BY 
  V.[JourneyPurpose] 
ORDER BY 
  [Total Accidents] DESC



--Calculate the avg age of vehicles involved in accidents considering Day light and point of impact
DECLARE @IMPACT varchar(100)
DECLARE @LIGHT varchar(100)
SET @IMPACT = 'Front'
SET @LIGHT = 'Daylight'

SELECT
    AVG(V.AgeVehicle) AS 'Avg Age',
    A.LightConditions,
    V.PointImpact
FROM
    [dbo].[vehicle] V
JOIN [dbo].[accident] A ON A.[AccidentIndex] = V.AccidentIndex
GROUP BY
    A.LightConditions, V.PointImpact
HAVING
	PointImpact = @IMPACT AND LightConditions = @LIGHT
