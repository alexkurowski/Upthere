package  
{
  import flash.geom.Rectangle;
  import fx.FadeOut;
  import net.flashpunk.Entity;
  import net.flashpunk.Graphic;
  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.World;
  import net.flashpunk.FP;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  /**
   * ...
   * @author MapiMopi
   */
  public class PressStartState extends World
  {
    private var bg_entity: Entity;
    
    private var press_text: Text;
    private var press_text_alpha_down: Boolean = true;
    private var press_entity: Entity;
        
    private var fade: FadeOut;
    
    public function PressStartState() 
    {
      // TODO: display a pretty picture here
      
      press_text = new Text("Press any button", 86, 160, null, 8);
      press_entity = new Entity(0, 0, press_text);
      add(press_entity);
      
      
      fade = new FadeOut(0, 0.02, 0xff000000, pressed);
    }
    
    override public function update():void 
    {
      super.update();
      
      if (press_text_alpha_down) {
        if (press_text.alpha >= 0.8)
          press_text.alpha -= 0.01;
        else
          press_text.alpha -= 0.02;
        if (press_text.alpha <= 0.25)
          press_text_alpha_down = false;
      } else {
        if (press_text.alpha >= 0.8)
          press_text.alpha += 0.01;
        else
          press_text.alpha += 0.02;
        if (press_text.alpha >= 1)
          press_text_alpha_down = true;
      }
      
      if (Input.pressed(Key.ANY) || Input.mousePressed) {
        remove(press_entity);
        add(fade);
      }
    }
    
    public function pressed(): void
    {
      FP.world = new LevelMenuState();
    }
        
  }

}