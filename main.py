import mysql.connector
from AnimalRegistry import AnimalRegistry
from Counter import Counter


def main():
    # Создаем объект класса Counter
    with Counter() as counter:
        # Database configuration
        db_config = {
            "host": "localhost",
            "user": "root",
            "password": "",
            "database": "human_friends"
        }

        # Создаем экземпляр класса AnimalRegistry
        registry = AnimalRegistry(db_config)

        while True:
            print("Animal Registry Menu:")
            print("1. Add new animal")
            print("2. Show list of animals")
            print("3. Train animal with new commands")
            print("4. Exit")

            choice = input("Enter your choice: ")

            if choice == "1":
                name = input("Enter the animal's name: ")
                birthday = input("Enter the animal's birthday (YYYY-MM-DD): ")
                commands = input("Enter the animal's commands (comma-separated): ")
                genus_name = input("Enter the animal's genus name: ")
                class_name = input("Enter the animal's class name: ")

                registry.add_animal(name, birthday, commands, genus_name, class_name)
                # Увеличиваем счетчик при заведении нового животного
                counter.add()

            elif choice == "2":
                registry.show_animal_list()

            elif choice == "3":
                animal_id = input("Enter the ID of the animal you want to train: ")
                new_commands = input("Enter the new commands for the animal (comma-separated): ")

                registry.train_animal(animal_id, new_commands)

            elif choice == "4":
                print("Exiting the program.")
                break

            else:
                print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()
