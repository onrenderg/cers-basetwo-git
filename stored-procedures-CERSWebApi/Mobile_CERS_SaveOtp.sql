Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Create PROCEDURE [sec].[Mobile_CERS_SaveOtp]
                                                                                                                                                                                                                 
	@MobileNo char(10),
                                                                                                                                                                                                                                         
	@Otppassword int,
                                                                                                                                                                                                                                           
	@otpId int
                                                                                                                                                                                                                                                  
AS
                                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        
Declare @message table ([Message] nvarchar(255),[Status] nvarchar(50));
                                                                                                                                                                                      
	
                                                                                                                                                                                                                                                            
	SET NOCOUNT ON;	
                                                                                                                                                                                                                                            
	begin
                                                                                                                                                                                                                                                       
		insert into [sec].[Mobile_CERS_Otp] values  (@MobileNo,@Otppassword,@OtpId,GETDATE())
                                                                                                                                                                      
		Select 200 statuscode, 'OTP Successfully Sent' Msg
                                                                                                                                                                                                         
	end
                                                                                                                                                                                                                                                         
	SELECT * from @message;	
                                                                                                                                                                                                                                    
END
                                                                                                                                                                                                                                                          
