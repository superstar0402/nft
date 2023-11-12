def bytes_to_hex(bytes_obj):
    """
    Convert a bytes object to a hexadecimal string.

    :param bytes_obj: Bytes object to convert.
    :return: Hexadecimal string.
    """
    # Using hex() and format() to convert bytes to a hex string
    hex_str = bytes_obj.hex()

    # Alternatively, using a manual loop and format function for educational purposes:
    # hex_str = ''.join(f'{byte:02x}' for byte in bytes_obj)

    return hex_str

# Example usage:
if __name__ == "__main__":
    # Define a bytes object
    sample_bytes = b'Hello, World!'

    # Convert the bytes to hex and print
    hex_result = bytes_to_hex(sample_bytes)
    print(f"The hexadecimal equivalent is: {hex_result}")
