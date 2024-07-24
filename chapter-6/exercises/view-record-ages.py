def read_integer_from_file(filename, offset):
    with open(filename, "rb") as f:
        f.seek(offset)
        bytes = f.read(4)
        return int.from_bytes(bytes, byteorder='little')


filename = "test.dat" 
startAddress = 320
offset = 324

for i in range(3):
	integer_value = read_integer_from_file(filename, startAddress + i * offset)
	print(integer_value)
