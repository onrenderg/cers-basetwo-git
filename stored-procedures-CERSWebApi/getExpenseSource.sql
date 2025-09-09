Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [sec].[getExpenseSource]
                                                                                                                                                                                                                    
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
SELECT  [Exp_code]
                                                                                                                                                                                                                                           
      , CONCAT(CAST (Exp_code as int),'. ' ,Exp_Desc)Exp_Desc
                                                                                                                                                                                                
	   , CONCAT(CAST (Exp_code as int),'. ' ,Exp_Desc_Local)Exp_Desc_Local
                                                                                                                                                                                      
      --,[Exp_Desc_Local]
                                                                                                                                                                                                                                    
  FROM [secExpense].[sec].[expenseSourceMaster]
                                                                                                                                                                                                              
  End
                                                                                                                                                                                                                                                        
