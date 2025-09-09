Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--  [sec].[Mobile_finalsaveDataNov23] 344431
                                                                                                                                                                                                                 
create procedure [sec].[Mobile_finalsaveDataNov23]
                                                                                                                                                                                                           
@AutoID bigint
                                                                                                                                                                                                                                               

                                                                                                                                                                                                                                                             
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	begin try
                                                                                                                                                                                                                                                   
		begin transaction	
                                                                                                                                                                                                                                         
		declare @pollDate date
                                                                                                                                                                                                                                     
		select @pollDate=PollDate 
                                                                                                                                                                                                                                 
		From sec.sec.electionmaster (nolock) where ElectionID = ( select max(electionid) from sec.sec.CandidatePersonalInfo  (nolock) where AUTO_ID=@AutoID )
                                                                                                      
		print @pollDate 
                                                                                                                                                                                                                                           
		
                                                                                                                                                                                                                                                           
		if convert(date, GETDATE()) >= @pollDate
                                                                                                                                                                                                                   
		begin
                                                                                                                                                                                                                                                      
			--update sec.candidateRegister set ExpStatus='F', DtTm=GETDATE()	where AutoID=@AutoID	
                                                                                                                                                                    
			Select 200 statuscode,'Successfully Submitted' Msg 
                                                                                                                                                                                                       
		end
                                                                                                                                                                                                                                                        
		else 
                                                                                                                                                                                                                                                      
			select 400 statuscode,'Final Submit is allowed after Poll Date' Msg			
                                                                                                                                                                                    
		commit
                                                                                                                                                                                                                                                     
	end try
                                                                                                                                                                                                                                                     
	begin catch
                                                                                                                                                                                                                                                 
		rollback
                                                                                                                                                                                                                                                   
		Select 400 statuscode, ERROR_MESSAGE() Msg
                                                                                                                                                                                                                 
	end catch
                                                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             
END                                                                                                                                                                                                                                                            
