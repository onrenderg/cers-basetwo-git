Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [sec].[Mobile_updatesaveData]
                                                                                                                                                                                                               
@ExpenseID bigint,
                                                                                                                                                                                                                                           
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
                                                                                                                                                                                                                                     
			update sec.candidateRegister set expDate=convert(datetime, @expDate, 111),expCode=@expCode,amtType=@amtType,amount=@amount,
                                                                                                                               
			amountoutstanding=@amountoutstanding,paymentDate=convert(datetime, @paymentDate, 101),voucherBillNumber=@voucherBillNumber,
                                                                                                                               
			payMode=@payMode,payeeName=@payeeName,payeeAddress=@payeeAddress,sourceMoney=@sourceMoney,remarks=@remarks, DtTm=GETDATE()
                                                                                                                                
			where ExpenseID=@ExpenseID		
                                                                                                                                                                                                                              
			
                                                                                                                                                                                                                                                          
			if @evidenceFile is not null
                                                                                                                                                                                                                              
					begin
                                                                                                                                                                                                                                                   
						update sec.candidateExpenseEvidence set evidenceFile =@evidenceFile, DtTm=GETDATE() where ExpenseID=@ExpenseID						
                                                                                                                                   
					end
                                                                                                                                                                                                                                                     
			Select 200 statuscode,'Successfully Updated' Msg 
                                                                                                                                                                                                         
		commit
                                                                                                                                                                                                                                                     
	end try
                                                                                                                                                                                                                                                     
	begin catch
                                                                                                                                                                                                                                                 
		rollback
                                                                                                                                                                                                                                                   
		Select 400 statuscode, ERROR_MESSAGE() Msg
                                                                                                                                                                                                                 
	end catch
                                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
END
                                                                                                                                                                                                                                                          
