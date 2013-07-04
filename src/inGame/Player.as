package inGame
{
  import fx.*;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import net.flashpunk.FP;
  /**
   * ...
   * @author MapiMopi
   */
  public class Player extends Entity
  {
    public const RUN: Number = 2.5;
    public const INITIAL_JUMP: Number = -3; //-1.6
    public const JUMP_MIN: Number = -0.4; //-0.2
    public const GRAVITY: Number = 0.2; // 0.0625
    public const MAX_GRAVITY: Number = 2; // 0.4
    
    public const FLOAT_BUMP: int = 8;
    public const FLOAT_NORM: int = 2;
    
    public var sprite:Spritemap;
    
    public var _x: Number = 0;
    public var _x_add: Number = 0;
    public var _y: Number = 0;
    public var floating: int = 0;
    public var i: int;
    
    public var prev_state: String = "";
    public var state: String = "ground"; // ground, air, (landed?), ladder, (pushing?)
    public var last_step_ground: Boolean = true;
    
    public var col_entity: Entity;
    
    public var uncontrolable: int;
    public var immovable: int;
    
    public var pull_jump: int = 0;
    public var push_dir: int;
    public var push_pull: Boolean = false;
    public var map_pointer: Map;
    
    public function Player(X: int, Y: int, m: Map) 
    {
      x = X - 16;
      y = Y - 16;
      
      map_pointer = m;
      
      type = "player";
      setHitbox(16, 24, -24, -24);
      
      layer = 10;
      
      sprite = new Spritemap(Assets.spr_player, 64, 64, animationEnd);
      sprite.add("stand", [0]);
      sprite.add("run", [1, 2, 3, 4, 5, 6], 0.15);
      sprite.add("turn_around", [8, 8, 9], 0.2, false);
      sprite.add("on_ladder", [25, 26, 25, 27], 0.1);
      //sprite.add("pre_jump", [9]);
      sprite.add("land", [10]); // used for pre-jump as well
      sprite.add("jump", [11]);
      sprite.add("fall", [12]);
      //sprite.add("fall", [13]);
      sprite.add("bump", [13]);
      sprite.add("hold", [20]);
      sprite.add("push", [21, 22, 23, 23], 0.15);
      sprite.add("pull", [23, 22, 21, 21], 0.15);
      //sprite.add("end_push", [16, 17], 0.18, false);
      //sprite.add("end_pull", [18, 19], 0.15, false);

      graphic = sprite;
      
      sprite.play("stand");
    }
    
    override public function update():void 
    {
      super.update();
      
      // check for death conditions
      // TODO: maybe there shouldn't be death in a game about moving blocks?..
      if (collide("movable", x, y + 1) && collide("movable", x, y - 1)) {
        FP.log("YOU SHOULD BE DEAD RIGHT NOW");
      }
      
      // only check for ground and air, everything else is highly conditional
      prev_state = state;
      if (state == "ground" || state == "air") {
        state = (checkGround() ? "ground" : "air");
      }
      
      // do a little just if push or pull
      if (pull_jump > 0) {
        x += (sprite.flipped ? 4 : -4) * (push_pull ? -1 : 1);
        pull_jump--;
      }
      
      if (uncontrolable <= 0) { 
        checkMovement(Input.check(Key.LEFT), Input.check(Key.RIGHT), Input.check(Key.UP), Input.check(Key.DOWN), Input.check(Key.Z), Input.pressed(Key.Z));
      } else {
        checkMovement(false, false, false, false, false, false); // will change variables but don't take any input
        uncontrolable--;
      }
      
      // check if PUSH button is held and there's somethign to push
      if (pull_jump <= 0 && !uncontrolable) { // TODO: might call some bugs?
        checkPushing(Input.check(Key.LEFT), Input.check(Key.RIGHT), Input.check(Key.X));
      }
      
      if (Input.pressed(Key.C)) {
        if (map_pointer.save) {
          map_pointer.loadMap();
        }
      }
       
      if (immovable <= 0) {
        applyMovement();
      } else {
        immovable--;
      }
      
      
      if (Input.pressed(Key.ESCAPE)) {
        FP.world.removeAll();
        FP.world = new LevelMenuState(map_pointer.levelID);
      }
    }
    
    public function checkPushing(left: Boolean, right: Boolean, push: Boolean): void
    {
      if (state == "ground") { // not holding any blocks
        if (push) {
          if (collide("movable", x + (sprite.flipped ? -8 : 8), y)) { // if there's anything to hold
            state = "pushing";
            if (!sprite.flipped) {
              // pixel perfect align to the right
              x = Math.floor(x / 32) * 32 + 22;
            } else {
              // pixel perfect align to the left
              x = Math.floor(x / 32) * 32 + 10;
            }
          }
        }
      }
      if (state == "pushing") { // already holding a block -- don't move, only do animation
        _x = 0;
        if (push && (left || right)) {
          if (left) {
            push_dir = -1;
            if (sprite.flipped) {
              sprite.play("push", (map_pointer.moving ? true : false));
            } else {
              sprite.play("pull", (map_pointer.moving ? true : false));
            }
          }
          else if (right) {
            push_dir = 1;
            if (sprite.flipped) {
              sprite.play("pull", (map_pointer.moving ? true : false));
            } else {
              sprite.play("push", (map_pointer.moving ? true : false));
            }
          }
        } else {
          if (!push) state = "ground";
          if (!left && !right) {
            sprite.play("hold"); // TODO: make a frame for just holding the block
          }
        }
      }
    }
    
    public function checkMovement(left: Boolean, right: Boolean, up: Boolean, down: Boolean, jump_check: Boolean, jump_pressed: Boolean): void
    {
      if (state != "pushing") {        
        if (left) {
          if (state == "ground" && _x == 1) {
            FP.world.add(new Dust(x - 8, y, "stop", true));
            sprite.play("turn_around");
          }
          _x = -1;
          if (state == "ground" && sprite.currentAnim != "turn_around") sprite.play("run");
          if (state == "ladder" && !collide("ladder", x - RUN, y) && !collide("solid", x - RUN, y) && !collide("movable", x - RUN, y)) { // so we don't fly of ladder
            state = "air";
            _y = 0;
          }
          if (state != "ladder") sprite.flipped = true;
          
        }
        else if (right) {
          if (state == "ground" && _x == -1) {
            FP.world.add(new Dust(x + 8, y, "stop", false));
            sprite.play("turn_around");
          }
          _x = 1;
          if (state == "ground" && sprite.currentAnim != "turn_around") sprite.play("run");
          if (state == "ladder" && !collide("ladder", x + RUN, y) && !collide("solid", x + RUN, y) && !collide("movable", x + RUN, y)) {
            state = "air";
            _y = 0;
          }
          if (state != "ladder") sprite.flipped = false;
        }
        else {
          if (!uncontrolable) { // TODO: change this if player shouldn't move while uncontrolable
            _x = 0;
            if (state == "ground") sprite.play("stand");
          }
          
        }
      }
      

      if (state == "ladder") { // don't fall from ladders
        _y = 0;
      }
      
      if (collide("ladder", x, y)) { // but move if up or down is beign held
        if (up) {
          if (collide("ladder", x, y - 20)) {
            _y = -1;
            if (collideTypes(["solid", "movable"], x, y - 8)) {  // don't move if there's a block
              _y = 0;
            }
            sprite.flipped = false;
            sprite.play("on_ladder");  
            state = "ladder";
          }
        }
        else if (down) {
          if (collide("ladder", x, y + 1)) {
            
            if (state == "ladder" && (collide("solid", x, y + 4) || collide("movable", x, y + 4))) {
              state = "air"; // jump off the ladder if there's a blcok to stand on
              _y = 0;
            } else {
              if (state != "ground") {
                _y = 1;
                sprite.flipped = false;
                sprite.play("on_ladder");
                state = "ladder";
              }
            }
          }
        }
        else {
          if (state == "ladder") { 
            y = Math.floor(y); // just so the jagging won't be happening so often
            sprite.flipped = false;
            sprite.play("on_ladder", true);
          }
        }
      } else { // if not colliding ladder
        if (state == "ladder") { // but still in "ladder" state
          state = "air";
          _y = 0;
        }
      }
      
      // jumping, can jump off ground and ladders
      if (state == "ground" || state == "ladder") {
        if (jump_pressed) {
          _y = INITIAL_JUMP;
          sprite.play("land");
          state = "air";
        }
      }
      else if (state == "air") {
        if (floating <= 0) {
          if (!jump_check && _y < JUMP_MIN) { 
            _y = JUMP_MIN;
          }
          
          if (_y > -0.2 && _y < 0.2) {
            floating = FLOAT_NORM;
          }
          _y += GRAVITY;
        }
        if (_y > MAX_GRAVITY) {
          _y = MAX_GRAVITY;
        }
        
        if (floating > FLOAT_NORM) {
          sprite.play("bump");
        } else {
          if (_y > JUMP_MIN) { // TODO: try 0
            sprite.play("fall");
          } else {
            sprite.play("jump");
          }
        }
      }
    }

    // Actual applying of calculated _x and _y in prev. function    
    public function applyMovement(): void
    {
      if (state != "pushing") {
        
        if (state == "air" && _y > -JUMP_MIN) {
          _x_add = RUN - _y * 0.5;
        } else {
          _x_add = RUN;
        }
        
        if (!collide("solid", x + _x * _x_add, y) && !collide("movable", x + _x * _x_add, y)) {
          x += _x * _x_add;
        } else {
          if (_x > 0) {
            // align to the right
            x = Math.floor(x / 32) * 32 + 24;
          }
          else if (_x < 0) {
            // align to the left
            x = Math.floor(x / 32) * 32 + 8;
          }
          _x = 0;
        }
      }
      
      
      if (floating <= 0) { 
        for (i = 0; i < Math.abs(_y); i++) { // move by pixel
          if (!(collide("solid", x, y + FP.sign(_y)) || collide("movable", x, y + FP.sign(_y)))) {
            y += FP.sign(_y);
            
            if (i + 1 >= Math.abs(_y)) { // if there's something left in _y (like 6.25, move by 0.25)
              if (!(collide("solid", x, y + FP.sign(_y)) || collide("movable", x, y + FP.sign(_y)))) {
                y += FP.sign(_y) * (Math.abs(_y) - i);
                break;
              } else { // stop moving
                i = -1;
                break;
              }
            }
          } else {
            i = -1;
            break;
          }
        }
        
        if (i == -1) { 
          if (_y > 0) {
            if (uncontrolable <= 0) uncontrolable = 4;
            sprite.play("land");
            FP.world.add(new Dust(x, y, "land"));
            _y = 0;
            y = Math.floor(y / 32) * 32 + 16;
          } else {
            _y = 0;
            y = Math.floor(y / 32) * 32 + 8;
            floating = FLOAT_BUMP;
            sprite.play("bump");
            // TODO: play boiink (ceiling hit) animation
          }
        }
      } else {
        if (!collideTypes(["solid", "movable"], x + 8, y + 12) && !collideTypes(["solid", "movable"], x - 8, y + 12)) {
          floating = 0;
        }
        floating--;
      }
    }
    
    public function animationEnd(): void
    {
      // check sprite.current_anim
      // do stuff accordingly
      
      if (sprite.currentAnim == "push") {
        if (!map_pointer.moving) { // if something's not already moving
          if (map_pointer.assignMovement(push_dir, collide("movable", x + (sprite.flipped ? -4 : 4), y))) { // return false if nothing can be moved
            map_pointer.saveMap();
            
            push_pull = true;
            x += 4 * push_dir; // player follow the block while push and pull
            pull_jump = 7;//
            
            if (uncontrolable <= 0) uncontrolable = 16;
            // TODO: play push animation
            //sprite.play("end_push"); 
            state = "ground";
          } else {
            // nothing to push
          }
        }
        
      }
      if (sprite.currentAnim == "pull") {
        if (!map_pointer.moving) {
          if ((collide("solid", x - (sprite.flipped ? -32 : 32), y + 32) || collide("movable", x - (sprite.flipped ? -32 : 32), y + 32)) && 
            (!collide("solid", x - (sprite.flipped ? -32 : 32), y) && !collide("movable", x - (sprite.flipped ? -32 : 32), y))) {
            if (map_pointer.assignMovement(push_dir, collide("movable", x + (sprite.flipped ? -4 : 4), y))) {
              map_pointer.saveMap();
              
              push_pull = false;
              x += 4 * push_dir;
              pull_jump = 7;
            
              if (uncontrolable <= 0) uncontrolable = 16;
              // TODO: play pull animation
              //sprite.play("end_pull");
              state = "ground";
            } else {
              // nothing to pull
            }
            
          }
        }
        
      }
      
      
      if (sprite.currentAnim == "turn_around") {
        sprite.play("run");
      }
    }
    
    public function checkGround(): Boolean
    {
      if (collide("solid", x, y + 1) || collide("movable", x, y + 1)) {
        return true;
      } else {
        return false;
      }
    }
    
  }

}