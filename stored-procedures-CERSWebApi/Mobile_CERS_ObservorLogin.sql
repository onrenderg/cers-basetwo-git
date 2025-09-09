Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
                                                                                                                                                                                                                                                           
exec sec.Mobile_CERS_ObservorLogin '9418011750'
                                                                                                                                                                                                              
exec sec.Mobile_CERS_ObservorLogin '9418485131'
                                                                                                                                                                                                              
exec sec.Mobile_CERS_ObservorLogin '9882380628'
                                                                                                                                                                                                              
*/
                                                                                                                                                                                                                                                           
CREATE procedure [sec].[Mobile_CERS_ObservorLogin]
                                                                                                                                                                                                           
@MobileNo char(10)
                                                                                                                                                                                                                                           
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	if exists(Select 'x' from secExpense.sec.ObserverInfo where ObserverContact=@MobileNo)
                                                                                                                                                                      
		Begin
                                                                                                                                                                                                                                                      
			Select 200 statuscode, 'Successfully Logged In' Msg
                                                                                                                                                                                                       
			Select Auto_ID, ObserverName,ObserverContact,ObserverDesignation,Pritype
                                                                                                                                                                                  
			FROM secExpense.sec.ObserverInfo u
                                                                                                                                                                                                                        
					
                                                                                                                                                                                                                                                        
			where   ObserverContact=@MobileNo 
                                                                                                                                                                                                                        
			
                                                                                                                                                                                                                                                          
		END
                                                                                                                                                                                                                                                        
	
                                                                                                                                                                                                                                                            
	else 
                                                                                                                                                                                                                                                       
		Begin			
                                                                                                                                                                                                                                                   
			Select 300 statuscode, 'Invalid Credentials' Msg
                                                                                                                                                                                                          
		END
                                                                                                                                                                                                                                                        
End
                                                                                                                                                                                                                                                          
