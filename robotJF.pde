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
robotmartien_JF.avance();
delay( 2500 );
robotmartien_JF.arrete();
delay( 5000 );
robotmartien_JF.deplier_bras();
delay( 1000 );
robotmartien_JF.recule();
delay( 2500 );
if (robotmartien_JF.brasTouche())
{
robotmartien_JF.recule();
delay( 1000 );
robotmartien_JF.replier_bras();
delay( 1 );
}

}
}


