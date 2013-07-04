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
  public class Godray extends Entity
  {
    public var sprite: Image;
    public var lifetime: int;
    
    public var _x: int; // move speed
    
    public function Godray() 
    {
      y = 0;
      x = 40 + FP.rand(240);
      
      _x = 0.4 + FP.rand(40)*0.01;
      
      sprite = new Image(Assets.spr_godray, new Rectangle(160 * FP.rand(3), 0, 160, 480));
      sprite.alpha = 0;
      graphic = sprite;
      
      layer = 200;
      
      lifetime = 200;
    }
    
    override public function update():void 
    {
      super.update();
      
      x -= _x;
      lifetime--;
      
      if (lifetime > 0) {
        if (sprite.alpha < 1)
          sprite.alpha += 0.02;
      } else {
        sprite.alpha -= 0.02;
        if (sprite.alpha <= 0) {
          FP.world.remove(this);
        }
      }
    }
    
  }

}