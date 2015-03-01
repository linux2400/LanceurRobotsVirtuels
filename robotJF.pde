/*  
 code généré pour PROCESSING par UniBot!!! 
 */

//declaration des variables
RobotMartien robotmartien_JF = new RobotMartien();

//methode appelée en thread par le programme principal
void programmeJF()
{
  robotmartien_JF.initialise();

  while (true) {
    while ( ! ( robotmartien_JF.obstacle () ) )
    {
      robotmartien_JF.vitesse(100);
    }

    robotmartien_JF.vitesse(0);
    delay( 2000 );
    robotmartien_JF.vitesse(-50);
    delay( 2000 );
    robotmartien_JF.vitesse(0);
    robotmartien_JF.deplier_bras();
    delay( 4000 );
    robotmartien_JF.replier_bras();
    delay( 1000 );
  }
}

