Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
CREATE procedure [sec].[Mobile_updateobserverremarks]
                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
@ExpenseId bigint,
                                                                                                                                                                                                                                           
@ObserverRemarksId int,
                                                                                                                                                                                                                                      
@ObserverRemarks nvarchar(250)
                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	begin try 
                                                                                                                                                                                                                                                  
		begin transaction	
                                                                                                                                                                                                                                         
		
                                                                                                                                                                                                                                                           
			update secExpense.sec.OberverRemarks set ObserverRemarks=@ObserverRemarks, ObserverRemarksDtTm=getdate()			
                                                                                                                                               
			where ExpenseId=@ExpenseId and ObserverRemarksId=@ObserverRemarksId
                                                                                                                                                                                       
				
                                                                                                                                                                                                                                                         
			Select 200 statuscode,'Remarks Successfully Updated' Msg 
                                                                                                                                                                                                 
			
                                                                                                                                                                                                                                                          
			
                                                                                                                                                                                                                                                          
		
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
		commit
                                                                                                                                                                                                                                                     
	end try
                                                                                                                                                                                                                                                     
	begin catch
                                                                                                                                                                                                                                                 
		rollback
                                                                                                                                                                                                                                                   
		Select 400 statuscode, ERROR_MESSAGE() Msg
                                                                                                                                                                                                                 
	end catch
                                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
END
                                                                                                                                                                                                                                                          
