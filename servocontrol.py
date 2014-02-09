import sys
import serial
import time

# Could we guess the name of the serial?
possibleDevices = ['/dev/ttyACM0','/dev/ttyACM1','/dev/ttyACM2','/dev/ttyACM3']
out = ""

# How about loading the PDE script with ino here?

for device in possibleDevices:
	try:
		ser = serial.Serial(device,9600)
		print "Connecting to ",device," ..."
		# Needed for the serial connection to initialise properly
		time.sleep(2)
		break
	except:
		print "Failed to connect on ",device

def closeSerialConnection ():
	if(ser.isOpen()):
		print "Closing serial connection ..."
		#ser.flush()
		time.sleep(1)
		ser.close()	

def controlArduino (input):
	if input in ['1','2','3','4','5','6','7','8','9']:
		print "Sent serial data: "+str(input)
		ser.write(input)
		print "Waiting for response .."
		while True:
			out = ser.readline().strip('\n').strip('\r')
			if out:
				print "Received response (",str(out),")"
				break

if len(sys.argv)>1:
	# Arguments on the command line? => we execute only the expected command
	controlArduino(str(sys.argv[1]))
	closeSerialConnection()
else:
	# No arguments on the command line? => we start the interactive mode
	while True:
		# Repeated direct user input
		inputKey = raw_input("Message to send to servo1 (1-4), servo2 (5-8) or receive (9):")
		controlArduino(inputKey)
		if inputKey not in ['1','2','3','4','5','6','7','8','9']:
			closeSerialConnection()
			break

print "Finished"

