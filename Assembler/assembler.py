# Written by Frank Shen for COMPSYS 701

import struct

# How to write instructions. Registers are not optional, even if they will not be used.
# OPERATION, #, #, [#/$][b/d/h]#

address_modes = {
    "in": "00",
    "im": "01", 
    "dir": "10",
    "reg": "11"
}

# Change opcodes to whatever you use.
opcodes = {
    "ldr"	: "000000",
    "str"	: "000010",
    "and"	: "001000",
    "or"	: "001100",
    "add"	: "111000",
    "subv"	: "000011",
    "sub"	: "000100",
    "jmp"	: "011000",
    "present"	: "011100",
    "datacall"	: "101000",
    "sz"		: "010100",
    "clfz"	: "010000",
    "lsip"	: "110111",
    "ssop"	: "111010",
    "noop"	: "110100",
    "max"	: "011110",
    "strpc"	: "011101"
}

field_names = ["operation", "rz", "rx", "operand"]

def main():
    #input_file = input("input file name: ")
    #output_file = input("output file name: ")
    
    input_file = "a.txt"
    output_file = "a.hex"
    
    iterator = 0
    with open(input_file) as f, open(output_file, "wb+") as o:
        while True:
            iterator += 1
            
            line = f.readline().strip()
            
            if not line:
                break
            
            fields = line.split(",")
            
            if fields[0].lower() not in opcodes.keys():
                raise ValueError(f"Operation field invalid. LINE {iterator}: {line}")
            else:
                fields[0] = fields[0].lower()
                
            am = ""
            
            match fields[0]:
                case "add":
                    if fields[3] == "":
                        am = "im"
                    else:
                        am = "reg"
                case "or":
                    if fields[3] == "":
                        am = "im"
                    else:
                        am = "reg"
                case "add":
                    if fields[3] == "":
                        am = "im"
                    else:
                        am = "reg"
                case "subv":
                    am = "im"
                case "sub":
                    am = "im"
                case "ldr":
                    if fields[3] != "":
                        if fields[3][0] == "#":
                            am = "im"
                        elif fields[3][0] == "$":
                            am = "dir"
                        else:
                            am = "reg"
                case "str":
                    if fields[3] != "":
                        if fields[3][0] == "#":
                            am = "im"
                        elif fields[3][0] == "$":
                            am = "dir"
                        else:
                            am = "reg"
                            
                case "jmp":
                    if fields[3] != "":
                        am = "im"
                    else:
                        am = "reg"
                
                case "present":
                    am = "im"
                    
                case "datacall":
                    if fields[3] != "":
                        am = "im"
                    else:
                        am = "reg"
                        
                case "sz":
                    am = "im"
                    
                case "clfz":
                    am = "in"
                    
                case "lsip":
                    am = "reg"
                    
                case "ssop":
                    am = "reg"
                    
                case "noop":
                    am = "in"

                case "max":
                    am = "im"
                    
                case "strpc":
                    am = "dir"
                    
                case _:
                    raise ValueError(f"Operation field invalid. LINE {iterator}: {line}")
                
                
            for i in range(1,3):
                
                if fields[i] != "":
                    try:
                        fields[i] = int(fields[i])
                    except ValueError as e:
                        raise TypeError(f"{field_names[i]} field should be a number. LINE {iterator}: {line}")
                    
                    if fields[i] < 0 or fields[i] > 15:
                        raise ValueError(f"Value of {field_names[i]} too high or low. LINE {iterator}: {line}")
                
                else:
                    fields[i] = 0
                
            # do operand parsing here
            if fields[3] != "":
                if fields[3][0] != "#" and fields[3][0] != "$":
                    raise ValueError(f"Operand field has no pre-fix. LINE {iterator}: {line}")
                
                fields[3] = fields[3][1:]
                
                radix = fields[3][0].lower()
                base = 10
                
                if radix == 'b':
                    base = 2
                elif radix == 'd':
                    base = 10
                elif radix == 'x':
                    base = 16
                else:
                    raise ValueError("Operand has invalid or no radix. LINE {iterator}: {line}")
                
                fields[3] = fields[3][1:]
                
                try:
                    fields[3] = int(fields[3], base = base)
                except ValueError as e:
                    raise TypeError(f"{field_names[3]} field should be a number. LINE {iterator}: {line}")
                
                if fields[3] < 0 or fields[3] > 65535:
                    raise ValueError(f"Value of {field_names[3]} too high or low. LINE {iterator}: {line}")
            
            else:
                fields[3] = 0
                
            am = address_modes[am]
            op_str = opcodes[fields[0]]
            rz_str = format(fields[1], "04b")
            rx_str = format(fields[2], "04b")
            operand = format(fields[3], "016b")
        
            
            string = am + op_str + rz_str + rx_str + operand
            num = int(string, base=2)
            print(line)
            print(string)
            # print(num)
            print(hex(num))
            print(num.to_bytes(8, "big"))
            o.write(struct.pack('>Q', num))
            print()
            
        # end of context manager
        
                
        

if __name__ == "__main__":
    main()
    
    