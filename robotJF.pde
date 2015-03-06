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
delay( 1000 );
robotmartien_JF.arrete();
delay( 1000 );
robotmartien_JF.recule();
delay( 1000 );
robotmartien_JF.arrete();
delay( 1000 );
robotmartien_JF.avanceDroite();
delay( 1000 );
robotmartien_JF.avanceGauche();
delay( 1000 );
robotmartien_JF.arrete();
delay( 1000 );
robotmartien_JF.reculeDroite();
delay( 1000 );
robotmartien_JF.reculeGauche();
delay( 1000 );
robotmartien_JF.arrete();
delay( 1000 );
robotmartien_JF.deplier_bras();
robotmartien_JF.replier_bras();

}
}


