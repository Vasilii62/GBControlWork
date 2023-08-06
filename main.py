from Program.AnimalRegistry import AnimalRegistry
from Program.Counter import Counter
from Program.Db_config import Db_config

def main():
    registry = AnimalRegistry()
    counter = Counter()

    try:
        with AnimalRegistry(Db_config) as registry:
            while True:
                print("\n--- Animal Registry Menu ---")
                print("1. Add a new animal")
                print("2. Identify the class of an animal")
                print("3. See the list of commands of an animal")
                print("4. Train an animal with new commands")
                print("5. Show all animals")
                print("6. Exit")

                choice = int(input("Enter your choice: "))

                if choice == 1:
                    name = input("Enter the name of the animal: ")
                    birthday = input("Enter the birthday of the animal (YYYY-MM-DD): ")
                    commands = input("Enter the commands of the animal (comma-separated): ")
                    genus_name = input("Enter the genus name of the animal: ")
                    class_name = input("Enter the class name of the animal: ")
                    registry.add_animal(name, birthday, commands, genus_name, class_name)
                    print(f"Animal {name} has been added to the registry.")
                    print(f"Total animals registered: {counter.add()}")

                elif choice == 2:
                    registry.show_animals()
                    animal_idx = int(input("Enter the index of the animal: "))
                    registry.identify_class(animal_idx)

                elif choice == 3:
                    registry.show_animals()
                    animal_idx = int(input("Enter the index of the animal: "))
                    print(f"Commands of the animal: {registry.animals[animal_idx - 1]['Commands']}")

                elif choice == 4:
                    registry.show_animals()
                    animal_idx = int(input("Enter the index of the animal: "))
                    new_commands = input("Enter the new commands for the animal (comma-separated): ")
                    registry.train_animal(animal_idx, new_commands)

                elif choice == 5:
                    registry.show_animals()

                elif choice == 6:
                    print("Exiting the Animal Registry.")
                    break

                else:
                    print("Invalid choice. Please try again.")

    except:
        print("An error occurred.")

if __name__ == "__main__":
    main()
