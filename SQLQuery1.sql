-- Step 1: Create the FitBit database
create DATABASE  FitBit ; 

--Step 2 Get to know the database structure 
USE FitBit; 
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'; 
-- The output shows the available tables in the database.
-- output --
--1-dailyActivity_merged
--2-dailyCalories_merged
--3-dailyIntensities_merged
--4-dailySteps_merged
--5-heartrate_seconds_merged
--6-hourlyCalories_merged
--7-hourlySteps_merged
--8-sleepDay_merged
--9-hourlyIntensities_merged
--10-weightLogInfo_merged


-- Step 3: Explore the data in different tables
SELECT TOP 5 * FROM dailyActivity_merged;
SELECT TOP 5 * FROM dailyIntensities_merged;
SELECT TOP 5 * FROM dailySteps_merged;
SELECT TOP 5 * FROM dailyCalories_merged;
SELECT TOP 5 * FROM weightLogInfo_merged;
SELECT TOP 5 * FROM sleepDay_merged;


-- Explore additional tables related to exercise and heart rate
SELECT TOP 5 * FROM heartrate_seconds_merged;
SELECT TOP 5 * FROM hourlyCalories_merged;
SELECT TOP 5 * FROM hourlySteps_merged;
SELECT TOP 5 * FROM hourlyIntensities_merged;


--Is there a relationship between the intensity of exercise
--and the number of steps or the distance,
--and the heart rate,
--and does it affect the calories burned ?
--and does it affect the BMI








--Is there a relationship between the intensity of exercise
--and the number of steps,
--and the heart rate,
--and does it affect the calories burned per hour?



--Step 4:Process the data and update column formats
--the field “SleepDay” are not correctly formatted. --
--Time in the column has been removed as time is irrelevant in this analysis--

 ALTER TABLE sleepDay_merged ADD date_part DATE;
 UPDATE sleepDay_merged SET date_part = CONVERT(date, SleepDay);
 ALTER TABLE sleepDay_merged DROP COLUMN SleepDay;

--the field “Date” are not correctly formatted. --
ALTER TABLE weightLogInfo_merged ADD date_part DATE;
UPDATE weightLogInfo_merged SET date_part = CONVERT(date, Date);
ALTER TABLE weightLogInfo_merged DROP COLUMN Date;

----------------------------------------------

-- Step 5: Data analysis

-- 1. Activity level and calories burnt.
SELECT * FROM dailyActivity_merged;


-- 3. Total Sleep (Minutes) and calories burnt
SELECT TOP 5 * FROM dailyActivity_merged;
SELECT TOP 5 * FROM sleepDay_merged;

-- Calculate TotalActiveDistance and non_ActiveDistance
--TotalActiveDistance is the sum of the VeryActiveDistance, ModeratelyActiveDistance and LightActiveDistance that can be useful to find the relation between calories burnt and activity level.
SELECT activity.Id, ActivityDate,Calories, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed,TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, 
(VeryActiveDistance + ModeratelyActiveDistance) AS ActiveDistance, 
(LightActiveDistance+SedentaryActiveDistance) AS non_ActiveDistance, 
(VeryActiveMinutes+FairlyActiveMinutes) AS ActiveMinutes, 
(LightlyActiveMinutes+SedentaryMinutes) AS non_ActiveMinutes
FROM Fitbit.dbo.dailyActivity_merged AS activity
INNER JOIN Fitbit.dbo.sleepDay_merged AS sleep
ON activity.Id = sleep.Id ;

--ActiveDistance, non-ActiveDistance, ActiveMinutes and non-ActiveMinutes have been calculated to find out the relationship on sleep quality versus a person’s activity in a day.--

----------------------------------
--Activity level and BMI
SELECT distinct activity.Id, Calories, BMI,WeightKg, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance,SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes
FROM Fitbit.dbo.dailyActivity_merged AS activity
INNER JOIN Fitbit.dbo.weightLogInfo_merged AS weight
ON activity.Id = weight.Id ;












--What is the best time to burn calories during the day?
--the most desired time for workout
SELECT * FROM hourlyCalories_merged ;

--Update the column formats for hour_part and date_part

----------hour_part----------
ALTER TABLE hourlyCalories_merged
ADD hour_part VARCHAR(15);

UPDATE hourlyCalories_merged
SET hour_part =  RIGHT( ActivityHour,11);
   


  -----date_part-------
 ALTER TABLE hourlyCalories_merged
  ADD date_part DATE;
   

UPDATE hourlyCalories_merged
SET date_part = CONVERT(date, ActivityHour);






