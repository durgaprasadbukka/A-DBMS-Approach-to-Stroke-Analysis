## Objective 1: Identify Key Health Factors Influencing Stroke

# Query 1.1: Patients with Stroke, Hypertension, and High BMI
SELECT p.Patient_ID, p.Age, m.BMI, m.Avg_Glucose_Level, 
       c.Hypertension, c.Heart_Disease, c.Stroke
FROM Patient p
JOIN Conditions c ON p.Patient_ID = c.Patient_ID
JOIN Metrics m ON c.Conditions_ID = m.Conditions_ID
WHERE c.Stroke = 1 AND c.Hypertension = 1 AND m.BMI > 30
ORDER BY m.BMI DESC;

#Query 1.2: Average Glucose and BMI for Stroke vs Non-Stroke Patients
SELECT c.Stroke, 
       ROUND(AVG(m.Avg_Glucose_Level), 2) AS Avg_Glucose,
       ROUND(AVG(m.BMI), 2) AS Avg_BMI
FROM Conditions c
JOIN Metrics m ON c.Conditions_ID = m.Conditions_ID
GROUP BY c.Stroke;

# Difference (or delta) between stroke and non-stroke groups for average glucose and BMI
SELECT 
    'Glucose' AS Metric,
    ROUND(AVG(CASE WHEN c.Stroke = 1 THEN m.Avg_Glucose_Level END) 
        - AVG(CASE WHEN c.Stroke = 0 THEN m.Avg_Glucose_Level END), 2) AS Difference
FROM Conditions c
JOIN Metrics m ON c.Conditions_ID = m.Conditions_ID

UNION ALL

SELECT 
    'BMI' AS Metric,
    ROUND(AVG(CASE WHEN c.Stroke = 1 THEN m.BMI END) 
        - AVG(CASE WHEN c.Stroke = 0 THEN m.BMI END), 2) AS Difference
FROM Conditions c
JOIN Metrics m ON c.Conditions_ID = m.Conditions_ID;

##Objective 2: Analyze the Impact of Lifestyle on Stroke Risk

#Query 2.1: Stroke Count Grouped by Smoking Status
SELECT l.Smoking_Status, COUNT(c.Stroke) AS Stroke_Count
FROM Lifestyle l
JOIN Conditions c ON l.Conditions_ID = c.Conditions_ID
WHERE c.Stroke = 1
GROUP BY l.Smoking_Status
ORDER BY Stroke_Count DESC;

#Cross-check smoking status with other risk factors (e.g., hypertension, glucose levels):
#Do non-smokers have higher hypertension rates?
SELECT 
    l.Smoking_Status AS 'Smoking Status', 
    COUNT(CASE WHEN c.Hypertension = 1 THEN 1 END) AS 'Hypertensive Count',
    COUNT(*) AS 'Total Count',
    ROUND((COUNT(CASE WHEN c.Hypertension = 1 THEN 1 END) / COUNT(*)) * 100, 2) AS 'Hypertension Percentage'
FROM Lifestyle l
JOIN Conditions c ON l.Conditions_ID = c.Conditions_ID
GROUP BY l.Smoking_Status
ORDER BY 'Hypertension Percentage' DESC;

## Are formerly smokers more obese? 
SELECT 
    l.Smoking_Status AS 'Smoking Status', 
    ROUND(AVG(m.BMI), 2) AS 'Average BMI'
FROM Lifestyle l
JOIN Conditions c ON l.Conditions_ID = c.Conditions_ID
JOIN Metrics m ON c.Conditions_ID = m.Conditions_ID
GROUP BY l.Smoking_Status
ORDER BY 'Average BMI' DESC;

#Query 2.2: Stroke Count Grouped by Work Type
SELECT l.Work_Type, COUNT(c.Stroke) AS Stroke_Count
FROM Lifestyle l
JOIN Conditions c ON l.Conditions_ID = c.Conditions_ID
WHERE c.Stroke = 1
GROUP BY l.Work_Type
ORDER BY Stroke_Count DESC;

##Objective 3: Geographical Insights into Health Conditions and Stroke
#Query 3.1: Stroke Cases by Region
SELECT loc.Region, COUNT(c.Stroke) AS Stroke_Count
FROM Location loc
JOIN Conditions c ON loc.Conditions_ID = c.Conditions_ID
WHERE c.Stroke = 1
GROUP BY loc.Region
ORDER BY Stroke_Count DESC;

#Query 3.2: Region-Wise Distribution of Patients with Hypertension
SELECT loc.Region, COUNT(c.Hypertension) AS Hypertension_Count
FROM Location loc
JOIN Conditions c ON loc.Conditions_ID = c.Conditions_ID
WHERE c.Hypertension = 1
GROUP BY loc.Region
ORDER BY Hypertension_Count DESC;