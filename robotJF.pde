/*
 code généré pour PROCESSING par UniBot!!! 
*/

//declaration des variables
RobotMartien robotmartien_JF = new RobotMartien();


//methode appelée en thread par le programme principal
void programmeJF()
{
robotmartien_JF.initialise();


while (true){
if (robotmartien_JF.obstacle())
{
robotmartien_JF.vitesse(0);
robotmartien_JF.deplier_bras();
delay( 1000 );
robotmartien_JF.tourne(20);
robotmartien_JF.vitesse(-100);
delay( 1500 );
robotmartien_JF.vitesse(0);
robotmartien_JF.tourne(0);
delay( 1000 );
}
else
{
robotmartien_JF.vitesse(0);
}

}
}


