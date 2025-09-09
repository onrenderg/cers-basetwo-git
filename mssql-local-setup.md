Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;

sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -E


ip: ROYAL-NIC-6F\SQLEXPRESS  : pcname\instancename

✅ Step 3: Enable the sa Account and Set a Password

Back in sqlcmd, execute:

ALTER LOGIN sa ENABLE;
GO
ALTER LOGIN sa WITH PASSWORD = 'YourStrongPasswordHere';
GO


Replace 'YourStrongPasswordHere' with a strong password (SQL Server enforces strong password policies by default).




✅ Step 4: Test sa Login

Now you can test sqlcmd using SQL Authentication:

sqlcmd -S ROYAL-NIC-6F\SQLEXPRESS -U sa -P YourStrongPasswordHere
