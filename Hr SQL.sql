select * from Employee
select * from EducationLevel
select * from PerformanceRating
select * from RatingLevel
select * from SatisfiedLevel

--Rename column name--
EXEC sp_rename 'Employee.EducationLevelID', 'Education', 'COLUMN';

-- checking nulls  -- 
SELECT * 
FROM Employee 
WHERE  Gender is null or Age is null or BusinessTravel is null
      or Department is null or DistanceFromHome_KM is null or State is null 
      or Ethnicity is null or EducationLevelID is null or EducationField is null 
	  or JobRole  is null or MaritalStatus is null or Salary is null
	  or StockOptionLevel is null or OverTime is null
	  or HireDate is null or Attrition is null 
	  or YearsAtCompany is null or YearsInMostRecentRole is null 
	  or YearsSinceLastPromotion is null or YearsWithCurrManager is null  

--checking duplicated Rows--- 
 --Employees--

SELECT EmployeeID, FirstName, LastName, Gender, Age, Department,Salary, StockOptionLevel, OverTime, HireDate, Attrition,
       YearsAtCompany, YearsInMostRecentRole, YearsSinceLastPromotion,YearsWithCurrManager, COUNT(*) AS DuplicateCount
FROM Employee
GROUP BY EmployeeID, FirstName, LastName, Gender, Age, Department,Salary, StockOptionLevel, OverTime,
         HireDate, Attrition, YearsAtCompany,YearsInMostRecentRole, YearsSinceLastPromotion,YearsWithCurrManager
HAVING COUNT(*) > 1;



--Adding Foreign Keys--

---- adding [Employee_ID] fk--

 ALTER TABLE PerformanceRating
 ADD CONSTRAINT FK_employeeID
 FOREIGN KEY (EmployeeID)
 REFERENCES Employee(EmployeeID)

  -- adding education levelID fk-- 

ALTER TABLE employee 
ADD CONSTRAINT fk_Employee
FOREIGN KEY (EducationlevelID)
REFERENCES EducationLevel(EducationlevelID)

-- adding [Environment_SatisfactionID] fk--

ALTER TABLE PerformanceRating
ADD CONSTRAINT fk_Environment_SatisfactionID
FOREIGN KEY (EnvironmentSatisfaction)
REFERENCES RatingLevel(RatingID)


-- adding [JOB_SatisfactionID] fk--

ALTER TABLE PerformanceRating 
ADD CONSTRAINT FK_job_SatisfactionID
FOREIGN KEY (JobSatisfaction)
REFERENCES RatingLevel(RatingID)

---- adding [Self_RatingID] fk--
ALTER TABLE performanceRating
ADD CONSTRAINT FK_Self_RatingID
FOREIGN KEY (SelfRating)
REFERENCES SatisfiedLevel(SatisfactionID)

 ---- adding [Manger_RatingID] fk--

 ALTER TABLE performanceRating
ADD CONSTRAINT FK_Manger_RatingID
FOREIGN KEY (SelfRating)
REFERENCES SatisfiedLevel(SatisfactionID)


-------------------
--adding columns --

ALTER TABLE employee
ADD Experience INT;

UPDATE employee
SET Experience = YearsAtCompany + YearsInMostRecentRole;

ALTER TABLE employee 
ADD Bonus_Travel int ;

update Employee
set Bonus_Travel = case when BusinessTravel = 'Frequent Traveller' 
and DistanceFromHome_KM >= (select avg(DistanceFromHome_KM) from Employee)
then Salary * 0.2
else 0
end ;


ALTER TABLE employee 
ADD Bonus_Overtime int ;

update Employee
set Bonus_Overtime = 
Case 
when OverTime > 0
then  salary * 0.1
else 0
end ;

ALTER TABLE employee 
ADD FullName nvarchar(50) ;

update Employee 
set FullName = FirstName + ' ' + LastName


ALTER TABLE employee 
Drop column FirstName 


ALTER TABLE employee 
Drop column LastName 


ALTER TABLE employee 
Drop column StockOptionLevel

update employee 
set Salary = Salary + Bonus_Travel +Bonus_Overtime



create view EmployeessDetail as
select  
    e.EmployeeID,[FullName],[Gender],[Age],[BusinessTravel],[Department],
    [State],[EducationLevelID],[EducationField],[JobRole],[Salary],[HireDate],
    [Attrition],[YearsSinceLastPromotion],[Experience],[ReviewDate],[PerformanceID],
	[RatingID],[SatisfactionID],[SatisfactionLevel],[RatingLevel],[Bonus_Travel],[Bonus_Overtime],[Ethnicity]
from 
    Employee e
 left join 
    EducationLevel ed ON ed.EducationLevelID = e.Education
 left join 
    PerformanceRating pr ON e.EmployeeID = pr.EmployeeID
 left join 
    RatingLevel rl ON rl.RatingID = pr.SelfRating
 left join 
    SatisfiedLevel sl ON sl.SatisfactionID = pr.JobSatisfaction;

	SELECT * FROM EmployeessDetail;


	select count(employeeID) from PerformanceRating