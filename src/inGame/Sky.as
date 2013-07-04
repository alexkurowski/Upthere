package inGame 
{
  import flash.geom.Rectangle;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Graphic;
  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.graphics.Image;
  /**
   * ...
   * @author MapiMopi
   */
  public class Sky extends Entity
  {
    public var sky_canvas: Canvas;
    
    public var colors: Array;
    public var cur_color: uint;
    
    public var step: int;
    public const MAX_STEP: int = 10;
    
    public var next_color: int;
    public const NEXT_COLOR: int = 100;
    
    public var god_delay: int = 0;
    public const GOD_DELAY: int = 50;
    public var cloud_delay: int = 0;
    public const CLOUD_DELAY: int = 50;
    public var star_delay: int = 0;
    public const STAR_DELAY: int = 20;
    
    public var r: Number;
    public var g: Number;
    public var b: Number;
    
    public function Sky() 
    {
      colors = new Array(0xcdecfe, 0x9fb7ff, 0x6d60aa, 0x301c43);
      cur_color = 0;
      
      sky_canvas = new Canvas(640, 480);
      sky_canvas.fill(new Rectangle(0, 0, 640, 480), colors[cur_color], 1);
      
      graphic = sky_canvas;
      
      layer = 1000;
      
      step = MAX_STEP;
      next_color = 0;
    }
    
    override public function update():void 
    {
      super.update();
      
      step--;
      
      god_delay--;
      cloud_delay--;
      star_delay--;
      
      if (cur_color == 0) {
        if (FP.rand(100) == 55 && god_delay <= 0) {
          FP.world.add(new Godray());
          god_delay = GOD_DELAY;
        }
      }
      
      if (FP.rand(600) == 249 && cloud_delay <= 0) { // TODO: gotta tweak this shit out
        FP.world.add(new Cloud());
        cloud_delay = CLOUD_DELAY;
      }
      
      if (cur_color == 2) {
        if (FP.rand(20) == 8 && star_delay <= 0) {
          FP.world.add(new Star(this));
          star_delay = STAR_DELAY;
        }
      }
      
      if (step <= 0) {
        sky_canvas.drawRect(new Rectangle(0, 0, 640, 480), colors[(cur_color < 3 ? cur_color + 1 : 0)], 0.05);
        
        step = MAX_STEP;
        
        next_color++;
        
        if (next_color == NEXT_COLOR) {
          next_color = 0;
          
          cur_color++;
          if (cur_color >= 4) cur_color = 0;
          
          sky_canvas.fill(new Rectangle(0, 0, 640, 480), colors[cur_color], 1);
        }
      }
    }
    
  }

}