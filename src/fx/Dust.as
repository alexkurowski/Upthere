package fx 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  /**
   * ...
   * @author MapiMopi
   */
  public class Dust extends Entity
  {
    public var sprite: Spritemap;
    
    public function Dust(X: int, Y: int, type: String, flip: Boolean = false) 
    {
      x = X;
      y = Y + 4;
      
      switch(type) {
        case "land":
          sprite = new Spritemap(Assets.spr_land_dust, 64, 64, animationEnd);
          sprite.add("anim", [0, 1, 1, 2, 2, 2, 3, 3, 3], 0.3, false);
          break;
        case "stop":
          sprite = new Spritemap(Assets.spr_stop_dust, 64, 64, animationEnd);
          sprite.add("anim", [0, 1, 2, 3,], 0.2, false);
          break;
      }
      
      sprite.alpha = 0.8;
      sprite.flipped = flip;
      graphic = sprite;
      
      layer = 10;
      
      sprite.play("anim");
    }
    
    public function animationEnd(): void
    {
      FP.world.remove(this);
    }
  }

}