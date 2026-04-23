/*Data Analytics (DA) 
Module-End -3
Module End Assignment: 
“Analyzing E-Learning Platform Purchases using MySQL”*/


Create database Elearning_Platform;
Use Elearning_Platform;

/*Tasks
1. Create the database and schema. Populate the Schema:*/

Create table Learners(
       Learner_id INT PRIMARY KEY AUTO_INCREMENT,
       Full_Name VARCHAR(100),
       Country VARCHAR(100));
      
Insert into Learners (Full_Name,Country) values 
('Ananya Iyer','India'),
('Karthik Raj','India'),
('Michael Johnson','USA'),
('Sophia Wilson','UK'),
('Daniel Miller','Canada'),
('William Harris','USA'),
('Priya Nair','India'),
('Aarav Sharma','Canada'),
('Suresh Balaji', 'Singapore'),
('Ramesh Krishnan', 'Malaysia');     
       
       
      
Create table Courses(
       Course_id INT PRIMARY KEY AUTO_INCREMENT,     
       Course_Name VARCHAR(100), 
       Category VARCHAR(100),
       Unit_Price DECIMAL(10,2));
       
Insert into Courses(Course_Name,Category,Unit_Price) values 
('Rapid English','Language Learning',15000),
('Montessori Training','Teaching',25000),
('AI Data Analytics','Coding & Development',45000),
('Software Testing','Coding & Development',40000),
('Website Creation','Coding & Development',30000),
('Full Stack Development','Coding & Development',35000),
('Stock Market Basics','Finance',38000),
('Digital Marketing','Media',28000),  
('SAP Finance','Commerce',48000),
('HR Management','Resource',32500);

     
Create table Purchases(
       Purchase_id INT PRIMARY KEY AUTO_INCREMENT, 
       Learner_id INT,
       Course_id INT,
       Quantity INT,
       Purchase_Date DATE,
       FOREIGN KEY (Learner_id) REFERENCES  Learners(Learner_id),
       FOREIGN KEY (Course_id) REFERENCES  Courses(Course_id));
       
INSERT INTO Purchases (Learner_id, Course_id, Quantity, Purchase_Date) VALUES
(1, 3, 1, '2025-01-05'),
(1, 8, 1, '2025-01-07'),
(2, 4, 1, '2025-01-10'),
(2, 7, 1, '2025-01-12'),
(3, 5, 1, '2025-02-01'),
(3, 9, 1, '2025-03-10'),
(4, 6, 1, '2025-02-03'),
(4, 10, 1, '2025-03-12'),
(5, 8, 1, '2025-02-05'),
(6, 7, 1, '2025-02-07'),
(7, 1, 1, '2025-02-10'),
(8, 2, 1, '2025-02-12');
      
select * from Learners;
select * from Courses;
select * from Purchases;  

/*Tasks
2. Data Exploration Using Joins
		 Data Presentation Guidelines for the following query */

/*	Format currency values to 2 decimal places.*/

select course_name, FORMAT (unit_price, 2) as unit_price
from Courses;

/*	Use aliases for column names (e.g., AS total_revenue).*/

select course_name as Course_Name,unit_price as Total_Revenue
from Courses;

/*	Sort results appropriately (e.g., highest total_spent first).*/

select course_name,unit_price as Total_spent
from Courses
order by Total_spent desc;

/*Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
●	Combine learner, course, and purchase data.*/

select * from Purchases P
Inner Join learners L on L.learner_id=P.learner_id
Inner Join Courses C on C.course_id=P.course_id;

select * from learners L
Left Join Purchases P on L.learner_id=P.Learner_id
Left Join Courses C on P.course_id=C.Course_id;

select * from Courses C
Right Join Purchases P on P.course_id=C.Course_id
Right Join Learners L on P.learner_id=L.Learner_id;


/*	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).*/

select l.full_name,c.course_name,c.category,p.quantity,p.purchase_date,c.unit_price * p.quantity as Total_amount
from purchases p
Inner Join learners l on l.learner_id=p.learner_id
Inner Join courses c on c.course_id=p.course_id;

/* 3. Analytical Queries
		Write SQL queries to answer the following questions:*/
/*Q1. Display each learner’s total spending (quantity × unit_price) along with their country.*/

select l.full_name,l.country,sum(p.quantity * c.unit_price) as total_spending
from learners l
Inner Join purchases p on l.learner_id=p.learner_id
Inner Join courses c on c.course_id=p.course_id
group by l.full_name,l.country;


/*Q2. Find the top 3 most purchased courses based on total quantity sold.*/

select c.course_id,c.course_name,sum(p.quantity) as total_quantity_sold
from courses c
inner join purchases p on c.course_id=p.course_id
group by course_id
order by total_quantity_sold desc
limit 3;

/*Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.*/

select c.category,sum(p.quantity * c.unit_price) as Total_revenue,count(Distinct p.learner_id) as unique_learners
from purchases p
inner join courses c on c.course_id=p.course_id
group by c.category
order by Total_revenue desc;

/*Q4. List all learners who have purchased courses from more than one category.*/

select l.full_name,count(distinct c.category) as category_count
from learners l
inner join purchases p on l.learner_id=p.learner_id
inner join courses c on c.course_id=p.course_id
group by l.full_name
having count(distinct c.category) >1;

/*Q5. Identify courses that have not been purchased at all.*/

SELECT c.course_id,c.course_name
FROM Courses c
LEFT JOIN Purchases p on c.course_id = p.course_id
WHERE p.course_id IS NULL;