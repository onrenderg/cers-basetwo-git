import sys
import urllib.parse
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
import base64

def generate_aes128_key_iv():
    """
    Generate AES-128 key and IV matching CERS mobile app AESCryptography implementation
    """
    # Key from CERS mobile app (same as EncKey preference)
    key_string = "CERS&NicHP@23@ece"
    
    # Take first 16 bytes for 128-bit key (matches C# implementation)
    key_bytes = key_string.encode('utf-8')[:16]
    
    # Use same key as IV (matches C# AESCryptography implementation)
    iv_bytes = key_bytes
    
    return key_bytes, iv_bytes

def encrypt_aes128_cbc(plaintext, key, iv):
    """
    Encrypt using AES-128-CBC matching CERS mobile app AESCryptography implementation
    """
    # Convert to UTF-8 (matches C# Encoding.UTF8)
    plaintext_bytes = plaintext.encode('utf-8')
    
    # Add PKCS7 padding
    padder = padding.PKCS7(128).padder()
    padded_data = padder.update(plaintext_bytes)
    padded_data += padder.finalize()
    
    # Encrypt
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
    encryptor = cipher.encryptor()
    encrypted_data = encryptor.update(padded_data) + encryptor.finalize()
    
    # Return base64 encoded
    return base64.b64encode(encrypted_data).decode('utf-8')

def encrypt_mobile_number(mobile_number):
    """
    Encrypt mobile number using AES-128 matching CERS mobile app
    """
    key, iv = generate_aes128_key_iv()
    encrypted = encrypt_aes128_cbc(mobile_number, key, iv)
    url_encoded = urllib.parse.quote(encrypted)
    
    return {
        'original': mobile_number,
        'encrypted': encrypted,
        'url_encoded': url_encoded
    }

def main():
    """
    Main function with command line support
    """
    if len(sys.argv) > 1:
        # Use command line argument
        mobile_number = sys.argv[1]
    else:
        # Interactive input
        mobile_number = input("Enter mobile number: ").strip()
    
    if not mobile_number:
        print("Error: Please provide a mobile number")
        return
    
    # Encrypt the mobile number
    result = encrypt_mobile_number(mobile_number)
    
    print("=== Mobile Number Encryption (AES-128) ===")
    print(f"Original Mobile:    {result['original']}")
    print(f"AES-128 Encrypted:  {result['encrypted']}")
    print(f"URL Encoded:        {result['url_encoded']}")
    print()
    
    print("=== API Usage ===")
    print(f"For CheckUserType API parameter:")
    print(f"MobileNo={result['url_encoded']}")
    print()
    
    print("=== Full API URL Example ===")
    print(f"GET /api/CheckUserType?MobileNo={result['url_encoded']}")
    print()
    
    print("=== Encryption Details ===")
    print("- Algorithm: AES-128-CBC")
    print("- Key: First 16 chars of 'CERS&NicHP@23@ece'")
    print("- IV: Same as key")
    print("- Padding: PKCS7")
    print("- Encoding: UTF-8 → AES → Base64 → URL encode")

if __name__ == "__main__":
    main()
