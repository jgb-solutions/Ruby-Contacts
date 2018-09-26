require 'json'

CONTACTS_FILENAME = 'contacts.json'
WELCOME_OPTIONS = [
    "Add a new contact",
    "Display all contacts",
    "Modify a contact",
    "Delete a contact",
    "Exit the program"
]

def start
    contacts = load_contacts
    puts "Welcome to Ruby contacts!"
    display_menu
    ask_choice contacts
end

def display_menu
    WELCOME_OPTIONS.each_with_index do |choice, index|
        puts "#{index + 1} - #{choice}"
    end
end

def load_contacts
    if File.exists?("#{CONTACTS_FILENAME}")
        json_contacts = File.read(CONTACTS_FILENAME)
        JSON.parse(json_contacts)
    else
        puts "Seems your contacts list is empty."
        []
    end
end

def save_contacts contacts
    File.open("./#{CONTACTS_FILENAME}","w") do |f|
        f.write(contacts.to_json)
    end
end

def ask_choice contacts
    puts "Please choose an option:"
    choice = gets.strip
    available_choices = ["1", "2", "3", "4", "5"]

    if available_choices.include?(choice)
        case choice
            when "1"
                add_contact contacts
            when "2"
                display_contacts contacts
            when "3"
                modify_contact contacts
            when "4"
                delete_contact contacts
            when "5"
                exit_program contacts
        end
    else
        puts "Sorry but this option is not available."
        ask_choice contacts
    end
end

def ask_name
    puts "Please enter your full name"
    name = gets.strip

    if name.length > 0
        name
    else
        puts "Sorry but your name cannot be empty."
        ask_name
    end
end

def ask_email
    puts "Please enter your email"
    email = gets.strip

    if email.length > 0 # should validate email
        email
    else
        puts "Sorry but your email cannot be empty."
        ask_email
    end
end

def ask_address
    puts "Please enter your address"
    address = gets.strip

    if address.length > 0
        address
    else
        puts "Sorry but your address cannot be empty."
        ask_address
    end
end

def ask_telephone
    puts "Please enter your phone number"
    telephone = gets.strip

    if telephone.length > 0
        telephone
    else
        puts "Sorry but your telephone cannot be empty."
        ask_telephone
    end
end

def add_contact contacts
    contact = {}

    puts "Creating a new contact..."
    # ask name
    contact['name'] = ask_name

    # ask email
    contact['email'] = ask_email

    # ask address
    contact['address'] = ask_address

    # ask telephone
    contact['phone'] = ask_telephone

    contacts << contact

    puts "Contact created successfully!"

    display_menu

    ask_choice contacts
end

def display_contacts contacts
    if contacts.empty?
        puts " "
        puts "Sorry but your contact list is empty."
        puts " "
    else
        max_col_size = longest_string_length contacts
        name_header = "Full Name "
        email_header = "Email "
        address_header = "Address "
        phone_header = "Phone "

        print name_header + "|=> "
        print email_header + "|=> "
        print address_header + "|=> "
        print phone_header
        print "\n"
        contacts.each do |contact|
            name = contact['name']
            email = contact['email']
            address = contact['address']
            phone = contact['phone']
            # name_dash = " " * (max_col_size - name.length + 1)
            # email_dash = " " * (max_col_size - email.length + 1)
            # address_dash = " " * (max_col_size - address.length + 1)
            # phone_dash = " " * (max_col_size - phone.length + 1)
            print "#{name} |=> "
            print "#{email} |=> "
            print "#{address} |=> "
            print "#{phone}"
            print "\n"
            puts "-----------------------------------------------------------------"
        end
        puts "\n"
    end

    display_menu
    ask_choice contacts
end

def modify_contact contacts
    if contacts.empty?
        puts "Seems your contacts list is empty."
        puts "You need to add a contact first"
        display_menu
        ask_choice contacts
    else
        contacts.each_with_index {|contact, index| puts "#{index + 1} - #{contact['name']}"}

        index = ask_index contacts

        contact = contacts[index]

        # ask name
        puts "Modifying the name of the contact. The current value is \'#{contact['name']}\'"
        contact['name'] = ask_name

        # ask email
        puts "Modifying the email of the contact. The current value is \'#{contact['email']}\'"
        contact['email'] = ask_email

        # ask address
        puts "Modifying the address of the contact. The current value is \'#{contact['address']}\'"
        contact['address'] = ask_address

        # ask telephone
        puts "Modifying the telephone of the contact. The current value is \'#{contact['phone']}\'"
        contact['phone'] = ask_telephone

        contacts[index] = contact

        puts "Contact updated successfully!"

        display_menu

        ask_choice contacts
    end
end

def delete_contact contacts
    if contacts.empty?
        puts "Seems your contacts list is empty."
        puts "You need to add a contact first"
        display_menu
        ask_choice contacts
    else
        contacts.each_with_index {|contact, index| puts "#{index + 1} - #{contact['name']}"}

        index = ask_index contacts

        contacts.delete_at index

        puts "Contact delete successfully!"

        display_menu

        ask_choice contacts
    end
end

def exit_program contacts
    puts "Saving contacts to file."
    save_contacts contacts
    puts "Goodbye!"
end

def longest_string_length contacts
    longest_values = []

    contacts.each do |contact|
       longest_values << contact.max_by{|key, value| value}
    end

    longest_values.max[1].length
end

def ask_index contacts
    puts "Please choose the contact's number to modify it"
    index_string = gets.strip

    index = index_string.to_i - 1

    if contacts[index].nil?
        puts "Sorry, but the contact's number you choose is not available."
        ask_index contacts
    else
        index
    end
end