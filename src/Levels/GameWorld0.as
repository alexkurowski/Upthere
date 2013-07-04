package Levels
{
  import fx.FadeIn;
  import inGame.Map;
  import net.flashpunk.Engine;
  import net.flashpunk.FP;
  import net.flashpunk.World;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;

  public class GameWorld0 extends World
  {
    public var ID: uint;
    
    public var map: Map;
    
    public function GameWorld0() 
    {
      ID = 0;
      
      map = new Map(ID, [
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1,-1, 3,-1,-1,-1,-1, 1, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1, 3, 3,-1,-1,-1,-1, 1, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1, 3,-1,-1,-1,-1, 9, 1, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 1, 1, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 1,-1,-1,-1,-1,-1,-1, 2,-1,-1,-1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 8,-1,-1, 2,-1,-1, 2,-1,-1,-1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 1, 1,-1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]);
      
      restart();
    }
    
    public function restart():void
    {
      FP.randomSeed = 69;
      
      add(map);
      map.generateMap(this, 0);
      
      map.makeButton(5, 11, 1, [10, 7, true]);
      
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