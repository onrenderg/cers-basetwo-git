Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
--  exec [sec].[Mobile_CERS_updateOTPresponse] '8219211012','dsadad','1234'
                                                                                                                                                                                  
CREATE PROCEDURE [sec].[Mobile_CERS_updateOTPresponse]
                                                                                                                                                                                                       
	@MobileNo char(10),
                                                                                                                                                                                                                                         
	@otpmessage varchar(200),
                                                                                                                                                                                                                                   
	@smsresponse varchar(250),
                                                                                                                                                                                                                                  
	@otpId int
                                                                                                                                                                                                                                                  

                                                                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
AS
                                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        

                                                                                                                                                                                                                                                             

                                                                                                                                                                                                                                                             
	
                                                                                                                                                                                                                                                            
	SET NOCOUNT ON;	
                                                                                                                                                                                                                                            
	begin
                                                                                                                                                                                                                                                       
		update [sec].[Mobile_CERS_Otp] set otpmessage=@otpmessage,smsresponse=@smsresponse where MobileNo =@MobileNo and OtpId=@OtpId
                                                                                                                              
		Select 200 statuscode, 'Successfully Updated' Msg
                                                                                                                                                                                                          
		
                                                                                                                                                                                                                                                           
	end
                                                                                                                                                                                                                                                         
	
                                                                                                                                                                                                                                                            
END
                                                                                                                                                                                                                                                          
