import requests

# Example endpoint for the appointment_bot API
url = "http://localhost:8000/walker/appointment_bot"

print("Welcome to the Appointment Bot for Hair Salon! I can help you with creating, updating, and deleting appointments. How can I assist you today?")
while True:
    # Get user input
    message = input("message: ")
    
    # Example payload (modify according to the actual API schema)
    payload = {
        "message": message,
    }

    # Make a POST request (change to GET/PUT/DELETE as needed)
    response = requests.post(url, json=payload)

    # Print the response from the server
   # print("Status Code:", response.status_code)utils.py:1236
    reply = response.json().get('reports', [{}])[0].get('Reply')
    if reply:
        print(reply)
utils.py:1236