import itertools
import random

range1_2 = range(4)
range3 = range(39)
range4_5 = range(36)

all_combinations = list(itertools.product(range1_2, range1_2, range3, range4_5, range4_5))

if len( all_combinations) < 1000:
    print("Error: Not enough unique combinations possible to create 1000 arrays.")
else:
    result_arrays = random.sample(all_combinations, 1000)

    print(result_arrays)