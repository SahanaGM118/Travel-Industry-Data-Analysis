# Travel-Industry-Data-Analysis
Data analytics is transforming the travel industry by enabling companies to enhance customer experiences, optimize operations, and make data-driven decisions

## 1. Introduction to Travel Industry Data Analytics 
• Data analytics in the travel industry helps businesses optimize operations, improve 
customer experiences, and boost revenue. 

• Uses historical data, real-time insights, and predictive analytics to enhance decision
making. 

## 2. Key Data Sources 
• Booking & Reservation Data (Flights, Hotels, Tours)

• Customer Data (Demographics, Preferences, Feedback) 

• Website & Mobile App Analytics (User Behavior, Search Trends) 

• Social Media & Review Platforms (Sentiment Analysis, Ratings) 

• Market & Competitor Data (Pricing, Offers, Demand Trends)

## 3. Types of Analytics in Travel Industry 

-- Descriptive Analytics – Summarizes historical trends (e.g., seasonal demand, customer 
preferences). 

-- Predictive Analytics – Forecasts future trends using ML (e.g., demand prediction, dynamic 
pricing). 

-- Prescriptive Analytics – Suggests optimal actions (e.g., personalized recommendations, 
pricing strategies). 

-- Real-time Analytics – Monitors ongoing travel trends (e.g., flight delays, surge pricing). 

## 4. Applications of Data Analytics in Travel

-- Customer Personalization – Recommending destinations, hotels, and packages based on 
past behavior. 

-- Revenue Management & Dynamic Pricing – Adjusting prices based on demand, 
competitor pricing, and seasonality. 

--✈ Operational Efficiency – Optimizing airline routes, hotel occupancy, and transportation 
schedules. 

-- � Marketing & Customer Engagement – Targeted promotions, loyalty programs, and churn 
prediction. 

-- Fraud Detection – Identifying anomalies in bookings and payments. 

## 5. Tools & Technologies Used 
• Data Processing: Python, R, SQL 

• BI & Visualization: Tableau, Power BI 

• Machine Learning: Scikit-learn, TensorFlow 

• Big Data: Hadoop, Spark 

• Geospatial Analysis: GIS, Google Maps API

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


This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

LinkedIn:

