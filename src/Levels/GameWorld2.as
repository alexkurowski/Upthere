package Levels
{
  import fx.FadeIn;
  import inGame.Map;
  import net.flashpunk.Engine;
  import net.flashpunk.FP;
  import net.flashpunk.World;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;

  public class GameWorld2 extends World
  {
    public var ID: uint;
    
    public var map: Map;
    
    public function GameWorld2() 
    {
      ID = 2;
      
      map = new Map(ID, [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
        0, 0, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 0, 0,
        0, 0, 1,-1,-1,-1, 2, 3, 8,-1,-1,-1,-1,-1,-1,-1,-1, 1, 0, 0,
        0, 0, 1,-1,-1,-1, 1, 1, 1, 1,-1,-1,-1,-1,-1, 2,-1, 1, 0, 0,
        0, 0, 1,-1,-1,-1,-1,-1,-1,-1,-1, 2, 1, 1, 1, 1, 1, 1, 0, 0,
        0, 0, 1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 2, 2,-1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 1,-1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1,-1,-1,-1,-1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1,-1,-1,-1,-1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1,-1,-1, 9,-1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]);
      
      restart();
    }
    
    public function restart():void
    {
      FP.randomSeed = 249;
      
      add(map);
      map.generateMap(this, 1);
      
      //map.makeButton(5, 11, 1, [10, 7, true]);
      
      add(new FadeIn(0, 0.1));
    }
    
    override public function update():void 
    {
      super.update();
      
      if (Input.pressed(Key.R)) {
        removeAll();
        restart();
      }
    }
  }
}