/*
 code généré pour PROCESSING par UniBot!!! 
*/

//declaration des variables
RobotMartien robotmartien_JF4 = new RobotMartien();


//methode appelée en thread par le programme principal
void programmeJF4()
{
robotmartien_JF4.initialise();


while (true){
if (robotmartien_JF4.obstacle())
{
robotmartien_JF4.vitesse(0);
delay( 1000 );
robotmartien_JF4.tourne(20);
robotmartien_JF4.vitesse(-100);
delay( 1500 );
robotmartien_JF4.vitesse(0);
robotmartien_JF4.tourne(0);
delay( 1000 );
}
else
{
robotmartien_JF4.vitesse(100);
}

}
}


