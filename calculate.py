# echo_server.py
# from puf import puf


#######################################################


#                               Define Libraries
import RPi.GPIO as GPIO
import time
import socket
import os

# print("Hello Alireza and Mohammad - Frequency Measurement")

#               Initialization
os.system('clear')
GPIO.setmode(GPIO.BCM)
print("Version = ", GPIO.VERSION)

GPIO.setup(14, GPIO.IN)
GPIO.setup(15, GPIO.IN)
GPIO.setup(18, GPIO.IN)
GPIO.setup(23, GPIO.IN)
GPIO.setup(24, GPIO.IN)
GPIO.setup(25, GPIO.IN)
GPIO.setup(8, GPIO.IN)
GPIO.setup(7, GPIO.IN)

counter = [0, 0, 0, 0, 0, 0, 0, 0]


# global counter

def counterPlus1(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[0] += 1
    else:
        counter[0] += 0


def counterPlus2(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[1] += 1
    else:
        counter[1] += 0


def counterPlus3(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[2] += 1
    else:
        counter[2] += 0


def counterPlus4(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[3] += 1
    else:
        counter[3] += 0


def counterPlus5(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[4] += 1
    else:
        counter[4] += 0


def counterPlus6(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[5] += 1
    else:
        counter[5] += 0


def counterPlus7(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[6] += 1
    else:
        counter[6] += 0


def counterPlus8(channel):
    # global counter
    if GPIO.input(channel) > 0.5:
        counter[7] += 1
    else:
        counter[7] += 0


# 					##    Defining Event and Interrupts

def removeallinterrupt():
    GPIO.remove_event_detect(14)
    GPIO.remove_event_detect(15)
    GPIO.remove_event_detect(18)
    GPIO.remove_event_detect(23)
    GPIO.remove_event_detect(24)
    GPIO.remove_event_detect(25)
    GPIO.remove_event_detect(8)
    GPIO.remove_event_detect(7)
    #GPIO.remove_event_detect(channel)


def puf(P1, P2, counter):
    # counter = [0, 0, 0, 0, 0, 0, 0, 0]
    First = 0
    Second = 0
    Pair = [P1, P2]
    Challenge = 2

    #                            Interrupt Methods
    if Flag2:
        
        GPIO.add_event_detect(14, GPIO.RISING, callback=counterPlus1, bouncetime=1)
        GPIO.add_event_detect(15, GPIO.RISING, callback=counterPlus2, bouncetime=1)
        GPIO.add_event_detect(18, GPIO.RISING, callback=counterPlus3, bouncetime=1)
        GPIO.add_event_detect(23, GPIO.RISING, callback=counterPlus4, bouncetime=1)
        GPIO.add_event_detect(24, GPIO.RISING, callback=counterPlus5, bouncetime=1)
        GPIO.add_event_detect(25, GPIO.RISING, callback=counterPlus6, bouncetime=1)
        GPIO.add_event_detect(8, GPIO.RISING, callback=counterPlus7, bouncetime=1)
        GPIO.add_event_detect(7, GPIO.RISING, callback=counterPlus8, bouncetime=1)

    # ##					 CALCULATE  COUNTER AND MEASUREMENTS IN 1 SECONDS

    # for x in range(0,1):
    time.sleep(0.5)
    counter = [elem * 2 for elem in counter]
    print("Frequency = ", counter)
	
    #removeallinterrupt()
	#   ########################################## Element 1 of the Pair

    if Pair[0] == 0:
        First = counter[0]
        print("Line0", First)

    elif Pair[0] == 1:
        First = counter[1]
        print("Line1", First)

    elif Pair[0] == 2:
        First = counter[2]
        print("Line2", First)

    elif Pair[0] == 3:
        First = counter[3]
        print("Line3", First)

    elif Pair[0] == 4:
        First = counter[4]
        print("Line4", First)

    elif Pair[0] == 5:
        First = counter[5]
        print("Line5", First)

    elif Pair[0] == 6:
        First = counter[6]
        print("Line6", First)

    elif Pair[0] == 7:
        First = counter[7]
        print("Line1", First)

    else:
        First = 0
        print("None")

    ############################################ ELement 2 of the Pair

    if Pair[1] == 0:
        Second = counter[0]
        print("Line0", Second)

    elif Pair[1] == 1:
        Second = counter[1]
        print("Line1", Second)

    elif Pair[1] == 2:
        Second = counter[2]
        print("Line2", Second)

    elif Pair[1] == 3:
        Second = counter[3]
        print("Line3", Second)

    elif Pair[1] == 4:
        Second = counter[4]
        print("Line4", Second)

    elif Pair[1] == 5:
        Second = counter[5]
        print("Line5", Second)

    elif Pair[1] == 6:
        Second = counter[6]
        print("Line6", Second)

    elif Pair[1] == 7:
        Second = counter[7]
        print("Line1", Second)

    else:
        Second = 0
        print("None")

    if First > Second:
        print("First > Second")
        Challenge = 1
    else:
        print("Second > First")
        Challenge = 0

    print("Challenge = ", Challenge)

    # GPIO.cleanup()
    # counter = [0, 0, 0, 0, 0, 0, 0, 0]
    print("Done")
    return Challenge


#######################################################

host = ''  # Symbolic name meaning all available interfaces
port = 12345  # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
s.bind((host, port))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
Flag = True
Flag2 = True
while True:
    data = conn.recv(1024)
    #if not data:break
    if not not data:
        print("\n Pair = ", chr(data[0]), ",", chr(data[1]), "\n")
        Challenge = 2
        Challenge = puf(int(chr(data[0])), int(chr(data[1])), counter)
        #removeallinterrupt()
        counter = [0,0,0,0,0,0,0,0]
        message = str(Challenge)
        messagebyte = message.encode()
        conn.send(messagebyte)
        Flag = False
        Flag2 = False
        #removeallinterrupt()
conn.close()
GPIO.cleanup()

