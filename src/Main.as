package 
{
  import net.flashpunk.*;
  
  /**
   * ...
   * @author MapiMopi
   */
  public class Main extends Engine
  {
    
    public function Main():void 
    {
      super(640, 480, 60, true);
      
      //FP.console.enable();
      FP.screen.color = 0xff242424;
            
      FP.randomizeSeed();
      
      FP.world = new PressStartState();
    }
    
  }
  
}