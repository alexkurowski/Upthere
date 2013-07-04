package inGame 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  /**
   * ...
   * @author MapiMopi
   */
  public class Switchable extends Entity
  {
    public var sprite: Spritemap;
    
    public var color: int;
    
    public var solid: Boolean; // if block is standable
    public var activated: Boolean; // if block should be standable
    public var originalActivated: Boolean;
    
    public function Switchable(X: int, Y: int, col: int, Active: Boolean) 
    {
      x = X * 32;
      y = Y * 32;
      
      color = col;
      
      solid = Active;
      activated = Active;
      originalActivated = Active;
      
      sprite = new Spritemap(Assets.spr_buttons, 32, 32);
      sprite.frame = 11 + color + (Active ? 4 : 0);
      graphic = sprite;
      
      type = "solid";
      setHitbox(32, 32);
      collidable = Active;
      
      layer = 0;
    }
    
    public function activate(_solid: Boolean): Boolean
    {
      var result: Boolean;
      
      activated = (originalActivated ? !_solid : _solid);
      
      if (solid == _solid) result = true;
      else         result = false;
      
      if (activated != solid) {
        if (!solid) {
          if (!collide("movable", x, y) && !collide("player", x, y)) {
            solid = true;
            collidable = true;
            sprite.frame = 15 + color;
          }
        } else {
          solid = false;
          collidable = false;
          sprite.frame = 11 + color;
        }
      }
      
      return result;
    }
    
    override public function update():void 
    {
      super.update();
      
      if (activated != solid) {
        if (!solid) {
          if (!collide("movable", x, y) && !collide("player", x, y)) {
            solid = true;
            collidable = true;
            sprite.frame = 15 + color;
          }
        } else {
          solid = false;
          collidable = false;
          sprite.frame = 11 + color;
        }
      }
    }
  }

}