Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
                                                                                                                                                                                                                                                           
exec [sec].[Mobile_getobserver_candidates] '1309998001'
                                                                                                                                                                                                      
exec [sec].[Mobile_getobserver_candidates] '1309998002'
                                                                                                                                                                                                      
*/
                                                                                                                                                                                                                                                           
 CREATE procedure [sec].[Mobile_getobserver_candidates]
                                                                                                                                                                                                      
  @PanchWardCode char(10)
                                                                                                                                                                                                                                    
  as
                                                                                                                                                                                                                                                         
  Begin
                                                                                                                                                                                                                                                      
 
                                                                                                                                                                                                                                                            
 Select i.AUTO_ID,i.VOTER_NAME, isnull(CONVERT(VARCHAR(50),SUM(c.amount)),'No Info.' )Amount from sec.sec.CandidatePersonalInfo i
                                                                                                                            
 left join secExpense.sec.candidateRegister c on c.AutoID=i.AUTO_ID and c.ExpStatus='F'
                                                                                                                                                                      
 where NOMINATION_STATUS='l' and CONSTITUENCY_CODE=@PanchWardCode
                                                                                                                                                                                            
 --CONSTITUENCY_CODE='1309001001'
                                                                                                                                                                                                                            
    --Select i.AUTO_ID, i.VOTER_NAME, SUM(c.amount)Amount from secExpense.sec.candidateRegister c
                                                                                                                                                            
    --left join sec.sec.CandidatePersonalInfo i on i.AUTO_ID= c.AutoID
                                                                                                                                                                                       
    --where PanchayatCode=@PanchWardCode
                                                                                                                                                                                                                     
    group by i.AUTO_ID,i.VOTER_NAME
                                                                                                                                                                                                                          
  End
                                                                                                                                                                                                                                                        
