Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [sec].[Mobile_saveData]
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
@AutoID bigint,
                                                                                                                                                                                                                                              
@expDate varchar(10),
                                                                                                                                                                                                                                        
@expCode char(3),
                                                                                                                                                                                                                                            
@amtType char(1),
                                                                                                                                                                                                                                            
@amount numeric(9,2),
                                                                                                                                                                                                                                        
@amountoutstanding numeric(9,2),
                                                                                                                                                                                                                             
@paymentDate varchar(10),
                                                                                                                                                                                                                                    
@voucherBillNumber varchar(100),
                                                                                                                                                                                                                             
@payMode varchar(20),
                                                                                                                                                                                                                                        
@payeeName varchar(30),
                                                                                                                                                                                                                                      
@payeeAddress varchar(250),
                                                                                                                                                                                                                                  
@sourceMoney varchar(200),
                                                                                                                                                                                                                                   
@remarks nvarchar(250)=null,
                                                                                                                                                                                                                                 
@evidenceFile varbinary(max)=null
                                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	begin try 
                                                                                                                                                                                                                                                  
		begin transaction	
                                                                                                                                                                                                                                         
		if not exists (Select 'x' from sec.candidateRegister where AutoID=@AutoID 
                                                                                                                                                                                 
					and expDate=convert(datetime, @expDate, 111) and expCode=@expCode)
                                                                                                                                                                                      
			Begin
                                                                                                                                                                                                                                                     
				Declare @candidatepanchayat char(10)
                                                                                                                                                                                                                     
				set @candidatepanchayat=(Select PANCHAYAT_CODE from sec.sec.CandidatePersonalInfo where AUTO_ID=@AutoID)
                                                                                                                                                 

                                                                                                                                                                                                                                                             
				insert into sec.candidateRegister (AutoID,expDate,expCode,amtType,amount,amountoutstanding,paymentDate,voucherBillNumber,
                                                                                                                                
				payMode,payeeName,payeeAddress,sourceMoney,remarks,DtTm, ExpStatus,PanchayatCode)
                                                                                                                                                                        
				values(@AutoID,convert(datetime, @expDate, 111), @expCode,@amtType,@amount,@amountoutstanding,convert(datetime, @paymentDate, 101),
                                                                                                                      
				@voucherBillNumber,@payMode,@payeeName,@payeeAddress,@sourceMoney,@remarks,GETDATE(),'P',@candidatepanchayat)
                                                                                                                                            
			
                                                                                                                                                                                                                                                          
				Declare @expenseid bigint;
                                                                                                                                                                                                                               
				set @expenseid = (Select top 1 ExpenseID from sec.candidateRegister order by DtTm desc)
                                                                                                                                                                  
			
                                                                                                                                                                                                                                                          
				if @evidenceFile is not null
                                                                                                                                                                                                                             
					begin
                                                                                                                                                                                                                                                   
						insert into sec.candidateExpenseEvidence (ExpenseID,evidenceFile,DtTm)
                                                                                                                                                                                 
						values (@expenseid,@evidenceFile,GETDATE())
                                                                                                                                                                                                            
					end
                                                                                                                                                                                                                                                     
				Select 200 statuscode,'Successfully Saved' Msg 
                                                                                                                                                                                                          
			end
                                                                                                                                                                                                                                                       
			
                                                                                                                                                                                                                                                          
		else
                                                                                                                                                                                                                                                       
			Begin
                                                                                                                                                                                                                                                     
				Select 300 statuscode,'Expenses for selected date and Expenditure type are already entered.' Msg 
                                                                                                                                                        
			End
                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
		commit
                                                                                                                                                                                                                                                     
	end try
                                                                                                                                                                                                                                                     
	begin catch
                                                                                                                                                                                                                                                 
		rollback
                                                                                                                                                                                                                                                   
		Select 400 statuscode, ERROR_MESSAGE() Msg
                                                                                                                                                                                                                 
	end catch
                                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
END
                                                                                                                                                                                                                                                          
