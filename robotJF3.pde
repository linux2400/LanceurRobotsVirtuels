/*
 code généré pour PROCESSING par UniBot!!! 
*/

//declaration des variables
RobotMartien robotmartien_JF3 = new RobotMartien();


//methode appelée en thread par le programme principal
void programmeJF3()
{
robotmartien_JF3.initialise();


while (true){
if (robotmartien_JF3.obstacle())
{
robotmartien_JF3.vitesse(0);
delay( 1000 );
robotmartien_JF3.tourne(20);
robotmartien_JF3.vitesse(-100);
delay( 1500 );
robotmartien_JF3.vitesse(0);
robotmartien_JF3.tourne(0);
delay( 1000 );
}
else
{
robotmartien_JF3.vitesse(100);
}

}
}


