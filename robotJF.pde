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
robotmartien_JF.deplier_bras();
if (robotmartien_JF.brasTouche())
{
robotmartien_JF.recule();
delay( 2000 );
}
else
{
robotmartien_JF.reculeDroite();
delay( 2000 );
}
robotmartien_JF.arrete();
robotmartien_JF.replier_bras();
if (robotmartien_JF.brasTouche())
{
robotmartien_JF.reculeGauche();
delay( 1000 );
}

}
}


