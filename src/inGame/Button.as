package inGame 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.World;
  /**
   * ...
   * @author MapiMopi
   */
  public class Button extends Entity
  {
    public var sprite: Spritemap;
    
    public var color: int;
    
    public var activated: Boolean;
    
    public var bling_timer: int = 0;
    
    public var newSwitch: Switchable;
    public var blocks: Array;
    
    private var col_up: Stone;
    private var col_down: Stone;
    private var col_left: Stone;
    private var col_right: Stone;
    private var i: int;
    private var j: int;
    
    public function Button(X: int, Y: int, col: int, w: World, blockSource: Array)
    {
      x = X * 32;
      y = Y * 32;
      
      color = col;
      
      sprite = new Spritemap(Assets.spr_buttons, 32, 32);
      sprite.add("blue_active", [0, 4], 0.1);
      sprite.add("red_active", [1, 5], 0.1);
      sprite.add("yellow_active", [2, 6], 0.1);
      sprite.add("green_active", [3, 7], 0.1);
      sprite.add("blue_deactive", [8]);
      sprite.add("red_deactive", [9]);
      sprite.add("yellow_deactive", [10]);
      sprite.add("green_deactive", [11]);
      
      if (color == 1) sprite.play("blue_deactive");
      if (color == 2) sprite.play("red_deactive");
      if (color == 3) sprite.play("yellow_deactive");
      if (color == 4) sprite.play("green_deactive");
      
      graphic = sprite;
      
      type = "solid";
      setHitbox(32, 32);
      
      layer = 0;
      
      
      blocks = new Array;
      
      
      i = 0;
      while (i < blockSource.length) {
        newSwitch = new Switchable(blockSource[i], blockSource[i + 1], color, blockSource[i + 2])
        blocks.push(newSwitch);
        w.add(newSwitch);
        i += 3;
      }
    }
    
    
    public function check(m: Array = null): Boolean
    {
      var _check: Boolean;
      
      if (m == null) { 
        col_up = collide("movable", x, y - 1) as Stone;
        col_down = collide("movable", x, y + 1) as Stone;
        col_left = collide("movable", x - 1, y) as Stone;
        col_right = collide("movable", x + 1, y) as Stone;
      } else {
        i = Math.floor(x / 32);
        j = Math.floor(y / 32);
        
        (m[i + (j - 1) * 20] > -1  ?  col_up = new Stone(0, 0, Math.floor(m[i + (j - 1) * 20]) + 1)  :  col_up = null);
        (m[i + (j + 1) * 20] > -1  ?  col_down = new Stone(0, 0, Math.floor(m[i + (j + 1) * 20]) + 1)  :  col_down = null);
        (m[(i - 1) + j * 20] > -1  ?  col_left = new Stone(0, 0, Math.floor(m[(i - 1) + j * 20]) + 1)  :  col_left = null);
        (m[(i + 1) + j * 20] > -1  ?  col_right = new Stone(0, 0, Math.floor(m[(i + 1) + j * 20]) + 1)  :  col_right = null);
      }
      
      if ((col_up && col_up.color == color) || (col_down && col_down.color == color)
      || (col_left && col_left.color == color) || (col_right && col_right.color == color))
        _check = true;
      else
        _check = false;
       
      if (_check) {
        if (color == 1) sprite.play("blue_active");
        if (color == 2) sprite.play("red_active");
        if (color == 3) sprite.play("yellow_active");
        if (color == 4) sprite.play("green_active");
        bling_timer = 10;
      } else {
        if (color == 1) sprite.play("blue_deactive");
        if (color == 2) sprite.play("red_deactive");
        if (color == 3) sprite.play("yellow_deactive");
        if (color == 4) sprite.play("green_deactive");
      }  
      
      if (activated == _check) return false;
      else {
        activated = _check;
        i = 0;
        while (i < blocks.length) {
          (blocks[i] as Switchable).activate(activated);
          i++;
        }
        return true;
      }
    }
  }

}