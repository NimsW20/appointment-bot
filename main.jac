import from mtllm.llm {Model}

import sqlite3; # For database operations

glob llm = Model(model_name="gemini/gemini-2.0-flash");

#import from mtllm.llm { Model }

# glob llm = Gemini(
#     model_name="gemini-2.0-flash"
# );

obj appointment {
    has date: str;
    has time: str;
    has type: str;
    has customer_name: str;
    has customer_telephone: str;
    has Remarks: str;
}

sem appointment.type = "Type of appointment. Hair cut, Massage, Facial,Hair color, etc.";


def print_appointment(appt: appointment) {
print("Appointment Details:");
print("Date:", appt.date);
print("Time:", appt.time);
print("Type:", appt.type);
print("Customer Name:", appt.customer_name);
print("Customer Telephone:", appt.customer_telephone);
print("Remarks:", appt.Remarks);
}


"""This function will create an appointment object based on user input by extracting necesry details from the prompt. If any field is missing, it will be set to "MISSING"."""
def create_appointment(prompt: str) -> appointment by llm();

"""This function will ask the user for any missing fields in the appointment in a human friendly way in string format. Be really manner full.Adress customer in first person manner"""
def ask_for_missing_fields(user_appointment: appointment) -> str by llm();

"""This function will get appoinment with some missing fields and update the appointment with user input.If any field is not clear or not provided, it will be set to Missing."""
def update_appointment(user_ppointment: appointment,user_input : str) -> appointment by llm();

# """This function will get appoinment with some missing fields and update the appointment with user input."""
# def update_appointment(appointment: appointment,user_input : str) -> str by llm(method="Reason");

def check_missing_fields(user_appointment: appointment) -> bool {
    return (
        (user_appointment.date == "MISSING") or
        (user_appointment.time == "MISSING") or
        (user_appointment.type == "MISSING") or
        (user_appointment.customer_name == "MISSING") or
        (user_appointment.customer_telephone == "MISSING") or
        (user_appointment.Remarks == "MISSING")
    );
}

def add_a_new_appointment(user_input : str) -> appointment {
    user_appointment = create_appointment(user_input);
    print_appointment(user_appointment);

    while (check_missing_fields(user_appointment)) {
        ask_null_fields = ask_for_missing_fields(user_appointment);
        print(ask_null_fields);
        #update_appointments_values =input("");
        update_appointments_values = "o remarks, I want to get a hair cut and my teleohone number is 01120702678";
        user_appointment = update_appointment(user_appointment, update_appointments_values);
    }
    print_appointment(user_appointment);
    add_a_new_appointment_to_db(user_appointment);
    return user_appointment;
}

#DB Related Functions
def appointment_init() {
    global conn, cursor;
    conn = sqlite3.connect("appointment.db");
    cursor = conn.cursor();
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

def add_a_new_appointment_to_db(user_appointment: appointment) {
    cursor.execute("""
        INSERT INTO appointments (date, time, type, customer_name, customer_telephone, Remarks)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (user_appointment.date, user_appointment.time, user_appointment.type,
          user_appointment.customer_name, user_appointment.customer_telephone, user_appointment.Remarks));
    conn.commit();
    print("Appointment added to the database.");
}



"This function will start a new chat with the user and return int values 1 - New Appointment, 2 - Delete and Appointment. 3 - Need More Information, 4 - Exit."
def new_chat(user_input: str) -> int by llm();


   



with entry {
    appointment_init();
    
    #user_input = input("Say Hi:");
    user_input = "Hi,My name is Mihiran. I want to create a new appointment for tomorrow at 10:00 AM.";
    catergory = new_chat(user_input);
    if catergory == 1 {
        print("Lets create a new appointment.");
        add_a_new_appointment(user_input);
    } else{
        print("This feature is not implemented yet.");
    }

    cursor.execute("SELECT * FROM appointments ORDER BY id ASC LIMIT 1");
    first_entry = cursor.fetchone();
    if first_entry is not None {
        print("First appointment entry:");
        print(first_entry);
    } else {
        print("No appointments found in the database.");
    }
}



