Text                                                                                                                                                                                                                                                           
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                                                                                                                                                                                             
--  exec [sec].[Mobile_CERS_SaveOtp_New] '8219211012','123456','1234'
                                                                                                                                                                                        
CREATE  PROCEDURE [sec].[Mobile_CERS_SaveOtp_New]
                                                                                                                                                                                                            
	@MobileNo char(10),
                                                                                                                                                                                                                                         
	@Otppassword int,
                                                                                                                                                                                                                                           
	@otpId int,
                                                                                                                                                                                                                                                 
	@status_code int = 0 OUTPUT,
                                                                                                                                                                                                                                
	@status_message varchar(200) = '' output
                                                                                                                                                                                                                    
AS
                                                                                                                                                                                                                                                           
BEGIN
                                                                                                                                                                                                                                                        
		BEGIN
                                                                                                                                                                                                                                                      
		 DECLARE @requestCount INT;
                                                                                                                                                                                                                                
		 Declare  @message Table (msg varchar(200), statuscode int, nooftimes int); 
                                                                                                                                                                               
				SELECT @requestCount =  COUNT(*) FROM [sec].[Mobile_CERS_Otp]  
                                                                                                                                                                                          
				WHERE MobileNo = @MobileNo
                                                                                                                                                                                                                               
				AND OTPDateTime >= (DATEADD(MINUTE, -3, GETDATE()))
                                                                                                                                                                                                      
				AND CAST(OTPDateTime AS DATE) = CAST(GETDATE() AS DATE);
                                                                                                                                                                                                 
			-- Set the output based on the count
                                                                                                                                                                                                                      

                                                                                                                                                                                                                                                             
				DECLARE @requestTime DATETIME;
                                                                                                                                                                                                                           
				SET @requestTime = GETDATE(); -- Capture the current request time
                                                                                                                                                                                        

                                                                                                                                                                                                                                                             
				-- Get the last request time for the mobile number
                                                                                                                                                                                                       
				DECLARE @lastRequestTime DATETIME;
                                                                                                                                                                                                                       
				SELECT @lastRequestTime = MAX(OTPDateTime)
                                                                                                                                                                                                               
				FROM [sec].[Mobile_CERS_Otp]
                                                                                                                                                                                                                             
				WHERE MobileNo = @MobileNo;
                                                                                                                                                                                                                              

                                                                                                                                                                                                                                                             
				-- Check if a new request is being made within 1 minute of the last request
                                                                                                                                                                              
				IF @lastRequestTime IS NOT NULL AND DATEDIFF(MINUTE, @lastRequestTime, @requestTime) < 1
                                                                                                                                                                 
						BEGIN
                                                                                                                                                                                                                                                  
							INSERT INTO @message VALUES ('Not authorized to request OTP again within 1 minute.', 401, @requestCount);						
                                                                                                                                       
						END
                                                                                                                                                                                                                                                    
				else IF @requestCount >= 3
                                                                                                                                                                                                                               
					BEGIN
                                                                                                                                                                                                                                                   
						insert into @message VALUES('You have exceeded the OTP request limit. Kindly try after 3 minutes.',300, @requestCount);
                                                                                                                                
					END
                                                                                                                                                                                                                                                     
				else
                                                                                                                                                                                                                                                     
					begin
                                                                                                                                                                                                                                                   
						insert into [sec].[Mobile_CERS_Otp] values  (@MobileNo,@Otppassword,@OtpId,GETDATE(),'','')
                                                                                                                                                            
						insert into @message VALUES('OTP Successfully Sent',200, @requestCount);
                                                                                                                                                                               
					end
                                                                                                                                                                                                                                                     
			select @status_code = isnull(statuscode,200), @status_message = isnull(msg,'OK') from @message;
                                                                                                                                                           
			-- select @status_code, @status_message;
                                                                                                                                                                                                                  
	END
                                                                                                                                                                                                                                                         
END
                                                                                                                                                                                                                                                          
