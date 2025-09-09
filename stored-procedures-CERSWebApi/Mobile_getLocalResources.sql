Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE procedure [sec].[Mobile_getLocalResources]
                                                                                                                                                                                                            
as
                                                                                                                                                                                                                                                           
Begin
                                                                                                                                                                                                                                                        
Select MultipleResourceKey,ResourceKey,ResourceValue,LocalResourceValue from sec.Mobile_LocalResource
                                                                                                                                                        
End
                                                                                                                                                                                                                                                          
