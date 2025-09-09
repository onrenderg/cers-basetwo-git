Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
exec sec.Mobile_CERS_AppLogin '9816765215'
                                                                                                                                                                                                                   
exec sec.Mobile_CERS_AppLogin '8894132679'
                                                                                                                                                                                                                   
exec sec.Mobile_CERS_AppLogin '9816242185'
                                                                                                                                                                                                                   
exec sec.Mobile_CERS_AppLogin '9418487868'
                                                                                                                                                                                                                   
exec sec.Mobile_CERS_AppLogin '8219211012'
                                                                                                                                                                                                                   

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
*/
                                                                                                                                                                                                                                                           
CREATE procedure [sec].[Mobile_CERS_AppLogin]
                                                                                                                                                                                                                
@MobileNo char(10)
                                                                                                                                                                                                                                           
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and NOMINATION_FOR not in ('Z','W'))
                                                                                    
	Begin
                                                                                                                                                                                                                                                       
		Select 300 statuscode, 'Invalid Contestant' Msg
                                                                                                                                                                                                            
	end
                                                                                                                                                                                                                                                         
	--else if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and NOMINATION_STATUS not in ('E','W','R'))
                                                                      
	else if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and NOMINATION_STATUS <> 'l')
                                                                                      

                                                                                                                                                                                                                                                             
	Begin
                                                                                                                                                                                                                                                       
		Select 300 statuscode, 'Your Nomination is pending for listing as Legally Valid Contestant' Msg
                                                                                                                                                            
	end
                                                                                                                                                                                                                                                         
	else if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) )--and NOMINATION_STATUS  not in ('W','R'))
                                                                        
		Begin		
                                                                                                                                                                                                                                                    

                                                                                                                                                                                                                                                             
			Select 200 statuscode, 'Successfully Logged In' Msg
                                                                                                                                                                                                       
			Select distinct AUTO_ID,EPIC_NO,VOTER_NAME,RELATION_TYPE,RELATIVE_NAME,GENDER,AGE,EMAIL_ID,MOBILE_NUMBER, 
                                                                                                                                                
			AgentName,AgentMobile,--concat(P.Panchayat_Name , ' - ',b.Block_Name,', ' + d.District_Name) Panchayat_Name	,
                                                                                                                                             
			case when cast(SUBSTRING(p.panchayat_code,5,3) as int) = 999 then concat(ltrim(rtrim(P.Panchayat_Name)) ,', ', ltrim(rtrim(d.District_Name)))
                                                                                                             
				when cast(SUBSTRING(p.panchayat_code,5,3) as int) between 990 and 998 then concat(convert(varchar,cast(right(p.panchayat_code,3) as int)),'-',ltrim(rtrim(P.Panchayat_Name)),', ',ltrim(rtrim(b.Block_Name)),', ', ltrim(rtrim(d.District_Name)))
        
				else concat(ltrim(rtrim(P.Panchayat_Name)) , ' - ',ltrim(rtrim(b.Block_Name)),', ' + ltrim(rtrim(d.District_Name))) end Panchayat_Name	,
                                                                                                                 
			case @MobileNo when MOBILE_NUMBER then 'Self' when AgentMobile then 'Agent' else 'Not Known' end LoggedInAs,
                                                                                                                                              
			c.[Description] as NominationForName, c.Description_Local as NominationForNameLocal,			
                                                                                                                                                                   
			convert(varchar(10),(ep.PollDate),120)  PollDate,
                                                                                                                                                                                                         
			convert(varchar(10),u.NOMINATION_DATE,120)	NominationDate
                                                                                                                                                                                                 
			,c.Code as postcode, lm.LimitAmt,epo.PollPhase,
                                                                                                                                                                                                           
			convert(varchar(10),(case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                                         
			  else ep.ResultDate end
                                                                                                                                                                                                                                  
			),120)ResultDate,			
                                                                                                                                                                                                                                      
			convert(varchar(10),(DATEADD(DAY, 30, (case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                       
			  else ep.ResultDate end
                                                                                                                                                                                                                                  
			))),120)Resultdatethirtydays
                                                                                                                                                                                                                              
			, b.Block_Code,
                                                                                                                                                                                                                                           
			(case when  cast(right(b.Block_Code,3) as int) between 990 and 998 then 'MC Ward' 
                                                                                                                                                                        
			when cast(right(b.Block_Code,3) as int)=999 then 'Nagar Panchayat' else 'Panchayat' end) as panwardcouncilname
                                                                                                                                            
			,(case when  cast(right(b.Block_Code,3) as int) between 990 and 998 then N'??.??. ?????' 
                                                                                                                                                                 
			when cast(right(b.Block_Code,3) as int)=999 then N'??? ??????' else N'??????' end) as panwardcouncilnamelocal
                                                                                                                                             
			,isnull(cr.ExpStatus,'N')ExpStatus
                                                                                                                                                                                                                        
			, convert(date,NOMINATION_DATE ) expStartDate
                                                                                                                                                                                                             
			,case NOMINATION_STATUS when 'W' then convert(date,WITHDRAWAL_DT_TM) when 'R' then convert(date,SCRUTINY_DT_TM) else 
                                                                                                                                     
			case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)  else ep.ResultDate end
                                                                                                                                                      
			end expEndDate
                                                                                                                                                                                                                                            
			FROM sec.sec.CandidatePersonalInfo u(nolock)
                                                                                                                                                                                                              
			left join sec.sec.Panchayats P(nolock) on P.Panchayat_Code=u.CONSTITUENCY_CODE
                                                                                                                                                                            
			left join sec.sec.Blocks B(nolock) on B.Block_Code= p.Block_Code
                                                                                                                                                                                          
			left join sec.sec.Districts d(nolock) on d.District_Code = p.District_Code
                                                                                                                                                                                
			left join sec.sec.commonmaster c(nolock) on c.Category='NOMINATIONTYPE' and c.Abbr=u.NOMINATION_FOR
                                                                                                                                                       
			left join sec.sec.ElectionMaster ep(nolock) on u.electionID =ep.ElectionID
                                                                                                                                                                                
			left join sec.sec.ElectionPolls epo(nolock) on epo.ElectionID=ep.ElectionID and epo.PollDate=ep.PollDate and epo.PollPhase=ep.PollPhase
                                                                                                                   
														and 'Y'= case u.NOMINATION_FOR when 'Z' then ZpPoll when 'W' then WPoll when 'S' then pspoll end
                                                                                                                                               
			left join secExpense.sec.expenseLimitMaster lm (nolock) on lm.PostCode = c.Code 
                                                                                                                                                                          
			left join secExpense.sec.candidateRegister cr on cr.AutoID=u.AUTO_ID
                                                                                                                                                                                      
			where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and epo.PollPhase is not null --and NOMINATION_STATUS not in ('W','R')
                                                                                                                           
			--AND U.ElectionId =(SELECT MAX(ElectionID) from sec.sec.CandidatePersonalInfo ca (nolock) where ca.CONSTITUENCY_CODE=u.CONSTITUENCY_CODE and ca.CONSTITUENCY_WARD=u.CONSTITUENCY_WARD and ca.NOMINATION_FOR=u.NOMINATION_FOR) 
                           

                                                                                                                                                                                                                                                             
		END
                                                                                                                                                                                                                                                        
	else if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo_arc with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) ) -- archived election data
                                                                                    
	--else if exists(Select Top 1 'x' from sec.sec.CandidatePersonalInfo_arc with(nolock) where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and NOMINATION_STATUS not in ('W','R')) -- archived election data
                                            
		Begin
                                                                                                                                                                                                                                                      
			Select 300 statuscode, 'Invalid Record' Msg
                                                                                                                                                                                                               
			Select distinct AUTO_ID,EPIC_NO,VOTER_NAME,RELATION_TYPE,RELATIVE_NAME,GENDER,AGE,EMAIL_ID,MOBILE_NUMBER, 
                                                                                                                                                
			AgentName,AgentMobile,--concat(P.Panchayat_Name , ' - ',b.Block_Name,', ' + d.District_Name) Panchayat_Name	,
                                                                                                                                             
			case when cast(SUBSTRING(p.panchayat_code,5,3) as int) = 999 then concat(ltrim(rtrim(P.Panchayat_Name)) ,', ', ltrim(rtrim(d.District_Name)))
                                                                                                             
				when cast(SUBSTRING(p.panchayat_code,5,3) as int) between 990 and 998 then concat(convert(varchar,cast(right(p.panchayat_code,3) as int)),'-',ltrim(rtrim(P.Panchayat_Name)),', ',ltrim(rtrim(b.Block_Name)),', ', ltrim(rtrim(d.District_Name)))
        
				else concat(ltrim(rtrim(P.Panchayat_Name)) , ' - ',ltrim(rtrim(b.Block_Name)),', ' + ltrim(rtrim(d.District_Name))) end Panchayat_Name	,
                                                                                                                 
			case @MobileNo when MOBILE_NUMBER then 'Self' when AgentMobile then 'Agent' else 'Not Known' end LoggedInAs,
                                                                                                                                              
			c.[Description] as NominationForName, c.Description_Local as NominationForNameLocal,			
                                                                                                                                                                   
			convert(varchar(10),ep.PollDate,120)  PollDate,
                                                                                                                                                                                                           
			convert(varchar(10),NOMINATION_DATE,120)	NominationDate
                                                                                                                                                                                                   
			,c.Code as postcode, lm.LimitAmt,epo.PollPhase,
                                                                                                                                                                                                           
			convert(varchar(10),(case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                                         
			  else ep.ResultDate end
                                                                                                                                                                                                                                  
			),120)ResultDate,			
                                                                                                                                                                                                                                      
			convert(varchar(10),(DATEADD(DAY, 30, (case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                       
			  else ep.ResultDate end
                                                                                                                                                                                                                                  
			))),120)Resultdatethirtydays
                                                                                                                                                                                                                              
			, b.Block_Code,
                                                                                                                                                                                                                                           
			(case when  cast(right(b.Block_Code,3) as int) between 990 and 998 then 'MC Ward' 
                                                                                                                                                                        
			when cast(right(b.Block_Code,3) as int)=999 then 'Nagar Panchayat' else 'Panchayat' end) as panwardcouncilname
                                                                                                                                            
			,(case when  cast(right(b.Block_Code,3) as int) between 990 and 998 then N'??.??. ?????' 
                                                                                                                                                                 
			when cast(right(b.Block_Code,3) as int)=999 then N'??? ??????' else N'??????' end) as panwardcouncilnamelocal
                                                                                                                                             
			,isnull(cr.ExpStatus,'N')ExpStatus
                                                                                                                                                                                                                        
			, convert(date,NOMINATION_DATE ) expStartDate
                                                                                                                                                                                                             
			,case NOMINATION_STATUS when 'W' then convert(date,WITHDRAWAL_DT_TM) when 'R' then convert(date,SCRUTINY_DT_TM) else 
                                                                                                                                     
			case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                                                              
			  else ep.ResultDate end
                                                                                                                                                                                                                                  
			end expEndDate
                                                                                                                                                                                                                                            

                                                                                                                                                                                                                                                             
			FROM sec.sec.CandidatePersonalInfo_arc u (nolock)
                                                                                                                                                                                                         
			left join sec.sec.Panchayats P(nolock) on P.Panchayat_Code=u.PANCHAYAT_CODE
                                                                                                                                                                               
			left join sec.sec.Blocks B(nolock) on B.Block_Code= p.Block_Code
                                                                                                                                                                                          
			left join sec.sec.Districts d(nolock) on d.District_Code = p.District_Code
                                                                                                                                                                                
			left join sec.sec.commonmaster c(nolock) on c.Category='NOMINATIONTYPE' and c.Abbr=u.NOMINATION_FOR
                                                                                                                                                       
			left join sec.sec.ElectionMaster ep(nolock) on u.electionID =ep.ElectionID
                                                                                                                                                                                
			left join sec.sec.ElectionPolls epo(nolock) on u.CONSTITUENCY_CODE=epo.PanchayatCode and epo.ElectionID=ep.ElectionID and epo.PollDate=ep.PollDate and epo.PollPhase=ep.PollPhase
                                                                         
			left join secExpense.sec.expenseLimitMaster lm (nolock) on lm.PostCode = c.Code 
                                                                                                                                                                          
			left join secExpense.sec.candidateRegister cr on cr.AutoID=u.AUTO_ID
                                                                                                                                                                                      
			where (MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo) and epo.PollPhase is not null --and NOMINATION_STATUS not in ('W','R')
                                                                                                                           
			--and u.ElectionId =(select max(electionId) from sec.sec.CandidatePersonalInfo u1(nolock) where (u1.MOBILE_NUMBER=u.MOBILE_NUMBER or u1.AgentMobile=u.AgentMobile))
                                                                                       
			AND U.ElectionId =(SELECT MAX(ElectionID) from sec.sec.CandidatePersonalInfo_ARC ca (nolock) where ca.CONSTITUENCY_CODE=u.CONSTITUENCY_CODE and ca.CONSTITUENCY_WARD=u.CONSTITUENCY_WARD and ca.NOMINATION_FOR=u.NOMINATION_FOR) 
                         
			-- fetch results for latest election only
                                                                                                                                                                                                                 
			
                                                                                                                                                                                                                                                          
		END
                                                                                                                                                                                                                                                        
	else 
                                                                                                                                                                                                                                                       
		Begin			
                                                                                                                                                                                                                                                   
			Select 300 statuscode, 'Invalid Login' Msg
                                                                                                                                                                                                                
		END
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
End
                                                                                                                                                                                                                                                          
