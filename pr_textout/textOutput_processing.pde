// declare font usage
PFont font;
// import serial library
import processing.serial.*;
// create an instance of serial class
Serial myPort;

// *****************
// Set as you like! Interval's unit is "min"!
int interval = 1; // unit = min
int samplenumber = 16;
// Set starting time!
int _hour = 13;
int _min = 58;
// *****************

// variable declaration
String state;
String data;
int[] value = new int[samplenumber * 2 + 1];
int[] ppfd = new int[samplenumber + 1];
// PC time variables
String time;
int yyear;
int mmonth;
int dday;
int hhour;
int mmin;
int ssec;
int remain; // unit = min
int elapse; // unit = min
// use PrintWriter class
PrintWriter output;

// setup
void setup(){
	size(200,200);
	frameRate(1);
	font = loadFont("Calibri-12.vlw");
	textFont(font);
	textAlign(RIGHT);
	state = "Running";
	// set serial port
	myPort = new Serial(this, "COM5", 9600);
	// set serial buffer size
	myPort.buffer(2 * samplenumber);
	// create new text file
	output = createWriter("ppfd.txt");
	// Calculate remaining time [min]
	remainingTime();
} 

// draw
void draw(){
	background(0);
	// call obtanTime()
	obtainTime();
	view();
	// send logging signal
	if(((elapse - remain) >= 0) && ((elapse - remain) % interval == 0) && (ssec == 0)){
		myPort.write(samplenumber);
	}
	// read data and calculate ppfd
	if(myPort.available() == 2 * samplenumber){
		readData();
		obtainTime();
		output.println(time + ":00" + data);
	}
}
	
// Calculate remaining time [min]
void remainingTime(){
	obtainTime();
	remain = 60 * (_hour - hhour) + (_min - mmin);
}

// calculate remaining time
void obtainTime(){
	yyear = year();
	mmonth = month();
	dday = day();
	hhour = hour();
	mmin = minute();
	ssec = second();
	elapse = millis() / 60000 + 1; // unit = min
	time = yyear + "/" + mmonth + "/" + dday + " " + nf(hhour,2) + ":" + nf(mmin, 2);
}

// set data from arduino into array
void readData(){
	data = "";
	for(int i = 1; i <= samplenumber; i++){
		value[2 * i - 1] = myPort.read();
		value[2 * i] = myPort.read();
		ppfd[i] = calPpfd(i, value[2 * i - 1], value[2 * i]);
		data = data + "," + ppfd[i];
	}
        myPort.clear();
}

// create interface window
void view(){
	text(state, 170, 10);
        text("Interval [min] = " + interval, 170, 40);
	text("Time = " + time + ":" + nf(ssec, 2), 170, 70);
}

// change state "Running" or "Stop" depend on press count
void mousePressed(){
	// clear buffer
	state = "Done";
	myPort.clear();
	// writes the remaining data to the file
	output.flush();
	// finishes the file
	output.close();
	// Stops the program
	exit();
}

// caluculate ppfd
int calPpfd(int samnum, int x, int y){
	float val;
	float voltage;
	float a;
	float b;
	int ppfd;
	// Convert 2 bytes to float
	val = 256 * x + y;
	// change value into voltage
	voltage = map(val, 0, 1023, 0, 5000);
	// input sensor parameter
	switch(samnum){
		case 1:
			a = 1;
			b = 0;
			println("value: " + val + ", voltage: " + voltage);
			break;
		case 2:
			a = 1;
			b = 0;
			break;
		case 3:
			a = 1;
			b = 0;
			break;
		case 4:
			a = 1;
			b = 0;
			break;
		case 5:
			a = 1;
			b = 0;
			break;
		case 6:
			a = 1;
			b = 0;
			break;
		case 7:
			a = 1;
			b = 0;
			break;
		case 8:
			a = 1;
			b = 0;
			break;
		case 9:
			a = 1;
			b = 0;
			break;
		case 10:
			a = 1;
			b = 0;
			break;
		case 11:
			a = 1;
			b = 0;
			break;
		case 12:
			a = 1;
			b = 0;
			break;
		case 13:
			a = 1;
			b = 0;
			break;
		case 14:
			a = 1;
			b = 0;
			break;
		case 15:
			a = 1;
			b = 0;
			break;
		case 16:
			a = 1;
			b = 0;
			break;
		default:
			a = 1;
			b = 0;
			break;
	}
	ppfd = int(a*voltage + b);
	return ppfd;
}
