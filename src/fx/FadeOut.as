package fx
{  
  import flash.geom.Rectangle;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Canvas;
  /**
   * ...
   * @author MapiMopi
   */
  public class FadeOut extends Entity
  {
    private var fade_canvas: Canvas;
    
    private var delay: int = 0;
    private var fade_speed: Number;
    private var fade_function: Function;
    
    public function FadeOut(wait: int = 0,speed: Number = 0.01, color: uint = 0xff000000, OnComplete: Function = null)
    {
      fade_canvas = new Canvas(640, 480);
      fade_canvas.fill(new Rectangle(0, 0, 640, 480), color, 1);
      fade_canvas.alpha = 0;
      graphic = fade_canvas;
      
      delay = wait;
      
      fade_speed = speed;
      
      fade_function = OnComplete;
      
      layer = -1000;
    }
    
    override public function update():void 
    {
      super.update();
      if (delay > 0) {
        delay--;
      } else {
        if (fade_canvas.alpha < 1) { 
          fade_canvas.alpha += fade_speed;
        } else {
          if (fade_function != null) { 
            fade_function();
          }
          FP.world.remove(this);
        }
      }
    }
    
  }

}