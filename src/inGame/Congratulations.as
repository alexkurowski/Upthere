package inGame 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  /**
   * ...
   * @author MapiMopi
   */
  public class Congratulations extends Entity
  {
    private var levelID: int;
    
    public var text: Entity;
    
    public function Congratulations(id: int) 
    {
      levelID = id;
      
      x = 0;
      y = 0;
      
      graphic = new Image(Assets.spr_win_screen);
      
      text = new Entity(40, 80, new Text("FUCK MY LIFE"));
      text.layer = -10;
      FP.world.add(text);
    }
    
    override public function update():void 
    {
      super.update();
      
      if (Input.pressed(Key.X)) {
        FP.world.removeAll();
        //FP.world = new LetterWorld(levelID);
        FP.world = new LevelMenuState(levelID);
      }
      if (Input.pressed(Key.Z)) {
        // TODO: translate to next level
      }
      if (Input.pressed(Key.ESCAPE)) {
        // TODO: translate to level menu state
      }
    }
  }
}