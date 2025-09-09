Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- exec [sec].[Mobile_getsaveData] 322585
                                                                                                                                                                                                                    
-- exec [sec].[Mobile_getsaveData] 340459
                                                                                                                                                                                                                    
-- exec [sec].[Mobile_getsaveData] 343908
                                                                                                                                                                                                                    
CREATE procedure [sec].[Mobile_getsaveData]
                                                                                                                                                                                                                  
@AutoID bigint
                                                                                                                                                                                                                                               
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	Select  c.ExpenseID,AutoID,convert(varchar(10),expDate,120)expDate,convert(varchar(10),expDate,103)expDateDisplay,expCode,amtType
                                                                                                                           
	,cast(amount as bigint)amount,convert(varchar(10),paymentDate,120)paymentDate,convert(varchar(10),paymentDate,103)paymentDateDisplay
                                                                                                                        
	,voucherBillNumber,payMode,payeeName,payeeAddress
                                                                                                                                                                                                           
	,sourceMoney,remarks
                                                                                                                                                                                                                                        
	--CONVERT(varchar,c.DtTm,20)DtTm,	
                                                                                                                                                                                                                          
	,(convert(varchar(10),c.DtTm,103)+' '+FORMAT(CAST(c.DtTm AS datetime), 'hh:mm tt'))DtTm
                                                                                                                                                                     
	,ExpStatus,ltrim(rtrim(s.Exp_Desc)) as ExpTypeName,ltrim(rtrim(s.Exp_Desc_Local)) as ExpTypeNameLocal
                                                                                                                                                       
	,ltrim(rtrim(m.paymode_Desc)) as PayModeName, ltrim(rtrim(m.paymode_Desc_Local)) as PayModeNameLocal
                                                                                                                                                        
	,(case when e.evidenceFile IS not null then 'Y' else 'F' end)evidenceFile,cast(amountoutstanding as bigint)amountoutstanding
                                                                                                                                
	,o.ObserverRemarks
                                                                                                                                                                                                                                          
	from sec.candidateRegister c
                                                                                                                                                                                                                                
	left join sec.expenseSourceMaster s on s.Exp_code=c.expCode
                                                                                                                                                                                                 
	left join sec.paymentmodeMaster m on m.paymode_code=c.payMode
                                                                                                                                                                                               
	left join sec.candidateExpenseEvidence e on e.ExpenseID=c.ExpenseID
                                                                                                                                                                                         
	left join sec.OberverRemarks o on o.ExpenseId=c.ExpenseID and o.ObserverRemarksId=1
                                                                                                                                                                         
	where AutoID=@AutoID
                                                                                                                                                                                                                                        
	order by c.DtTm desc
                                                                                                                                                                                                                                        
END
                                                                                                                                                                                                                                                          
