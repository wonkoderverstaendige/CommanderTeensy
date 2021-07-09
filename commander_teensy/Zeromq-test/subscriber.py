import zmq
import time

# ZeroMQ Context
context = zmq.Context()

# Define the socket using the "Context"
subscriber = context.socket(zmq.SUB)
# Define subscription and messages with prefix to accept.
subscriber.setsockopt_string(zmq.SUBSCRIBE, "")
subscriber.connect("tcp://127.0.0.1:5680")

# Define the socket using the "Context"
publisher = context.socket(zmq.PUB)
publisher.connect("tcp://127.0.0.1:5681")

id = 0

while True:
    time.sleep(0000000000000.1)
    id, now = id+1, time.ctime()

    # Message [prefix][message]
    message = "1-Update! >> #{id} >> {time}".format(id=id, time=now)
    publisher.send_string(message)

    # Message [prefix][message]
    message = "2-Update! >> #{id} >> {time}".format(id=id, time=now) 
    publisher.send_string(message)

    id += 1
    
    message= subscriber.recv()
    print (message)