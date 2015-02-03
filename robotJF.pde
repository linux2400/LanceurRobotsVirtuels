void programmeJF() {
  
  // bloc des variables
  RobotMartien robotmartien = new RobotMartien();
  int toto = 0;

  // bloc initialisation
  robotmartien.initialise(-150.0, -50, 0.0 , 60.0);
  
  while(true) {
    // bloc de la boucle principale
    
   robotmartien.vitesse(50);
   delay( 2000 );
   robotmartien.tourne(60);
   delay( 1000 );
   robotmartien.tourne(0);

  }  
}

