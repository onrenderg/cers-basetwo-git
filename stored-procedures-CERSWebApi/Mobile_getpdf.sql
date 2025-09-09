Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create procedure [sec].[Mobile_getpdf]
                                                                                                                                                                                                                       
@Expenseid bigint
                                                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           

                                                                                                                                                                                                                                                             
Begin
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
Select  evidenceFile from [sec].[candidateExpenseEvidence] where ExpenseID=@Expenseid
                                                                                                                                                                        
END
                                                                                                                                                                                                                                                          

                                                                                                                                                                                                                                                             
