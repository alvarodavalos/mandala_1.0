//Mandala 1.0
//Alvaro Davalos
//Lectura de sensor

int t=100; // variable de tiempo "t" en ms para el tiempo de lectura del sensor
int val; //variable para almacenar la lectura del sensor

void setup() 
{
   Serial.begin(115200); // Comienza la comunicación serial a 115200 baudios
}

void loop() 
{  
  val=analogRead(0)/4; //lee la entrada analógica A0, guarda este valor en la variable val y lo divide entre 4 para tener el valor de 0 a 255
  //val=map(analogRead(0),10,230,254,0); //mapea el valor de val de 10 a 230
  if (val<0) //si el sensor da lecturas erróneas negativas (menores de 0), se convierten a 0
  {
    val=0;
  }
  else if(val>255) //si el sensor da lecturas erróneas mayores que 255, se convierten a 0
  {
    val=255;
  }
  Serial.write(val); //envia a processing la lectura del sensor con un rango de 0 a 255
  // Serial.println(val); //imprime en consola la lectura del sensor con un rango de 0 a 255
   delay(t); //le da un tiempo de retardo de t milisegundos
}
