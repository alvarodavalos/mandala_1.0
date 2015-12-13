//Mandala 1.0
//Alvaro Dávalos
//Importante: si la placa de Arduino no está conectada este sketch dará error al buscar el puerto serie

import processing.serial.*; // importa la librería de comunicación serial entre processing y arduino
Serial MiPuerto; // Crea un objeto de la clase Serial llamado "MiPuerto"

int val; // Declaramos una variable de tipo int para almacenar los datos recibidos por el puerto serie
float angle; // variable de ángulo para el círculo
float ang2=PI/36; //variable de ángulo de giro
float radio; // variable de radio para el círculo
//int p; //valor del denominador para dividir la altura de la pantalla
float incang=0.001*PI; // valor para incrementar el angulo y cambiar la forma del mandala
float inc; // valor para incrementar el angulo y cambiar la forma del mandala
int rand1; //variable entera que guardará un valor aleatorio generado
int rand2; //variable entera que guardará un valor aleatorio generado
int rand3; //variable entera que guardará un valor aleatorio generado
int rorden; //variable para ir cambiando aleatoriamente el orden de los bordes de cuadrados, triangulos y elipses
float ang3 = 0; //variable para guardar un angulo para dibujar una espiral
float rd = 0; //variable para guardar un radio para dibujar una espiral
float ang4=10; //para bordes de formas

int centroX; //variables para puntos móviles
int centroY;
float x;
float y;
float x5,y5,x6,y6,x7,y7;

float angulo=PI; //variable de ángulo de giro

//variables de color que cambiarán de acuerdo al sensor
color c1;
color c2;
color c3;

//variables de color para tres paletas que se usarán:
//amanecer
color rojo = color(255,0,0);
color amarillo = color(255, 255, 0);
color rosado = color(255, 204, 204);

//trébol
color verde = color(0, 153, 0);
color verdec = color(204, 255, 102);
color verdea = color(204, 235, 204);

//marino
color azul = color(0, 51, 204);
color celeste = color(102, 204, 255);
color violeta = color(204, 214, 245);




void setup() 

{
  colorMode(RGB);
  size(displayWidth, displayHeight); // define el tamaño de la ventana para pantalla completa
  frameRate(60); //define el numero de tramas por segundo (60 por defecto)
  smooth(); // función de suavizado de la imagen
  background(0); // define el color de fondo negro
  
  println(Serial.list()); //muestra los puertos seriales disponibles
  String puertoArduino = Serial.list()[1]; // define una variable de tipo string llamada puertoArduino que guardará el número del puerto que se usará para la comunicación (COM1)
  MiPuerto = new Serial(this, puertoArduino, 115200); // crea una instancia del objeto Serial, llamada MiPuerto, con el número de puerto (COM1) y el valor de la velocidad de transmisión (115200 baudios)
}




void draw() 
{
  
  serialCom();
  defineVariables ();

  colorSensor();
  colorea(); 
  
  dibujaEspiral();
  dibujaRadio();
  bordeElipses () ;
  bordeTriangulos ();
  bordeCuadrados();
  dibujaBorde ();
  separacionPetalo();
  dibujaPetalo1();
  dibujaPetalo2();
  dibujaPetalo3();
  //pintaPunto4();
  circulosConcentricos();
  formasFijas();
  
  iteracion ();
}



void serialCom() //función para la comunicación serial
{
if ( MiPuerto.available() > 0) // Si hay datos que llegan de los sensores conectados a arduino
    { 
    val = MiPuerto.read(); // lee el puerto serial y almacena los datos recibidos en val //de 9 a 220
    println("val=",val); //muestra en consola de processing el valor de val recibido
    //radio = map(val, 0, 255, 0, height/2 ); // transforma ese valor para convertirlo en el radio principal del circulo
    }
}



void defineVariables () //función para definir variables
{
  rand1=int(random(0, 10)); //genera un numero aleatorio entre 1 y 9
  rand2=int(random(140, 256)); //genera un numero aleatorio entre 0 y 255 
  rand3=int(random(1, 4)); //genera un numero aleatorio entre 1 y 3
  rorden=int(random(1, 7)); //genera un numero aleatorio entre 1 y 6
  //Variable para sustituir por los datos de Arduino
  //val= int (random (0, 60))+rand1; 
  radio = map(val, 0, 60, 0, height/2); //ESTE ES EL VALOR DEL SENSOR
  //VARIABLES NUEVAS. CENTRO CIRCULO
  centroX = width/2; //define una variable en X para el centro del circulo P1
  centroY = height/2; //define una variable en Y para el centro del circulo P1
  //VARIABLES NUEVAS. PUNTO MOVIL
  x = centroX + cos(angle) * height/3;
  y = centroY + sin(angle) * height/3;
  
  x5 = centroX + cos(ang4) * height/8; //borde de elipses
  y5 = centroY + sin(ang4) * height/8;
  
  x6 = centroX + cos(ang4*-1) * height/5; //borde de triangulos
  y6 = centroY + sin(ang4*-1) * height/5;
  
  x7 = centroX + cos(ang4) * height/3.5; //borde de cuadrados
  y7 = centroY + sin(ang4) * height/3.5;
}


void colorSensor()
{
//Condiciones para variar la combinacion de colores de todo el mandala de acuerdo a la lectura del sensor 

if (val>10 && val<=80) //paleta de colores amanecer 
{
c1=rojo;
c2=amarillo;
c3=rosado;
}

if (val>80 && val<=150)  //paleta de colores trébol
{
c1=verde;
c2=verdec;
c3=verdea;
}

if (val>150) //paleta de colores marino
{
c1=azul;
c2=celeste;
c3=violeta;
}
}


void colorea() 
{
  //CONDICIONALES COLORES DE TRAZO Y RELLENO. 
  if (rand3==1)
  {
    stroke(c1); //hace la linea del primer color de la paleta elegida
    fill(c1); //pinta el objeto con el primer color de la paleta elegida
  } else if (rand3==2)
  {
    stroke(c2);  //hace la linea del segundo color de la paleta elegida
    fill(c2);  //pinta el objeto con el segundo color de la paleta elegida
  } else if (rand3==3)
  {
    stroke(c3);  //hace la linea del tercer color de la paleta elegida
    fill(c3);  //pinta el objeto con el tercer color de la paleta elegida
  }
}



void dibujaRadio () 
{
  line(centroX, centroY, x, y); //dibuja el radio principal
}




void dibujaBorde () 
{
  strokeWeight(1);
  stroke(255,255,255,80); //le da un borde a la elipse
  ellipse(x, y, 11, 11); // con las mismas coordenadas que la linea principal para que sea el borde el mandala y un tamaño fijo de 11x11
  ellipse(x, y, 4, 4); // dibuja otra elipse más pequeña encima de la anterior
}


void bordeElipses () 
{
  strokeWeight(1);
  stroke(255,255,255,80); //le da un borde a la elipse
  ellipse(x5, y5, 18, 18); //dibuja una elipse
  ellipse(x5, y5, 7, 7); //dibuja otra elipse más pequeña encima
}

void bordeTriangulos ()
{
strokeWeight(1);
stroke(255,255,255,80); //le da un borde
triangle(x6,y6,x6+6,y6+13,x6-6,y6+13); //dibuja el triangulo
}


void bordeCuadrados()
{
rectMode(CENTER);
strokeWeight(1);
stroke(192, 239, 250, 80); //le da un borde
rect(x7,y7,9,9); //dibuja un cuadrado
rect(x7,y7,2,2); //dibuja un cuadrado mas pequeño encima
}


void separacionPetalo () 
{
  //DIBUJO PETALO
  //inc=abs(sin(ang2))*70; ORIGINAL
  inc=abs(sin(ang2))*50; //PRUEBA
  //println ("inc=  "+inc);
  //strokeWeight(2);
  stroke(255); //color del punto
}



void dibujaPetalo1 () 
{
  pushMatrix (); 
  translate (x, y); //traslada el eje de coordenadas al borde del mandala
  strokeWeight(2);
  stroke (c1);
  point(cos(angulo)*50, sin(angulo)*50); //dibuja el punto
  angulo=angulo+(PI/72);
  //println (angulo);
  popMatrix(); //vuelve el eje de coordenadas al centro
}



void dibujaPetalo2 () 
{
  strokeWeight(2);
  stroke (c2);
  pushMatrix ();
  translate (x, y); //traslada el eje de coordenadas al borde del mandala
  point(cos(angulo)*30, sin(angulo)*100); //dibuja el punto
  angulo=angulo+(PI/360);
  //println (angulo);
  popMatrix(); //vuelve el eje de coordenadas al centro
}



void dibujaPetalo3 () 
{
  strokeWeight(2);
  stroke (c3);
  pushMatrix ();
  translate (x, y); //traslada el eje de coordenadas al borde del mandala
  point(cos(angulo)*100, sin(angulo)*100);
  angulo=angulo+(PI/360);
  //println (angulo);
  popMatrix();
}



void pintaPunto4 () 
{ 
  stroke (c1);
  point(x+inc, y); //dibuja un borde de puntos
}



void circulosConcentricos()
{
//circulos concentricos, con un ciclo for dibuja un punto que crea circulos cada vez más pequeños sobre el circulo grande
for (int i=3; i<=11; i++) 
{
float xa = centroX + cos(angle) * height/i; //define la posición en X del punto en funcion del alto de la ventana
float ya = centroY + sin(angle) * height/i; //define la posición en Y del punto
stroke(c1); //color del punto que varia en funcion de los sensores y en cada ciclo va matizando el color
strokeWeight(2); //grosor del punto
point(xa,ya); //punto 
}
}


void dibujaEspiral()
{
//dibuja espiral de puntos partiendo desde el centro
strokeWeight(2);
point(width/2 + cos(ang3) * rd, height/2 + sin(ang3) * rd);
ang3=ang3+0.05;
rd=rd+0.1;
}


void formasFijas()
{
//dibuja elipses, triangulos y rectangulos que se mantienen fijos

strokeWeight(1);
ellipseMode(CENTER); 
noFill();
stroke(255);
ellipse(centroX,centroY,width/3,height/4); //dibuja elipse horizontal
ellipse(centroX,centroY,width/6.5,height/1.7); //dibuja elipse vertical

rectMode(CENTER);
rect(centroX,centroY,width/4,height/2.5); //dibuja cuadrado
rect(centroX,centroY,width/5,height/3); //dibuja cuadrado más pequeño

/*scale(0.5); translate push matrix y pop matrix
triangle(width/2,35,width*0.7,height*0.8,width*0.3,height*0.8);
triangle(width/2,height*0.95,width*0.7,height*0.3,width*0.3,height*0.3);*/


}



void iteracion () 
  {
  //ITERACION
  angle=angle+incang; //va incrementando el ángulo para que todas las formas vayan moviendose en circulo
  ang2=ang2+(PI/2); //incrementa el angulo para el borde de petalos
  if (ang2>=(TWO_PI)) //condición para reiniciar variables de giro si se completan 360 grados
  {
  ang2=0;
  ang4=ang4+2;
  }
  //println ("ang2=  "+ang2);
  }

void keyPressed()   // para guardaruna captura de pantalla al presionar una tecla cualquiera
{
    save("imagen"+frameCount+".jpg");
}
