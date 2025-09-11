1️⃣ Create the database

sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -Q "DROP  DATABASE o;"

sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -Q "CREATE DATABASE o;"


2️⃣ Create the Employees table
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "CREATE TABLE Employees (EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50), LastName NVARCHAR(50), Department NVARCHAR(50), HireDate DATE);"

3️⃣ Insert sample data
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate) VALUES (1,'Alice','Smith','HR','2020-01-15'),(2,'Bob','Johnson','IT','2019-06-01'),(3,'Carol','Williams','Finance','2021-03-20'),(4,'David','Brown','IT','2018-11-11');"

4️⃣ Export to CSV
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "SET NOCOUNT ON; SELECT * FROM Employees;" -s"," -W > C:\Users\Parth\Desktop\employees.csv





5️⃣ Drop and recreate table
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "DROP TABLE Employees;"

sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "CREATE TABLE Employees (EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50), LastName NVARCHAR(50), Department NVARCHAR(50), HireDate DATE);"

6️⃣ Import CSV back (using bcp)
bcp o.dbo.Employees in "C:\Users\Parth\Desktop\employees.csv" -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -c -t"," -F 2

7️⃣ Verify
sqlcmd -S "ROYAL-NIC-6F\SQLEXPRESS,1433" -U sa -P "YourStrongPasswordHere" -d o -Q "SELECT * FROM Employees;"


⚡ This is the single-line version of each step.
Do you want me to compress this into one .bat file where all steps run sequentially (create → insert → export → drop → import → verify)?