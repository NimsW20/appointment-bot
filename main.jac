import from mtllm.llm {Model}

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
    has description: str;
}

def print_appointment(appt: appointment) {
    print("Appointment Details:");
    print("Date: " + (appt.date if appt.date is not None and appt.date != "" else "null"));
    print("Time: " + (appt.time if appt.time is not None and appt.time != "" else "null"));
    print("Type: " + (appt.type if appt.type is not None and appt.type != "" else "null"));
    print("Customer Name: " + (appt.customer_name if appt.customer_name is not None and appt.customer_name != "" else "null"));
    print("Customer Telephone: " + (appt.customer_telephone if appt.customer_telephone is not None and appt.customer_telephone != "" else "null"));
    print("Description: " + (appt.description if appt.description is not None and appt.description != "" else "null"));
}


"""This function will create an appointment object based on user input.If any field is missing, it will be set to NONE.DO NOT ADD GENERATIVE DETAILS"""
def create_appointment(prompt: str) -> appointment by llm();

"""This function will ask the user for any missing fields in the appointment."""
def ask_for_missing_fields(user_appointment: appointment) -> str by llm();

"""This function will get appoinment with some missing fields and update the appointment with user input.If any field is not clear or not provided, it will be set to Missing."""
def update_appointment(user_ppointment: appointment,user_input : str) -> appointment by llm();

# """This function will get appoinment with some missing fields and update the appointment with user input."""
# def update_appointment(appointment: appointment,user_input : str) -> str by llm(method="Reason");

def check_missing_fields(user_appointment: appointment) -> bool {
    return (
        (user_appointment.date == "Missing") or
        (user_appointment.time == "Missing") or
        (user_appointment.type == "Missing") or
        (user_appointment.customer_name == "Missing") or
        (user_appointment.customer_telephone == "Missing") or
        (user_appointment.description == "Missing")
    );
}

def add_a_new_appointment(user_input : str) -> appointment {
    user_appointment = create_appointment(user_input);
    print_appointment(user_appointment);

    while (check_missing_fields(user_appointment)) {
        ask_null_fields = ask_for_missing_fields(user_appointment);
        print(ask_null_fields);
        update_appointments_values =input("");
        #update_appointments_values = "New date is 2023-10-01, time is 10:00 AM";
        user_appointment = update_appointment(user_appointment, update_appointments_values);
    }
    print_appointment(user_appointment);
    return user_appointment;
}

"This function will start a new chat with the user and return int values 1 - New Appointment, 2 - Delete and Appointment. 3 - Need More Information, 4 - Exit."
def new_chat(user_input: str) -> int by llm();


   



with entry {
    user_input = input("Say Hi:");
    catergory = new_chat(user_input);
    if catergory == 1 {
        print("Lets create a new appointment.");
        add_a_new_appointment("");
    } else{
        print("This feature is not implemented yet.");
    }
}



