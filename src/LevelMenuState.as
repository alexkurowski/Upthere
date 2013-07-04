package  
{
  import fx.FadeIn;
  import fx.FadeOut;
  import Levels.*;
  import net.flashpunk.Entity;
  import net.flashpunk.Graphic;
  import net.flashpunk.graphics.Canvas;
  import flash.geom.Rectangle;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.World;
  import net.flashpunk.FP;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  /**
   * ...
   * @author MapiMopi
   */
  public class LevelMenuState extends World
  {
    
    private var control: Boolean = true; // is player able to control the menu
    private var next_level: int; // this var is set after Z being pressed
    public var caret: int; // represents which level is currently hovered by keyboard control
    private var fade: FadeOut;
    
    private var prev_mouseX: int;
    private var prev_mouseY: int;
    
    private var level0: Entity;
    
    private var options: Array;
    private var use_mouse: Boolean = false;;
    
    private var opt: MenuOption;
    
    public function LevelMenuState(_caret: int = 0) 
    {
      options = new Array;
      
      options.push(add(new MenuOption(0, this)));
      options.push(add(new MenuOption(1, this)));
      options.push(add(new MenuOption(2, this)));
      options.push(add(new MenuOption(3, this)));
      options.push(add(new MenuOption(4, this)));
      
      
      caret = _caret;
      (options[caret] as MenuOption).hovered = true;
      
      fade = new FadeOut(0, 0.02, 0xff000000, change_level);
      add(new FadeIn(0, 0.1));
      
      prev_mouseX = Input.mouseX;
      prev_mouseY = Input.mouseY;
    }
    
    override public function update():void 
    {
      super.update();
      
      if (control) {
        // All the menu control here
        if ((Input.mouseX != prev_mouseX || Input.mouseY != prev_mouseY) && !use_mouse) {
          setMouse(true);
        }
        
        // TODO: proper menu when options are done
        if (Input.pressed(Key.DOWN)) {
          //caret += 10; // 10 is row size
          setMouse(false);
        }
        
        if (Input.pressed(Key.UP)) {
          //caret -= 10; // row size
          setMouse(false);
        }
        
        if (Input.pressed(Key.LEFT)) {
          if (caret > 0) {
            caret--;
          } else {
            caret = options.length - 1;
          }
          setMouse(false);
        }
        
        if (Input.pressed(Key.RIGHT)) {
          if (caret < options.length - 1) {
            caret++;
          } else {
            caret = 0;
          }
          setMouse(false);
        }
        
      }
      
      if (Input.pressed(Key.Z) || Input.pressed(Key.ENTER)) {
        (options[caret] as MenuOption).runLevel();
      }
      
      prev_mouseX = Input.mouseX;
      prev_mouseY = Input.mouseY;
    }
    
    public function setMouse(mouseInput: Boolean): void
    {
      if (mouseInput && mouseInput == use_mouse) {
        return;
      }
      if (mouseInput) { 
        for each (opt in options) {
          opt.use_mouse = true;
        }
      } else {
        for each (opt in options) {
          opt.use_mouse = false;
          opt.hovered = false;
        }
        (options[caret] as MenuOption).hovered = true;
      }
      use_mouse = mouseInput;
    }
    
    public function change_level(): void
    {
      removeAll();
      switch(next_level) {
        case 0:
          FP.world = new GameWorld0();
          break;
        default:
          FP.console.log("You shouldn't be here");
      }
    }
    
  }

}