import from mtllm.llm {Model}

import sqlite3; # For database operations

glob llm = Model(model_name="gemini/gemini-2.0-flash");

#import from mtllm.llm { Model }

# glob llm = Gemini(
#     model_name="gemini-2.0-flash"
# );

obj Appointment {
    has date: str;
    has time: str;
    has type: str;
    has customer_name: str;
    has customer_telephone: str;
    has Remarks: str;
}

sem appointment.type = "Type of appointment. Hair cut, Massage, Facial,Hair color, etc.";

glob conn = sqlite3.connect("appointments.db");
glob cursor = conn.cursor();
#global conn, cursor;

def print_appointment(appt: Appointment) {
print("Appointment Details:");
print("Date:", appt.date);
print("Time:", appt.time);
print("Type:", appt.type);
print("Customer Name:", appt.customer_name);
print("Customer Telephone:", appt.customer_telephone);
print("Remarks:", appt.Remarks);
}


"""This function will create an appointment object based on user input by extracting necesry details from the prompt. If any field is missing, it will be set to "MISSING"."""
def create_appointment(prompt: str) -> Appointment by llm();

"""This function will ask the user for any missing fields in the appointment in a human friendly way in string format. Be really manner full.Adress customer in first person manner. And human friendly way"""
def ask_for_missing_fields(user_appointment: Appointment) -> str by llm();

"""This function will get appoinment with some missing fields and update the appointment with user input.If any field is not clear or not provided, it will be set to Missing.Keep the out[ut human]"""
def update_appointment(user_ppointment: Appointment,user_input : str) -> Appointment by llm();

""" """
def get_appointment_id_to_delete_the_appointment(user_input:str,previous_conversation:str) -> int by llm(); 
   


# """This function will get appoinment with some missing fields and update the appointment with user input."""
# def update_appointment(appointment: appointment,user_input : str) -> str by llm(method="Reason");

def check_missing_fields(user_appointment: Appointment) -> bool {
    return (
        (user_appointment.date == "MISSING") or
        (user_appointment.time == "MISSING") or
        (user_appointment.type == "MISSING") or
        (user_appointment.customer_name == "MISSING") or
        (user_appointment.customer_telephone == "MISSING") or
        (user_appointment.Remarks == "MISSING")
    );
}

def add_a_new_appointment(user_input : str) -> Appointment {
    user_appointment = create_appointment(user_input);
    print_appointment(user_appointment);

    while (check_missing_fields(user_appointment)) {
        ask_null_fields = ask_for_missing_fields(user_appointment);
        print(ask_null_fields);
        #update_appointments_values =input("");
        update_appointments_values = input("");
        #update_appointments_values = "No remarks, I want to get a hair cut and my teleohone number is 01120702678";
        user_appointment = update_appointment(user_appointment, update_appointments_values);
    }
    print_appointment(user_appointment);
    return user_appointment;
}

#DB Related Functions
def appointment_init() {
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS appointments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            time TEXT,
            type TEXT,
            customer_name TEXT,
            customer_telephone TEXT,
            Remarks TEXT
        )
    """);
    conn.commit();
}
def add_a_new_appointment_to_db(user_appointment: Appointment) -> int {
    cursor.execute("""
        INSERT INTO appointments (date, time, type, customer_name, customer_telephone, Remarks)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (user_appointment.date, user_appointment.time, user_appointment.type,
          user_appointment.customer_name, user_appointment.customer_telephone, user_appointment.Remarks));
    conn.commit();
    appointment_number = cursor.lastrowid;
    print("Appointment added to the database with ID:", appointment_number);
    return appointment_number;
}



def fetch_appointment_by_id(appointment_id: int) -> Appointment {
    cursor.execute("SELECT * FROM appointments WHERE id = ?", (appointment_id,));
    row = cursor.fetchone();
    
    if row is None {
        print("No appointment found with ID:", appointment_id);
        return None;
    }
    #fetched_appointment : Appoinment = Appointment("MISSING", "MISSING", "MISSING", "MISSING", "MISSING", "MISSING");

    fetched_appointment: Appointment = Appointment(
        str(row[1]),
        str(row[2]),
        str(row[3]),
        str(row[4]),
        str(row[5]),
        str(row[6])
    );
    return fetched_appointment; 
}

def delete_appointment_by_id(appointment_id: int) {
    cursor.execute("DELETE FROM appointments WHERE id = ?", (appointment_id,));
    conn.commit();
    print("Appointment with ID:", appointment_id, "has been deleted.");
}



"This function will start a new chat with the user and return int values 1 - New Appointment, 2 - Delete and Appointment. 3 - Need More Information, 4 - Exit."
def new_chat(user_input: str) -> int by llm();


   



with entry {
    user_inputs_full = "";
    appointment_init();
    print("Welcome to the Appointment Bot for Hair Salon!");
    print("I can help you with creating, updating, and deleting appointments.");
    print("How can I assist you today?");
    #TEst
    while 1{
        user_input = input("Say Hi:");
        user_inputs_full += user_input + "\n";
        #user_input = "Hi,My name is Mihiran. I want to create a new appointment for tomorrow at 10:00 AM.";
        catergory = new_chat(user_input);
        if catergory == 1 {
            print("Lets create a new appointment.");
            appointment = add_a_new_appointment(user_input);
            appointment_number = add_a_new_appointment_to_db(appointment);
            print("Appointment created successfully with ID:", appointment_number);
        } elif catergory == 2 {
            print("Lets delete an appointment.");
            print("Whats your appointment ID?");
            user_input = input("");
            user_inputs_full += user_input + "\n";
            appointment_id = get_appointment_id_to_delete_the_appointment(user_input, user_inputs_full);
            delete_appointment_by_id(appointment_id);
            print("Appointment with ID:", appointment_id, "has been deleted.");
            
        } elif catergory == 3 {
            print("Your request is not clear. Please provide more information.");
            continue;
        
        } elif catergory == 4 {
            print("Exiting the chat.");
            exit();
        } else {
            print("This feature is not implemented yet.");
            print("Your request is not clear. Please provide more information.");
            continue;
        }

        # fetched_appointment = fetch_appointment_by_id(appointment_number);
        # print("Fetched Appointment Details:");
        # print_appointment(fetched_appointment);

        break;
        print("Thank you for using the appointment bot. Have a great day!");
    }
    

    #Fectch the first entry from the appointments table
    # cursor.execute("SELECT * FROM appointments ORDER BY id ASC LIMIT 1");
    # first_entry = cursor.fetchone();
    # if first_entry is not None {
    #     print("First appointment entry:");
    #     print(first_entry);
    # } else {
    #     print("No appointments found in the database.");
    # }
}
