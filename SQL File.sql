-- Create the Database
CREATE DATABASE PROJECT

-- Change the Database
USE PROJECT


-- Create Table Query

create table Travel(
Tourist_ID	INT,
Country_Visited varchar(30),
City_Visited	varchar(20),
Mode_of_Travel	varchar(20),
Travel_Duration_Days	INT,
Number_of_Companions	INT,
Total_Travel_Cost	Float,
Accommodation_Type	varchar(20),
Main_Purpose	varchar(20),
Season_of_Visit varchar(20))


-- Insert Query using CSV File

BULK INSERT dbo.travel
FROM 'C:\Users\Sahana G M\OneDrive\Desktop\SQL NA Materials\SQL NA PROJECT\Tourist_Travel_Europe\Tourist_Travel_Europe.csv' --Please change the path
WITH
(
        FORMAT='CSV',
        FIRSTROW=2
)

-- Retrieving the Dataset

select * from Travel

--1. Fetch the first 5 records from the Travel Table 

SELECT top 5* FROM Travel

--2. Retrieve all the distinct travel modes used by tourists. 

SELECT DISTINCT Mode_of_travel
FROM Travel


--3. Retrieve all the distinct type of Accommodation used by tourists. 

SELECT DISTINCT Accommodation_Type
FROM Travel

--4. Display all records where the mode of travel is 'Flight'.

SELECT *
FROM Travel
Where Mode_of_Travel = 'FLIGHT'

--5. Count the number of tourists travelled to each country using different mode of travel.

SELECT Country_Visited,Mode_of_Travel,COUNT(tourist_id) as No_of_tourists
FROM Travel
GROUP BY Country_Visited,Mode_of_Travel

--6. Find total Tarvel Cost per person for different Mode of Travel for each Country. 

SELECT Tourist_ID,Mode_of_Travel,Country_Visited,SUM(Total_Travel_Cost) AS Total_Cost_Per_Person
FROM Travel
GROUP BY Tourist_ID,Mode_of_Travel,Country_Visited


--7. Find the top 5 most visited countries by tourists. 

SELECT top 5 Country_Visited, COUNT(tourist_ID) Number_of_country
FROM Travel
GrOUP By Country_Visited
Order BY COUNT(tourist_ID) DESC

--8. List the top 5 most visited cities in each Country. 

WITH CTE_top5_Visited_cities As
(
SELECT country_visited,
       City_Visited,
	   COUNT(tourist_ID) as Number_od_trouist,
       ROW_NUMBER() over(PARTITION BY City_Visited ORDER BY COUNT(tourist_ID) Desc ) as RN
FROM Travel
GROUP BY country_visited,City_Visited
)
SELECT country_visited,
       City_Visited,
	   Number_od_trouist
FROM CTE_top5_Visited_cities
Where RN<=5
ORDER BY  country_visited,Number_od_trouist DESC


--9. Find Total number of records, Minimum Number_of_Companions, Maximum 
--Number_of_Companions,Sum of Total_Travel_Cost. 

SELECT 
       COUNT(Tourist_ID) as [Total number of records],
	   MIN(Number_of_Companions) [Minimum Number_of_Companions],
	   MAX(Number_of_Companions)[Maximum Number_of_Companions],
	   SUM(Total_Travel_Cost) Total_travel_cost
FROM Travel


--10. Calculate the average trip duration for each mode of Travel.

SELECT AVG(travel_duration_days) AVG_TRAVEL_DURATION,
      Mode_of_Travel
FROM Travel
GROUP BY Mode_of_Travel

--11. Find the count of Tourist per Season and identify the peak season.

SELECT 
       TOP 1 Season_of_Visit,
       COUNT(tourist_id) as number_of_tourist
FROM Travel
GROUP BY Season_of_Visit
ORDER BY COUNT(tourist_id) DESC


--12. Calculate the average duration of travel for each season (Winter, Summer, Spring, Fall). 


SELECT AVG(travel_duration_days) AVG_TRAVEL_DURATION,
      Season_of_Visit
FROM Travel
GROUP BY  Season_of_Visit

---------------Below 
SELECT *
FROM
(
    SELECT  
           Season_of_Visit,
		   travel_duration_days
    FROM Travel
) AS SourceTable
PIVOT
(
    AVG(travel_duration_days)
    FOR  Season_of_Visit IN ([Winter],[Summer],[Spring],[Fall])
) AS PivotTable;

--13. Find the most popular accommodation type based on the number of trips. 


SELECT top 1 Accommodation_Type,
       COUNT(*) Number_of_trips	   
FROM Travel
GROUP BY Accommodation_Type
ORDER BY Number_of_trips DESC


--14. Identify the top 5 cities with the longest average stay duration. 

SELECT top 5 City_Visited,
       AVG(Travel_duration_days) as [average stay duration]
FROM Travel
GROUP BY City_Visited
ORDER BY AVG(Travel_duration_days) DESC


--15. Compare average, maximum and minimum Travel Cost per Accommodation type. 

SELECT Accommodation_Type,
       Round(AVG(total_travel_cost),2) [average tarvel cost],
	   MAX(total_travel_cost) [Max travel cost],
	   MIN(total_travel_cost) [Min travel cost ]
FROM Travel
GROUP BY Accommodation_Type

--(Are there outliers in the cost of different accommodation types.  
--Example: If an Airbnb stay costs more than luxury hotels, it may indicate outliers or 
--incorrect data.) 

--16. Find travel modes that are rarely used in specific locations.
--(Assuming fewer than 5 instances indicate an outlier) 

SELECT COUNT(*) trip_count,
       City_Visited,
	   Mode_of_Travel
FROM Travel
GROUP BY City_Visited,
	   Mode_of_Travel
Having COUNT(*)<5
ORDER BY City_Visited, trip_count

--17. Find unusually large travel groups. (Method: Use Z-score to detect groups that are 
--significantly larger than average.) 
--Z-Score = (No_Of_Companions - Mean of No_Of_Companions)/ (standard_deviation of 
--No_Of_Companions) 

--Not aware of zscore Concept

--18. Find the country with the highest percentage of family Visit as Main_Purpose. 

SELECT 
       country_visited,COUNT(Tourist_ID) family_trips
FROM Travel
GROUP BY country_visited,Main_Purpose
HAVING Main_Purpose = 'Family Visit'

--19. Determine if certain cities are more popular for solo travelers vs. group travelers. 

WITH CTE_travelType As
(
SELECT City_Visited,
       (case when Number_of_Companions<2 then 'Solo Travelers'
            ELSE 'group travelers'
			END 
			) as Traveler_Category
FROM Travel
)
SELECT City_Visited,
       Traveler_Category,
	   COUNT(Traveler_Category) as number_of_tripis
FROM CTE_travelType
GROUP BY City_Visited,Traveler_Category
ORDER BY City_Visited,Traveler_Category

--20. Find the Tourist_ID for the longest trip in terms of duration for each country. 

WITH CTE_Trips As
(
SELECT Tourist_ID,
       Country_Visited,
	   travel_duration_days,
	   ROW_NUMBER() OVER(PARTITION BY  Country_Visited ORDER BY  travel_duration_days DESC) RN
FROM Travel
)
SELECT Tourist_ID,
       Country_Visited,
	   travel_duration_days
FROM CTE_Trips
Where RN =1

