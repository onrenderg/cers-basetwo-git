Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create procedure [sec].[Mobile_getPaymentModes]
                                                                                                                                                                                                              
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
	Select paymode_code,paymode_Desc,paymode_Desc_Local from [sec].[paymentmodeMaster]
                                                                                                                                                                          
End
                                                                                                                                                                                                                                                          
