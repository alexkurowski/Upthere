package Levels 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Data;
  import net.flashpunk.utils.Input;
  import net.flashpunk.World;
  /**
   * ...
   * @author MapiMopi
   */
  public class MenuOption extends Entity
  {
    public var ID: int;
    public var done: Boolean = false;
    
    public var sprite: Spritemap;
    
    public var use_mouse: Boolean = false;
    public var hovered: Boolean = false;
    
    public var w: World; // parent world pointer
    
    public function MenuOption(_id: int, world: World) 
    {
      ID = _id;
      
      done = false; // TODO: gotta check this shit
      
      setPlace();
      
      sprite = new Spritemap(Assets.spr_level_selecter, 64, 64);
      sprite.add("normal_undone", [0]);
      sprite.add("hovered_undone", [1]);
      sprite.add("normal_done", [2]);
      sprite.add("hovered_done", [3]);
      
      sprite.play("normal_undone"); // TODO: really should check this stuff
      
      graphic = sprite;
      
      w = world;
    }
    
    
    public function setPlace(): void
    {
      
      switch(ID) {
        case 0:
          x = 32;  y = 10;
          break;
        case 1:
          x = 96;  y = 10;
          break;
        case 2:
          x = 160;  y = 10;
          break;
        case 3:
          x = 224;  y = 10;
          break;
        case 4:
          x = 288;  y = 10;
          break;
        case 5:
          x = 352;  y = 10;
          break;
        case 6:
          x = 416;  y = 10;
          break;
        case 7:
          x = 480;  y = 10;
          break;
      }
    }
    
    public function runLevel(): void
    {
      FP.world.removeAll();
      switch(ID) {
        case 0:
          FP.world = new GameWorld0();
          break;
        case 1:
          FP.world = new GameWorld1();
          break;
        case 2:
          FP.world = new GameWorld2();
          break;
        case 3:
          FP.world = new GameWorld3();
          break;
        case 4:
          FP.world = new GameWorld4();
          break;
      }
    }
    
    override public function update():void 
    {
      super.update();
      
      if (use_mouse) { 
        if (Input.mouseX > x && Input.mouseX < x + 64 && Input.mouseY > y && Input.mouseY < y + 64) {
          hovered = true;
          (w as LevelMenuState).caret = ID;
          
          if (Input.mouseDown) {
            runLevel();
          }
        } else {
          if((w as LevelMenuState).caret != ID)
            hovered = false;
        }
      }
      
      if (hovered) {
        if (done)
          sprite.play("hovered_done");
        else
          sprite.play("hovered_undone");
      } else {
        if (done)
          sprite.play("normal_done");
        else
          sprite.play("normal_undone");
      }
    }
  }

}