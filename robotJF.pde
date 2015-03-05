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
while ( !( robotmartien_JF.obstacle() ) )
{
robotmartien_JF.avance();
}

robotmartien_JF.arrete();
robotmartien_JF.deplier_bras();
delay( 1000 );
robotmartien_JF.replier_bras();
delay( 1000 );
robotmartien_JF.recule();
robotmartien_JF.tourneDroite();
delay( 2000 );

}
}


