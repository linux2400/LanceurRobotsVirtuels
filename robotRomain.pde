
void programmeRomain() {
  RobotMartien robot = new RobotMartien();
  robot.initialise(0.0, -30.0, 0.0 , 0.);
  
  while(true) {
    robot.vitesse(50); // defini la vitesse du robot
    delay(2000); // attend avant le prochain ordre
    robot.tourne(PI/4.0);
    delay(2000);
    robot.vitesse(0);
    delay(1000);
    robot.tourne(0.0);
    delay(1000);
    robot.vitesse(25); // defini la vitesse du robot
    delay(2000); // attend avat le prochain ordre
    robot.tourne(PI/4.0);
    delay(1000);
    robot.vitesse(100);
    delay(3000);
    robot.vitesse(0);
    delay(1000);
    robot.tourne(0.0);
    delay(1000);
    robot.tourne(-PI/4.0);
    robot.vitesse(50);
    delay(1000);
    robot.vitesse(100);
    delay(1000);
    robot.vitesse(0);
    delay(1000);
    robot.tourne(PI/4.0);
    robot.vitesse(-25);
    delay(4000);
    robot.tourne(0.0);
  }  
}

