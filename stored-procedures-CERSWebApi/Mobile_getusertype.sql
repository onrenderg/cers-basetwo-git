Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
/*
                                                                                                                                                                                                                                                           
exec sec.Mobile_getusertype '9857890102'
                                                                                                                                                                                                                     
exec sec.Mobile_getusertype '9418011750'
                                                                                                                                                                                                                     
exec sec.Mobile_getusertype '9418948889'
                                                                                                                                                                                                                     
exec sec.Mobile_getusertype '9418548889'
                                                                                                                                                                                                                     

                                                                                                                                                                                                                                                             
*/
                                                                                                                                                                                                                                                           
CREATE procedure [sec].[Mobile_getusertype]
                                                                                                                                                                                                                  
@MobileNo char(10)
                                                                                                                                                                                                                                           
as
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Begin
                                                                                                                                                                                                                                                        
	if exists(Select 'x' from sec.sec.CandidatePersonalInfo where   MOBILE_NUMBER=@MobileNo) or (exists(Select 'x' from sec.sec.CandidatePersonalInfo_arc where   MOBILE_NUMBER=@MobileNo))
                                                                     
			begin
                                                                                                                                                                                                                                                     
				Select 200 statuscode,'Candidate' UserType
                                                                                                                                                                                                               
			END	
                                                                                                                                                                                                                                                      
		else if exists(Select 'x' from sec.sec.CandidatePersonalInfo where   AgentMobile=@MobileNo) or exists(Select 'x' from sec.sec.CandidatePersonalInfo_ARC where   AgentMobile=@MobileNo)
                                                                     
			begin
                                                                                                                                                                                                                                                     
				Select 200 statuscode,'Agent' UserType
                                                                                                                                                                                                                   
			END	
                                                                                                                                                                                                                                                      
		else if exists(Select 'x' from secExpense.sec.ObserverInfo where ObserverContact=@MobileNo)
                                                                                                                                                                
			Begin
                                                                                                                                                                                                                                                     
				Select 200 statuscode,'Observor' UserType
                                                                                                                                                                                                                
			END
                                                                                                                                                                                                                                                       
		else
                                                                                                                                                                                                                                                       
			Begin
                                                                                                                                                                                                                                                     
				Select 300 statuscode,'Invalid User' UserType
                                                                                                                                                                                                            
			END
                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
END
                                                                                                                                                                                                                                                          
