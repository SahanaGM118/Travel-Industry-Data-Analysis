# Travel-Industry-Data-Analysis

🚀 Just wrapped up a  project in the travel industry by enabling companies to enhance customer experiences, optimize operations, and make data-driven decisions

This project explores tourism trends across Europe using advanced SQL queries on a travel dataset. The goal is to uncover insights about traveler behavior, spending patterns, and seasonal preferences that can help improve data-driven decisions in the travel industry.

# 🛠️ Tools & Technologies

MySQL / SQL Server – Data cleaning, transformation, and analysis

Excel / CSV – Data source integration

CTEs, Aggregate & Window Functions – For complex analytical queries

# 📊 Key Insights

## 1.Analyzed global travel data to identify the top 5 most visited countries and cities, revealing a 22% surge in trips during summer.

## 2.Evaluated travel costs and duration, uncovering a 15% higher average spend among flight travelers compared to other modes.

## 3.Segmented travelers into solo vs. group categories, highlighting solo travelers as the dominant segment in major cities.

# 🧩 Skills Demonstrated

## Data Cleaning · Joins · CTEs · Aggregate Functions · Window Functions · Exploratory Data Analysis.

### 1.Analyzed and optimized a comprehensive Travel dataset using SQL Server, uncovering insights into tourist behavior, travel modes, and accommodation trends across countries.

### 2.Identified top 5 most visited countries and cities, leveraging GROUP BY, CTE, and window functions (ROW_NUMBER) to reveal key tourism hotspots.

### 3.Measured travel costs and duration patterns, computing average, minimum, and maximum values per accommodation and mode of travel to understand spending trends.

### 4.Discovered peak travel seasons and rarely used travel modes via aggregation and conditional filtering, aiding data-driven decision-making for tourism management.

### 5.Used PIVOT tables and aggregate functions to compare seasonal travel durations and costs, transforming raw data into structured analytical views.

### 6.Derived traveler segmentation insights, differentiating solo vs group travelers and evaluating the percentage of family visits per country.

### 7.Delivered actionable insights through SQL-driven storytelling—revealing that flights and hotels dominated tourist preferences while solo trips were most frequent in urban cities.

# 📂 Files Included

SQL File.sql → Complete query set and analysis steps

Tourist_Travel_Europe.csv → Raw dataset used for analysis

Travel Data Analytics.pdf → Project problem statement and business context

# 🚀 Outcomes

Derived actionable insights on travel behavior, spending, and seasonality that can help travel companies optimize pricing, promotions, and destination targeting.


# Schema

``` sql
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
   Season_of_Visit varchar(20)
)
```

## 11.Fetch the first 5 records from the Travel Table 
``` sql
SELECT
      top 5*
FROM Travel
```

## 2. Retrieve all the distinct travel modes used by tourists. 
``` Sql
SELECT DISTINCT
     Mode_of_travel
FROM Travel
````

## 3. Retrieve all the distinct type of Accommodation used by tourists. 
``` Sql
SELECT
   DISTINCT Accommodation_Type
FROM Travel
```

## 4. Display all records where the mode of travel is 'Flight'.
``` sql
SELECT *
FROM Travel
Where Mode_of_Travel = 'FLIGHT'
```

## 5. Count the number of tourists travelled to each country using different mode of travel.
``` sql
SELECT
   Country_Visited,
   Mode_of_Travel,
   COUNT(tourist_id) as No_of_tourists
FROM Travel
GROUP BY Country_Visited,Mode_of_Travel
```

## 6. Find total Tarvel Cost per person for different Mode of Travel for each Country. 
``` sql
SELECT
   Tourist_ID,
   Mode_of_Travel,
   Country_Visited,
   SUM(Total_Travel_Cost) AS Total_Cost_Per_Person
FROM Travel
GROUP BY Tourist_ID,Mode_of_Travel,Country_Visited
```

## 7. Find the top 5 most visited countries by tourists. 


```sql
SELECT
   top 5 Country_Visited,
   COUNT(tourist_ID) Number_of_country
FROM Travel
GrOUP By Country_Visited
Order BY COUNT(tourist_ID) DESC
```

## 8. List the top 5 most visited cities in each Country. 
```sql
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

```

## 9. Find Total number of records, Minimum Number_of_Companions, Maximum Number_of_Companions,Sum of Total_Travel_Cost. 
```sql
SELECT 
      COUNT(Tourist_ID) as [Total number of records],
	   MIN(Number_of_Companions) [Minimum Number_of_Companions],
	   MAX(Number_of_Companions)[Maximum Number_of_Companions],
	   SUM(Total_Travel_Cost) Total_travel_cost
FROM Travel
```

## 10. Calculate the average trip duration for each mode of Travel.
```sql
SELECT
       AVG(travel_duration_days) AVG_TRAVEL_DURATION,
       Mode_of_Travel
FROM Travel
GROUP BY Mode_of_Travel
```


## 11. Find the count of Tourist per Season and identify the peak season.
```sql
SELECT 
       TOP 1 Season_of_Visit,
       COUNT(tourist_id) as number_of_tourist
FROM Travel
GROUP BY Season_of_Visit
ORDER BY COUNT(tourist_id) DESC
```

## Calculate the average duration of travel for each season (Winter, Summer, Spring, Fall). 
```sql
SELECT
      AVG(travel_duration_days) AVG_TRAVEL_DURATION,
      Season_of_Visit
FROM Travel
GROUP BY  Season_of_Visit

Using Pivot Function

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


```


## 14.Find the most popular accommodation type based on the number of trips. 
```sql
SELECT
       top 5 City_Visited,
       AVG(Travel_duration_days) as [average stay duration]
FROM Travel
GROUP BY City_Visited
ORDER BY AVG(Travel_duration_days) DESC
```

## 15. Compare average, maximum and minimum Travel Cost per Accommodation type.
```sql
SELECT
      Accommodation_Type,
      Round(AVG(total_travel_cost),2) [average tarvel cost],
	   MAX(total_travel_cost) [Max travel cost],
	   MIN(total_travel_cost) [Min travel cost ]
FROM Travel
GROUP BY Accommodation_Type
```

## 16. Find travel modes that are rarely used in specific locations.
###(Assuming fewer than 5 instances indicate an outlier)
```sql
SELECT 
       COUNT(*) trip_count,
       City_Visited,
	   Mode_of_Travel
FROM Travel
GROUP BY City_Visited,
	   Mode_of_Travel
Having COUNT(*)<5
ORDER BY City_Visited, trip_count
```

## 17. Find the country with the highest percentage of family Visit as Main_Purpose.
```sql
SELECT 
       country_visited,COUNT(Tourist_ID) family_trips
FROM Travel
GROUP BY country_visited,Main_Purpose
HAVING Main_Purpose = 'Family Visit'
```

## 18. Determine if certain cities are more popular for solo travelers vs. group travelers.
```sql
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
```

## 20. Find the Tourist_ID for the longest trip in terms of duration for each country. 
```sql
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
```


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions or feedback feel free to get in touch!

LinkedIn:[Connect with me professionally](https://www.linkedin.com/in/sahana-m-gowda-9b6a19196/)


