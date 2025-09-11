# Import csv csv export 

1️⃣ Create the database

sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS,1433 -U sa -P YourStrongPasswordHere -Q "CREATE DATABASE o;"



2️⃣ Create the Employees table
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS,1433 -U sa -P YourStrongPasswordHere -d o -Q "CREATE TABLE Employees (EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50), LastName NVARCHAR(50), Department NVARCHAR(50), HireDate DATE);"


3️⃣ Insert some sample rows
sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS,1433 -U sa -P YourStrongPasswordHere -d o -Q "INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate) VALUES (1,'Alice','Smith','HR','2020-01-15'),(2,'Bob','Johnson','IT','2019-06-01'),(3,'Carol','Williams','Finance','2021-03-20'),(4,'David','Brown','IT','2018-11-11');"

4️⃣ Export data to CSV (no  script)
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o ^
-Q "SELECT * FROM Employees;" -s"," -W > employees.csv



CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    HireDate DATE
);



sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "CREATE TABLE Employees (EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50), LastName NVARCHAR(50), Department NVARCHAR(50), HireDate DATE);"


2️⃣ Import the CSV

There are two common ways:

🔹 Option A: Use bcp (best for CSV import)

bcp is designed for bulk loading:

bcp o.dbo.Employees in employees.csv -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -c -t"," -F 2


-c → character data

-t"," → comma as delimiter

-F 2 → start from row 2 (skips the header line)


sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "SELECT * FROM Employees;"

