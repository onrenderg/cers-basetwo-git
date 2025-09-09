Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
                                                                                                                                                                                                                                                           
exec sec.Mobile_getpdfdecdata '9418487868'
                                                                                                                                                                                                                   
exec sec.Mobile_getpdfdecdata '8219211012'
                                                                                                                                                                                                                   
*/
                                                                                                                                                                                                                                                           
CREATE procedure [sec].[Mobile_getpdfdecdata]
                                                                                                                                                                                                                
@MobileNo char(10)
                                                                                                                                                                                                                                           
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
if exists(Select 'x' from sec.sec.CandidatePersonalInfo where MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo and  NOMINATION_STATUS='l')
                                                                                                                   
begin
                                                                                                                                                                                                                                                        
Select distinct VOTER_NAME,c1.[Description]RELATION_TYPE,RELATIVE_NAME,c2.[Description]GENDER,AGE,HOUSE_NO,Panchayat_Name,
                                                                                                                                   
    convert(varchar(10),(case epo.PollPhase when 5 then convert(date,ep.PollingDate5) 
                                                                                                                                                                       
                when 4 then convert(date,ep.PollingDate4) 
                                                                                                                                                                                                   
                when 3 then convert(date,ep.PollingDate3) 
                                                                                                                                                                                                   
                when 2 then convert(date,ep.PollingDate2) 
                                                                                                                                                                                                   
                else convert(date,ep.PollingDate1) end),120)  PollDate,
                                                                                                                                                                                      
            convert(varchar(10),NominationDate,103) NominationDate,
                                                                                                                                                                                          
    convert(varchar(10),(case when u.NOMINATION_FOR in ('Z','S') then convert(date,ep.ZpPsResultDate)
                                                                                                                                                        
              else case epo.PollPhase when 5 then convert(date,ep.ResultDate5) 
                                                                                                                                                                              
                    when 4 then convert(date,ep.ResultDate4) 
                                                                                                                                                                                                
                    when 3 then convert(date,ep.ResultDate3) 
                                                                                                                                                                                                
                    when 2 then convert(date,ep.ResultDate2) 
                                                                                                                                                                                                
                    else convert(date,ep.ResultDate1) end end
                                                                                                                                                                                                
            ),103)ResultDate,
                                                                                                                                                                                                                                
            Concat( DAY(getdate()),' ',DateName( MONTH,GETDATE())) as datemonth, YEAR(GETDATE()) as yr,
                                                                                                                                                      
            MOBILE_NUMBER,AgentMobile
                                                                                                                                                                                                                        
FROM sec.sec.CandidatePersonalInfo u
                                                                                                                                                                                                                         
            left join sec.sec.Panchayats P on P.Panchayat_Code=u.PANCHAYAT_CODE
                                                                                                                                                                              
            left join sec.sec.commonmaster c on c.Category='NOMINATIONTYPE' and c.Abbr=u.NOMINATION_FOR
                                                                                                                                                      
            left join sec.sec.commonmaster c1 on c1.Category='RELATION' and c1.Abbr=u.RELATION_TYPE
                                                                                                                                                          
            left join sec.sec.commonmaster c2 on c2.Category='GENDER' and c2.Abbr=u.GENDER
                                                                                                                                                                   
            left join sec.sec.ElectionProgramMaster ep on u.electionID =ep.ElectionID
                                                                                                                                                                        
            left join sec.sec.ElectionPolls epo on u.CONSTITUENCY_CODE=epo.PanchayatCode 
                                                                                                                                                                    
            left join secExpense.sec.expenseLimitMaster lm on lm.PostCode = c.Code 
                                                                                                                                                                          
            
                                                                                                                                                                                                                                                 
            where NOMINATION_STATUS='l' and MOBILE_NUMBER=@MobileNo or AgentMobile=@MobileNo
                                                                                                                                                                 
END     
                                                                                                                                                                                                                                                     
END
                                                                                                                                                                                                                                                          
