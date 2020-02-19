detected_loop = 0
start = int(0)

rng_values_list = []
rng_values_list.append(start)

old_rng = start

def cycle_rng():
    global old_rng
    mult_res = old_rng * 0x1DF5E0D
    add_one = mult_res + 1
    truncate = add_one & 0xFFFFFFFF
    old_rng = int(truncate)
    hex = format(truncate, '02x')
    return hex

def test_rng(): 
    global old_rng
    mult_res = old_rng + 2;
    truncate = mult_res & 0xF;
    old_rng = int(truncate)
    return truncate

def detectRNGLoop():
    global detected_loop
    while not detected_loop:
        new_rng_value = cycle_rng()
        if new_rng_value in rng_values_list:
            detected_loop = 1
            print(*rng_values_list, sep = ", ")  
        else:
            rng_values_list.append(new_rng_value)
