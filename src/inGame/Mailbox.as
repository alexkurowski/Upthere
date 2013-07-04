package inGame 
{
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.FP;
  /**
   * ...
   * @author MapiMopi
   */
  public class Mailbox extends Entity
  {
    public var sprite: Spritemap = new Spritemap(Assets.spr_mailbox, 32, 32);
    
    public var checked: Boolean;
    
    public var map_pointer: Map;
    
    public function Mailbox(X: int, Y: int, m: Map) 
    {
      x = X;
      y = Y;
      
      checked = false;
      
      map_pointer = m;
      
      sprite.add("off", [0]);
      sprite.add("on", [1, 2, 3, 4, 5, 6, 7], 0.2, false);
      sprite.play("off");
      graphic = sprite;
      
      type = "mailbox";
      setHitbox(20, 20, -8, -12);
      
      layer = 100;
    }
    
    override public function update():void 
    {
      super.update();
      
      if (!checked) { 
        if (collide("player", x, y)) {
          map_pointer.objectives_done++;
          checked = true;
          
          sprite.play("on");
          map_pointer.win();
        }
      }
    }
    
  }

}