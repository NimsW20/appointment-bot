import from mtllm.llm {Model}

import sqlite3; # For database operations


glob llm = Model(model_name="gemini/gemini-2.0-flash");
obj Appointment {
    has date: str;
    has time: str;
    has type: str;
    has customer_name: str;
    has customer_telephone: str;
    has Remarks: str;
}

sem appointment.type = "Type of appointment. Hair cut, Massage, Facial,Hair color, etc.";


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

"""A small joke end the conversation of the appointment bot for Hair saloon.Say something funny about hair or related to hair saloon."""
def random_hair_salon_joke() -> str by llm();
   


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
    conn = sqlite3.connect("appointments.db");
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
def add_a_new_appointment_to_db(user_appointment: Appointment) -> int {
    conn = sqlite3.connect("appointments.db");
    cursor = conn.cursor();
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
    conn = sqlite3.connect("appointments.db");
    cursor = conn.cursor();
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
    conn = sqlite3.connect("appointments.db");
    cursor = conn.cursor();
    cursor.execute("DELETE FROM appointments WHERE id = ?", (appointment_id,));
    conn.commit();
    print("Appointment with ID:", appointment_id, "has been deleted.");
}



"This function will start a new chat with the user and return int values 2 - New Appointment, 3 - Delete and Appointment. 4 - Need More Information, 5 - Exit."
def new_chat(user_input: str) -> int by llm();

glob status: int = 0;
glob catergory: int = 0;
glob user_inputs_full: str = "";
glob user_appointment: Appointment;
#glob catergory_state: int = 0;



def main_chat(request: str) -> str {
    global user_appointment;
    global status;
    global catergory;
    #globab catergory_state;
    global user_inputs_full;
    response = "";

    if catergory == 0 {#New Chat
        catergory = new_chat(request);
    }
    if catergory==2{#Make an Appointment
        if (status == 0){
            user_appointment = create_appointment(request);
            response+=ask_for_missing_fields(user_appointment);
            status = 1;
        }
        elif status == 1{
            user_appointment = update_appointment(user_appointment, request);
            if not(check_missing_fields(user_appointment)){
                appointment_number = add_a_new_appointment_to_db(user_appointment);
                response += "Appointment created successfully with ID: " + str(appointment_number) + "\n";
                response += "Here are your appointment details:\n";
                response += "Date: " + user_appointment.date + "\n";
                response += "Time: " + user_appointment.time + "\n";
                response += "Type: " + user_appointment.type + "\n";
                response += "Customer Name: " + user_appointment.customer_name + "\n";
                response += "Customer Telephone: " + user_appointment.customer_telephone + "\n";
                response += "Remarks: " + user_appointment.Remarks + "\n";
                catergory =99;
            } else {
                response+=ask_for_missing_fields(user_appointment);
            }
        }
    } elif catergory == 3 {
            response = "Lets delete an appointment.";
            response += "Whats your appointment ID?";
            user_input = input("");
            user_inputs_full += request + "\n";
            appointment_id = get_appointment_id_to_delete_the_appointment(request, user_inputs_full);
            delete_appointment_by_id(appointment_id);
            response = "Appointment with ID:" + str(appointment_id) + " has been deleted.";
        } elif catergory == 4 {
            response = "Your request is not clear. Please provide more information.";
        }
        
    else {
        response = "Your request is not clear. Please provide more information.";
        catergory = 0; # Reset catergory for new chat
        
    }
    if catergory == 99 {
        response += "Thank you for using the Appointment Bot. ";
        response += random_hair_salon_joke();
        status = 0; # Reset status for new chat
        catergory = 0; # Reset catergory for new chat
    }

    return response;

}





with entry{
    #appointment_init();
    print("Welcome to the Appointment Bot for Hair Salon! I can help you with creating, updating, and deleting appointments. How can I assist you today?");
    # while 1 {
    #     user_input = input("Reply:");
    #     response = main_chat(user_input);
    #     print(response);
        
    # }
    
}

# Public endpoint (no authentication)
walker appointment_bot {
    has message : str;
    obj __specs__ {
        
        static has auth: bool = False;
    }

    can reply with `root entry{
        response = main_chat(self.message);
        
        report {
            "Reply": response
            #self.message;
            };

    }
    

}

   
