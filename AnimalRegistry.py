import mysql.connector


class AnimalRegistry:
    def __init__(self, db_config):
        self.db_config = db_config

    def add_animal(self, name, birthday, commands, genus_name, class_name):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            insert_query = "INSERT INTO all_animals (Name, Birthday, Commands, Genus_name, Class_name) VALUES (%s, %s, %s, %s, %s)"
            data = (name, birthday, commands, genus_name, class_name)
            cursor.execute(insert_query, data)

            connection.commit()
            print(f"Animal {name} has been added to the registry.")

        except mysql.connector.Error as error:
            print(f"An error occurred: {error}")

        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def get_animal_commands(self, animal_id):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = "SELECT Commands FROM all_animals WHERE Id = %s"
            cursor.execute(query, (animal_id,))
            commands = cursor.fetchone()

            if commands:
                print(f"Commands for animal {animal_id}: {commands[0]}")
            else:
                print(f"Animal with ID {animal_id} not found.")

        except mysql.connector.Error as error:
            print(f"An error occurred: {error}")

        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def train_animal(self, animal_id, new_commands):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            update_query = "UPDATE all_animals SET Commands = %s WHERE Id = %s"
            cursor.execute(update_query, (new_commands, animal_id))

            connection.commit()
            print(f"Animal {animal_id} has been trained with new commands.")

        except mysql.connector.Error as error:
            print(f"An error occurred: {error}")

        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def classify_animal(self, animal_id):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = "SELECT Genus_name, Class_name FROM all_animals WHERE Id = %s"
            cursor.execute(query, (animal_id,))
            animal_info = cursor.fetchone()

            if animal_info:
                genus_name, class_name = animal_info
                print(f"Animal {animal_id} belongs to Genus: {genus_name}, Class: {class_name}")
            else:
                print(f"Animal with ID {animal_id} not found.")

        except mysql.connector.Error as error:
            print(f"An error occurred: {error}")

        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def show_animal_list(self):
        try:
            connection = mysql.connector.connect(**self.db_config)
            cursor = connection.cursor()

            query = "SELECT Id, Name, Birthday, Commands, Genus_name, Class_name FROM all_animals"
            cursor.execute(query)
            animals = cursor.fetchall()

            print("List of Animals:")
            for animal in animals:
                animal_id, name, birthday, commands, genus_name, class_name = animal
                print(
                    f"ID: {animal_id}, Name: {name}, Birthday: {birthday}, Commands: {commands}, Genus: {genus_name}, Class: {class_name}")

        except mysql.connector.Error as error:
            print(f"An error occurred: {error}")

        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
