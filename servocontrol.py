import serial
import time

# Could we guess the name of the serial?
ser = serial.Serial('/dev/ttyACM1',9600)
time.sleep(3)

while True:
	# Direct user input
	# At some stage, we'd want to add some smarts here
	input = raw_input("Message to send (1-4):")
	if input in ['1','2','3','4']:
		ser.write(input)
		print "Sending serial data"+str(input)
	else:
		if(ser.isOpen()):
			print "Serial connection is still open, closing it ..."
			ser.close()
			break;

print "Finished"

