with open("a.txt") as f, open("out.txt", "w+") as o:
    while True:
        line = f.readline().strip()
        if not line:
            break
        
        s = line.split(" ")
        o.write(f"{s[0]} => {s[0]},\n")