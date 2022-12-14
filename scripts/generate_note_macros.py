#####################################################
## GENERATE MACROS TO PRODUCE ALL NOTES IN C MAJOR ##
#####################################################

# example usage:
# $ python3 scripts/generate_note_macros.py > include/data/notes.inc

notes = "CDEFGAB"

freq = [
    [  16.35,   18.35,   20.60,   21.83,   24.50,   27.50,   30.87], # C0
    [  32.70,   32.70,   41.20,   43.65,   49.00,   55.00,   61.74], # C1
    [  65.41,   73.42,   82.41,   87.31,   98.00,  110.00,  123.47], # C2
    [ 130.81,  146.83,  164.81,  174.61,  196.00,  220.00,  246.94], # C3
    [ 261.63,  293.66,  329.63,  349.23,  392.00,  440.00,  493.88], # C4
    [ 523.25,  587.33,  659.25,  698.46,  783.99,  880.00,  987.77], # C5
    [1046.50, 1174.66, 1318.51, 1396.91, 1567.98, 1760.00, 1975.53], # C6
    [2093.00, 2349.32, 2637.02, 2793.83, 3135.96, 3520.00, 3951.07], # C7
    [4186.01, 4698.63, 5274.04, 5587.65, 6271.93, 7040.00, 7902.13]  # C8
]

note_table = []

counter = 0
empty_data_string = "  dw "

print("; NOTE DATA (C MAJOR ONLY)")
print()

for i in range(9):
    data = empty_data_string

    for j, note in enumerate(notes):
        f = freq[i][j]
        wavelen = int(2048 - (65536 / f))

        if not 0 <= wavelen <= 2048:
            continue

        print(f"NOTE_{note + str(i)} EQU ${counter:02x}")

        data += f"${wavelen:04x}"
        if j < len(notes) - 1:
            data += ", "

        counter += 1

    if data != empty_data_string:
        note_table.append(data)
        print()

print('Section "NOTES", ROM0')
print('note_table::')

for line in note_table:
    print(line)
