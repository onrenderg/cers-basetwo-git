import base64
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad

def decrypt_aes(encrypted_text):
    key = "CERS&NicHP@23@ece".encode('utf-8')
    
    # Match C# implementation: truncate/pad to 16 bytes
    keyBytes = bytearray(16)
    for i in range(min(16, len(key))):
        keyBytes[i] = key[i]
    
    try:
        # Decode base64
        encrypted_bytes = base64.b64decode(encrypted_text)
        
        # Use same key as IV (matching C# implementation)
        cipher = AES.new(bytes(keyBytes), AES.MODE_CBC, bytes(keyBytes))
        decrypted = cipher.decrypt(encrypted_bytes)
        result = unpad(decrypted, AES.block_size).decode('utf-8')
        return result
        
    except Exception as e:
        return f"Error: {e}"

import urllib.parse

# Get encrypted OTPID from user input
encrypted_input = input("Enter encrypted OTPID (Base64 or URL-encoded): ").strip()

# Check if input looks like valid Base64 or URL-encoded
def is_valid_base64(s):
    try:
        import base64
        base64.b64decode(s)
        return True
    except:
        return False

# Check if it's numeric (mobile number)
if encrypted_input.isdigit():
    print(f"Error: '{encrypted_input}' appears to be a mobile number, not an encrypted OTPID.")
    print("Please enter the Base64 encrypted OTPID from the API response (e.g., 'Bb41PVKSOg0yEIW/WQpL3w==')")
    exit()

# Check if it's URL-encoded (contains % characters)
if '%' in encrypted_input:
    decoded_input = urllib.parse.unquote(encrypted_input)
    print(f"URL-encoded input: {encrypted_input}")
    print(f"URL-decoded: {decoded_input}")
    encrypted_otpid = decoded_input
else:
    print(f"Base64 input: {encrypted_input}")
    encrypted_otpid = encrypted_input

# Validate it's proper Base64
if not is_valid_base64(encrypted_otpid):
    print(f"Error: '{encrypted_otpid}' is not valid Base64.")
    print("Please enter a valid encrypted OTPID from the API response.")
    exit()

# Decrypt the OTPID
decrypted_otpid = decrypt_aes(encrypted_otpid)
print(f"Decrypted OTPID: {decrypted_otpid}")
