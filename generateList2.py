import itertools
import random

def generate_unique_combinations(num_combinations=1000):
    """
    Generates a list of unique combinations, each a sub-list of 5 numbers.
    The numbers adhere to specific ranges:
    - First and second numbers: 0 to 3
    - Third number: 0 to 38
    - Fourth and fifth numbers: 0 to 35

    Args:
        num_combinations (int): The desired number of unique combinations.

    Returns:
        list: A list of unique sub-lists, or an empty list if not enough unique combinations exist.
    """
    all_possible_combinations = set()

    # Generate all possible combinations within the given ranges
    for n1 in range(4):  # 0 to 3
        for n2 in range(4):  # 0 to 3
            for n3 in range(39):  # 0 to 38
                for n4 in range(36):  # 0 to 35
                    for n5 in range(36):  # 0 to 35
                        all_possible_combinations.add(tuple([n1, n2, n3, n4, n5]))

    # Convert the set of tuples to a list of lists
    list_of_all_combinations = [list(combo) for combo in all_possible_combinations]

    # Shuffle the list to get a random sample
    random.shuffle(list_of_all_combinations)

    # Return the requested number of unique combinations
    if len(list_of_all_combinations) >= num_combinations:
        return list_of_all_combinations[:num_combinations]
    else:
        print(f"Warning: Only {len(list_of_all_combinations)} unique combinations are possible.")
        return []

# Example usage:
my_unique_lists = generate_unique_combinations(1000)

if my_unique_lists:
    print(f"Generated {len(my_unique_lists)} unique lists.")
    # You can inspect the first few lists if needed:
    # for i in range(min(5, len(my_unique_lists))):
    print(my_unique_lists)