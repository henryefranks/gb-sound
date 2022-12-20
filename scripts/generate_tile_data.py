def gen_tile(data):
    res = "dw "

    for row in data:
        lsb = ""
        msb = ""

        for tile in row:
            if tile == "0":
                lsb += "0"
                msb += "0"
            elif tile == "1":
                lsb += "1"
                msb += "0"
            elif tile == "2":
                lsb += "0"
                msb += "1"
            elif tile == "3":
                lsb += "1"
                msb += "1"
            else:
                raise Exception(f"Invalid Character: {tile}")
        
        res += f"${int(lsb, 2):02x}{int(msb, 2):02x}, "

    return res[:-2]


hex_tiles = {
    "empty": [
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    ],
    "0": [
        "00333000",
        "03300300",
        "33003330",
        "33030330",
        "33300330",
        "03003300",
        "00333000",
        "00000000"
    ],
    "1": [
        "00033000",
        "00333000",
        "00033000",
        "00033000",
        "00033000",
        "00033000",
        "03333330",
        "00000000"
    ]
}


print("; hex character tilemap")
print("Section \"HEX TILES\", ROM0")
print("HEX_TILES::")
for key, tile in hex_tiles.items():
    print(f"  {gen_tile(tile)} ; {key}")
