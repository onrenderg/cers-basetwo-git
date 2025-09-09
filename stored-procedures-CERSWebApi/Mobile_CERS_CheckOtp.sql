Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create PROCEDURE [sec].[Mobile_CERS_CheckOtp]
                                                                                                                                                                                                                
	@MobileNo char(10),
                                                                                                                                                                                                                                         
	@userotp int,
                                                                                                                                                                                                                                               
	@otpId int
                                                                                                                                                                                                                                                  
AS
                                                                                                                                                                                                                                                           
BEGIN	
                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                             
		if exists(SELECT 'x' from [sec].[Mobile_CERS_Otp] where [MobileNo]=@MobileNo and OtpPassword=@userotp and  OtpId=@otpId)			
                                                                                                                                
			begin
                                                                                                                                                                                                                                                     
				SELECT 'OTP Successfully Matched' Msg,200 statuscode
                                                                                                                                                                                                     
	
                                                                                                                                                                                                                                                            
		end
                                                                                                                                                                                                                                                        
		else
                                                                                                                                                                                                                                                       
			select  'OTP Does not Match' Msg,300 statuscode
                                                                                                                                                                                                           
	
                                                                                                                                                                                                                                                            
END
                                                                                                                                                                                                                                                          
