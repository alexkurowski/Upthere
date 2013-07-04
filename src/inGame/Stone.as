package inGame 
{
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  /**
   * ...
   * @author MapiMopi
   */
  public class Stone extends Entity
  {
    public var sprite: Spritemap;
    
    public var color: int;
    
    public var r: int;
    
    public var col: Stone;
    public var col_up: Boolean;
    public var col_down: Boolean;
    public var col_left: Boolean;
    public var col_right: Boolean;
    
    public function Stone(X: int, Y: int, _color: int) 
    {
      x = X;
      y = Y;
      
      color = _color;
      
      if (color == 0) {
        sprite = new Spritemap(Assets.spr_solids, 32, 32);
        
        type = "solid";
        layer = 0;
      } else {
        sprite = new Spritemap(Assets.spr_blocks, 32, 32);
        type = "movable";
        layer = 20;
      }
      
      graphic = sprite;
      setHitbox(32, 32);
    }
    
    public function setFrame(_map: Array = null):void
    {
      if (color == 0) { 
        
        // not used
        
        r = FP.rand(14);
        
        if (collide("solid", x, y - 1)) {
          sprite.frame = r;
        } else {
          sprite.frame = r + 14 * FP.rand(2);
        }
        
      } else {
        
        r = 16 * (color - 1);
        
        if (_map == null) { // not first frame generation
          col = (collide("movable", x, y - 1) as Stone);
          if (col is Stone) col_up = (col.color == color);
          col = (collide("movable", x, y + 1) as Stone);
          if (col is Stone) col_down = (col.color == color);
          col = (collide("movable", x - 1, y) as Stone);
          if (col is Stone) col_left = (col.color == color);
          col = (collide("movable", x + 1, y) as Stone);
          if (col is Stone) col_right = (col.color == color);
        } else { // first frame generation
          if (_map[x / 32 + (y / 32 - 1) * 20] - 1 == color) col_up = true;
          else col_up = false;
          if (_map[x / 32 + (y / 32 + 1) * 20] - 1 == color) col_down = true;
          else col_down = false;
          if (_map[(x / 32 - 1) + y / 32 * 20] - 1 == color) col_left = true;
          else col_left = false;
          if (_map[(x / 32 + 1) + y / 32 * 20] - 1 == color) col_right = true;
          else col_right = false;
        }
        
        if (!col_up && !col_down && !col_left && !col_right) {
          sprite.frame = r;
          return;
        }
        if (col_up && col_down && col_left && col_right) {
          sprite.frame = 1 + r;
          return;
        }
        if (col_up && col_down && !col_left && !col_right) {
          sprite.frame = 2 + r;
          return;
        }
        if (!col_up && !col_down && col_left && col_right) {
          sprite.frame = 3 + r;
          return;
        }
        
        if (col_up && !col_down && !col_left && !col_right) {
          sprite.frame = 4 + r;
          return;
        }
        if (!col_up && !col_down && !col_left && col_right) {
          sprite.frame = 5 + r;
          return;
        }
        if (!col_up && col_down && !col_left && !col_right) {
          sprite.frame = 6 + r;
          return;
        }
        if (!col_up && !col_down && col_left && !col_right) {
          sprite.frame = 7 + r;
          return;
        }
        
        if (col_up && !col_down && !col_left && col_right) {
          sprite.frame = 8 + r;
          return;
        }
        if (!col_up && col_down && !col_left && col_right) {
          sprite.frame = 9 + r;
          return;
        }
        if (!col_up && col_down && col_left && !col_right) {
          sprite.frame = 10 + r;
          return;
        }
        if (col_up && !col_down && col_left && !col_right) {
          sprite.frame = 11 + r;
          return;
        }
        
        if (col_up && col_down && !col_left && col_right) {
          sprite.frame = 12 + r;
          return;
        }
        if (!col_up && col_down && col_left && col_right) {
          sprite.frame = 13 + r;
          return;
        }
        if (col_up && col_down && col_left && !col_right) {
          sprite.frame = 14 + r;
          return;
        }
        if (col_up && !col_down && col_left && col_right) {
          sprite.frame = 15 + r;
          return;
        }
      }
    }
  }

}