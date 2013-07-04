package inGame 
{
  import flash.geom.Rectangle;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  /**
   * ...
   * @author MapiMopi
   */
  public class Cloud extends Entity
  {
    public var sprite: Image;
    
    public var _x: Number;
    
    public var r: int;
    
    public function Cloud() 
    {
      r = FP.rand(4);
      sprite = new Image(Assets.spr_cloud, new Rectangle(0, 128 * r, 256, 128));
      sprite.alpha = 0.4 + FP.rand(5) * 0.1;
      
      x = 640;
      y = 40 + FP.rand(16) * sprite.alpha * 10;
      //y = 40 + FP.rand(240);
      
      graphic = sprite;
      
      _x = -sprite.alpha * 2;
      
      layer = 190 - sprite.alpha * 10;
    }
    
    override public function update():void 
    {
      super.update();
      
      x += _x;
      
      if (x < -sprite.width) {
        FP.world.remove(this);
      }
    }
  }

}