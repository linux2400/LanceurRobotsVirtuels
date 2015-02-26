/*
 code généré pour PROCESSING par UniBot!!! 
*/

//declaration des variables
RobotMartien robotmartien_JF2 = new RobotMartien();


//methode appelée en thread par le programme principal
void programmeJF2()
{
robotmartien_JF2.initialise();


while (true){
robotmartien_JF2.deplier_bras(); 
if (robotmartien_JF2.obstacle())
{
robotmartien_JF2.vitesse(0);
delay( 1000 );
robotmartien_JF2.tourne(20);
robotmartien_JF2.vitesse(-100);
delay( 1500 );
robotmartien_JF2.vitesse(0);
robotmartien_JF2.tourne(0);
delay( 1000 );
}
else
{
robotmartien_JF2.vitesse(100);
}

}
}


