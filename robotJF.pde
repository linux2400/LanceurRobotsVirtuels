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
delay( 1000 );
robotmartien_JF.recule();
delay( 500 );
robotmartien_JF.arrete();

robotmartien_JF.deplier_bras();
robotmartien_JF.replier_bras();
//robotmartien_JF.tourneDroite();
robotmartien_JF.avance();
delay( 3000 );

}
}


