PFont font;  // declare font usage
import processing.serial.*;  // import serial library
Serial myPort;  // create an instance of serial class

// *****************
// Set as you like! Interval's unit is "min"!
int interval = 5; // unit = min
int samplenumber = 16;
// Set starting time!
int _hour = 0;
int _min = 0;
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
int remain;  // unit = min
int elapse;  // unit = min
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
	myPort = new Serial(this, "COM5", 9600);  // set serial port
	myPort.buffer(2 * samplenumber);  // set serial buffer size
	output = createWriter("ppfd.txt");  // create new text file
	remainingTime();  // Calculate remaining time [min]
} 

void draw(){
	background(0);
	obtainTime();  // call obtanTime()
	view();
	if(((elapse - remain) >= 0) && ((elapse - remain) % interval == 0) && (ssec == 0)){
		myPort.write(samplenumber);  // send logging signal
	}
	if(myPort.available() == 2 * samplenumber){
		readData();  // read data and calculate ppfd
		obtainTime();
		output.println(time + ":00" + data);
	}
}
	
void remainingTime(){  // Calculate remaining time [min]
	obtainTime();
	remain = 60 * (_hour - hhour) + (_min - mmin);
}

void obtainTime(){  // calculate remaining time
	yyear = year();
	mmonth = month();
	dday = day();
	hhour = hour();
	mmin = minute();
	ssec = second();
	elapse = millis() / 60000 + 1;  // unit = min
	time = yyear + "/" + mmonth + "/" + dday + " " + nf(hhour,2) + ":" + nf(mmin, 2);
}

void readData(){  // set data from arduino into array
	data = "";
	for(int i = 1; i <= samplenumber; i++){
		value[2 * i - 1] = myPort.read();
		value[2 * i] = myPort.read();
		ppfd[i] = calPpfd(i, value[2 * i - 1], value[2 * i]);
		data = data + "," + ppfd[i];
	}
        myPort.clear();
}

void view(){  // create interface window
	text(state, 170, 10);
        text("Interval [min] = " + interval, 170, 40);
	text("Time = " + time + ":" + nf(ssec, 2), 170, 70);
}

void mousePressed(){  // change state "Running" or "Stop" depend on press count
	state = "Done";  // clear buffer
	myPort.clear();
	output.flush();  // writes the remaining data to the file
	output.close();  // finishes the file
	exit();  // Stops the program
}

int calPpfd(int samnum, int x, int y){  // caluculate ppfd
	float val;
	float voltage;
	float a;
	float b;
	int ppfd;
	val = 256 * x + y;  // Convert 2 bytes to float
	voltage = map(val, 0, 1023, 0, 5000);  // change value into voltage
	switch(samnum){  // input sensor parameter
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
