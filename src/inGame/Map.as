package inGame
{
  import fx.FadeOut;
  import fx.FadeIn;
  import inGame.Ladder;
  import inGame.Player;
  import inGame.Stone;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Grid;
  import net.flashpunk.World;
  /**
   * ...
   * @author MapiMopi
   */
  public class Map extends Entity
  {
    public var levelID: int;
    
    public var _map: Array;       // generation will use this map
    public var current_map: Array;    // map as an array at any given time
    
    public var move_grid: Array;    // an array with blocks that should be moved
    public var move_delete_grid: Array; // an array with blocks that should be moved but can't do so
    
    public var moving: Boolean = false; // not used, moving_timer is used right now
    public var moving_timer: int = 0;   // how many frames will be moving
    public var moving_direction: int = 0;   // in which direction blocks are moving (0 = down, -1 = left, 1 = right)
    public var moving_entities: Array;  // an array of entities that are moving
    public var coloring_entities: Array;  // an array of entities that should change their state (merging)
    
    public var bg_tiles: Entity;       // tilemap of solids, immovable stuff
    public var fg_tiles: Entity;       // grass and background stuff
    
    public var dirty: Boolean = false;  // check if move_grid should be reassigned
    
    public var newButt: Button;     // helper on creating new button
    public var buttons: Array;      // an array of all buttons (they also contain all switchable blocks inside of them)
    
    public var player: Player;      // Player (suddenly!)
    public var objectives: int;     // overall number of mailboxes on current map
    public var objectives_done: int;  // number of touched mailboxes
    
    public var save: Array;       // Game saves the map into this array, if later recovery is needed
    public var saveX: Number;       // player's x on save
    public var saveY: Number;       // player's y on save
    
    public var i: int;
    public var j: int;
    public var r: uint;
    
    public var w: World;        // pointer on the parent world class
    
    public function Map(id: int, map_array: Array) 
    {
      setHitbox(1, 1);
      
      levelID = id;
      
      _map = map_array;
    }
    
    override public function update():void 
    {
      super.update();
      
      /*if (dirty) {
        assignFalling();
        dirty = false;
      }*/
      // if blocks should be moved
      if (moving_timer > 0) {
        if (moving_entities.length > 0) {
          for (i = 0; i < moving_entities.length; i++) {
            if (moving_direction != 0)
              (moving_entities[i] as Stone).x += moving_direction * 4;
            else
              (moving_entities[i] as Stone).y += 8;
          }
        } else {
          moving = false;
        }
        
        moving_timer--;
        
        // if this is the last move step (should be +16 pixels in the moving direction)
        if (moving_timer <= 0) {

          // check the buttons, should they switch?
          i = 0;
          while (i < buttons.length) { 
            (buttons[i] as Button).check();
            dirty = true;
            i++;
          }
          
          // assignFalling() will return false once there's no more blocks that should fall
          if (!assignFalling()) {
            moving = false;
            moving_timer = 0;
            
            // TODO: play merge animation
            coloring_entities = new Array;
            FP.world.getClass(Stone, coloring_entities);
            for (i = 0; i < coloring_entities.length; i++) {
              (coloring_entities[i] as Stone).setFrame();
            }
          }   
        }
      }
    }
    
    // check win conditions
    public function win(): void
    {
      if (objectives_done >= objectives) {
        player.uncontrolable = 999;
        player.immovable = 999;
        if(player.state == "ground")
          player.sprite.play("stand");
        w.add(new FadeOut(60, 0.04, 0xff000000, win_fade));
      }
    }
    
    public function win_fade(): void
    {
      w.removeAll();
      w.add(new FadeIn(0, 0.1));
      w.add(new Congratulations(levelID));
    }
    
    
    // ----------------------------------------------- MOVEMENT -----------------------------------------------------------

    public function assignMovement(dir: int, origin_movement: Entity): Boolean
    {
      current_map = mapSnapshot();
      
      move_grid = new Array;
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          move_grid[i + j * 20] = -1;
        }
      }
      
      // single block that player is touching, initiating the movement
      move_grid[Math.floor(origin_movement.x / 32) + Math.floor(origin_movement.y / 32) * 20] = (origin_movement as Stone).color;
      
      
      // A wave-like checking of map for stuff that can be moved
      var done: Boolean = false;
      while (!done) {
        done = true;
        for (i = 1; i < 19; i++) {
          if (!done) break;
          for (j = 1; j < 14; j++) {
            if (!done) break;
            
            if (move_grid[i + j * 20] > 0) {
              
              // If yet unmarked, if same color (within direction) or if movable
              
              // to the right (only check color if moving left)
              if (move_grid[(i + 1) + j * 20] == -1 && ((current_map[(i + 1) + j * 20] == current_map[i + j * 20] && dir == -1) || (current_map[(i + 1) + j * 20] > 0 && dir == 1))) { 
                move_grid[(i + 1) + j * 20] = current_map[(i + 1) + j * 20];
                done = false;  
              }
              // to the left (only check color if moving right)
              if (move_grid[(i - 1) + j * 20] == -1 && ((current_map[(i - 1) + j * 20] == current_map[i + j * 20] && dir == 1) || (current_map[(i - 1) + j * 20] > 0 && dir == -1))) { 
                move_grid[(i - 1) + j * 20] = current_map[(i - 1) + j * 20];
                done = false;  
              }
              // to the downside (only if same color)
              if (move_grid[i + (j + 1) * 20] == -1 && current_map[i + (j + 1) * 20] == current_map[i + j * 20]) { 
                move_grid[i + (j + 1) * 20] = current_map[i + (j + 1) * 20];
                done = false;  
              }
              // to the upside (whatever color)
              if (move_grid[i + (j - 1) * 20] == -1 && current_map[i + (j - 1) * 20] > 0) { 
                move_grid[i + (j - 1) * 20] = current_map[i + (j - 1) * 20];
                done = false;  
              }
            }
            
          }
        }
      }// while
      

      move_delete_grid = new Array;
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          move_delete_grid[i + j * 20] = 0;
        }
      }
      
      // can't move block that we're standing on
      i = Math.floor((player.x + 32) / 32);
      j = Math.floor((player.y + 32) / 32) + 1;
      if (move_grid[i + j * 20] > 0) { 
        move_delete_grid[i + j * 20] = 1;
      }
      
      // A wave-like checking for stuff that can't be moved
      done = false;
      while (!done) {
        done = true;
        for (i = 1; i < 19; i++) {
          if (!done) break;
          for (j = 1; j < 14; j++) {
            if (!done) break;
            
            // if there's a solid immovable block in the way
            if (current_map[i + j * 20] > -1 && (move_grid[i + j * 20] == -1 || move_delete_grid[i + j * 20] == 1) && move_grid[(i - dir) + j * 20] > 0 && move_delete_grid[(i - dir) + j * 20] != 1) { 
              move_delete_grid[(i - dir) + j * 20] = 1;
              done = false;
            }
            
            if (move_delete_grid[i + j * 20] == 1) {
              
              // if block don't move, then any block next to it with same color won't move as well
              // left
              if (move_grid[i + j * 20] == move_grid[(i - 1) + j * 20] && move_delete_grid[(i - 1) + j * 20] != 1) {
                move_delete_grid[(i - 1) + j * 20] = 1;
                done = false;
              }
              // right
              if (move_grid[i + j * 20] == move_grid[(i + 1) + j * 20] && move_delete_grid[(i + 1) + j * 20] != 1) {
                move_delete_grid[(i + 1) + j * 20] = 1;
                done = false;
              }
              // down
              if (move_grid[i + j * 20] == move_grid[i + (j + 1) * 20] && move_delete_grid[i + (j + 1) * 20] != 1) {
                move_delete_grid[i + (j + 1) * 20] = 1;
                done = false;
              }
              // up is the exception, don't check colors, only if they are both are blocks
              if (move_grid[i + j * 20] > 0 && move_grid[i + (j - 1) * 20] > 0 && move_delete_grid[i + (j - 1) * 20] != 1) {
                move_delete_grid[i + (j - 1) * 20] = 1;
                done = false;
              }

            }
            
          }
        }
      }// while
      
      // if initial block can't be moved, then abort
      if (move_delete_grid[Math.floor(origin_movement.x / 32) + Math.floor(origin_movement.y / 32) * 20] == 1) {
        return false;
      }
      
      // put everything that is moving in an array
      moving_entities = new Array;
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          
          if (move_grid[i + j * 20] > 0 && move_delete_grid[i + j * 20] != 1) {
            moving_entities.push(checkMap(i * 32, j * 32));
          }
          
        }
      }
      
      // initiate movement, that will be executed in update()
      if (moving_entities.length > 0) {
        moving = true;
        moving_timer = 8;
        moving_direction = dir;
        return true;
      } else {
        return false;
      }
    }
    
    
    // ----------------------------------------------- FALLING ------------------------------------------------------------
    
    public function assignFalling(): Boolean
    {
      current_map = mapSnapshot();
      
      if (moving_direction != 0) { 
        // if first fall assignment
        for (i = 0; i < 20; i++) {
          for (j = 0; j < 15; j++) {
            move_grid[i + j * 20] = current_map[i + j * 20];
          }
        }
      } else {
        // else exclude block that are done falling
        for (i = 0; i < 20; i++) {
          for (j = 0; j < 15; j++) {
            if (move_delete_grid[i + j * 20] == 1)
              move_grid[i + j * 20] = -1;
          }
        }
        
        // add a line on top, so everything move down one step
        move_grid.unshift( -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
      }
      
      
      move_delete_grid = new Array;
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          move_delete_grid[i + j * 20] = 0;
        }
      }
      
      // A wave-like check for blocks that can't fall
      var done: Boolean = false;
      while (!done) {
        done = true;
        for (i = 1; i < 19; i++) {
          if (!done) break;
          for (j = 1; j < 14; j++) {
            if (!done) break;
            
            // can't fall if there's a solid block one tile down 
            if ((current_map[i + j * 20] == 0 || (current_map[i + j * 20] > 0 && move_grid[i + j * 20] == -1)) && move_grid[i + (j - 1) * 20] > 0 && move_delete_grid[i + (j - 1) * 20] != 1) { 
              move_delete_grid[i + (j - 1) * 20] = 1;
              done = false;
            }
            
            // if block can't move, then any next block with same color won't move as well
            if (move_delete_grid[i + j * 20] == 1) {
              
              if (move_grid[i + j * 20] == move_grid[(i - 1) + j * 20] && move_delete_grid[(i - 1) + j * 20] != 1) {
                move_delete_grid[(i - 1) + j * 20] = 1;
                done = false;
              }
              if (move_grid[i + j * 20] == move_grid[(i + 1) + j * 20] && move_delete_grid[(i + 1) + j * 20] != 1) {
                move_delete_grid[(i + 1) + j * 20] = 1;
                done = false;
              }
              if (move_grid[i + j * 20] == move_grid[i + (j + 1) * 20] && move_delete_grid[i + (j + 1) * 20] != 1) {
                move_delete_grid[i + (j + 1) * 20] = 1;
                done = false;
              }
              // up is the exception, color shouldn't be checked
              if (move_grid[i + (j - 1) * 20] > 0 && move_delete_grid[i + (j - 1) * 20] != 1) {
                move_delete_grid[i + (j - 1) * 20] = 1;
                done = false;
              }
              
            }
            
          }
        }
      }// while
      
      // put everything that is falling in an array
      moving_entities = new Array;
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          
          if (move_grid[i + j * 20] > 0 && move_delete_grid[i + j * 20] != 1) {
            moving_entities.push(checkMap(i * 32, j * 32));
          }
          
        }
      }
      
      // initiate movement, that will be executed in update()
      if (moving_entities.length > 0) {
        moving = true;
        moving_timer = 4;
        moving_direction = 0;
        return true;
      } else {
        return false;
      }
    }
    
    
    // put whole map into an array
    public function mapSnapshot(): Array
    {
      var result: Array = new Array;
      var col: Entity;
      
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          col = collideTypes(["solid", "movable"], i * 32, j * 32);
          
          if (col is Stone) {
            result[i + j * 20] = (col as Stone).color;
          }
          else if (col is Button || col is Switchable || col is Entity) {
            result[i + j * 20] = 0;
          }
          else if (col == null) {
            result[i + j * 20] = -1;
          }
        }
      }
      
      return result;
    }
    
    // save snapshot into the save array
    public function saveMap(): void
    {
      var col: Entity;
      save = new Array;
      
      saveX = Math.floor(player.x / 32) * 32 + 16;
      saveY = Math.floor(player.y / 32) * 32 + 16;
      
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          col = collide("movable", i * 32, j * 32);
          
          if (col is Stone) {
            //save[i + j * 20] = (col as Stone).color;
            save[i + j * 20] = (col as Stone).sprite.frame;
          } else {
            save[i + j * 20] = -1;
          }
        }
      }
    }
    
    // load the snapshot from the save array
    public function loadMap(): void
    {
      FP.world.add(new FadeIn(0, 0.06));
      
      moving = false;
      moving_timer = 0;
      moving_direction = 0;
      
      var col: Entity;
      coloring_entities = new Array;
      
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          col = collide("movable", i * 32, j * 32);
          
          if (col is Stone) {
            FP.world.remove(col);
          }
            
          if (save[i + j * 20] != -1) {
            col = w.add(new Stone(i * 32, j * 32, Math.floor(save[i + j * 20] / 16) + 1));
            (col as Stone).sprite.frame = save[i + j * 20];
          }
        }
      }
      
      i = 0;
      while (i < buttons.length) { 
        (buttons[i] as Button).check(save);
        dirty = true;
        i++;
      }
      
      player.x = saveX;
      player.y = saveY;
      
      save = null;
    }
    
    public function checkMap(X: int, Y: int): Stone
    {
      return (collide("movable", X, Y) as Stone);
    }
    
    // make new button, blockArray consist of X (tile-wise), Y (also as tile) and boolean if the block is active without active button
    public function makeButton(X: int, Y: int, color: int, blockArray: Array): void
    {
      newButt = new Button(X, Y, color, w, blockArray);
      buttons.push(newButt);
      w.add(newButt);
    }
    
    // reset the map
    public function generateMap(_w: World, bg: int): void
    {
      w = _w; // could do that in constructor
      
      save = null;
      
      moving = false;
      moving_timer = 0;
      moving_direction = 0;
      
      buttons = new Array;
      
      objectives = 0;
      objectives_done = 0;
      
      coloring_entities = new Array;
      
      bg_tiles = new Entity(0, 0, new Tilemap(Assets.spr_solids, 640, 480, 32, 32));
      bg_tiles.type = "solid";
      bg_tiles.mask = new Grid(640, 480, 32, 32);
      bg_tiles.layer = 110;
      fg_tiles = new Entity(0, 0, new Tilemap(Assets.spr_foreground, 640, 480, 32, 32));
      
      for (i = 0; i < 20; i++) {
        for (j = 0; j < 15; j++) {
          
          if (_map[i + j * 20] == 0) {
            (bg_tiles.graphic as Tilemap).setTile(i, j, 14 + bg);
          }
          if (_map[i + j * 20] == 1) {
            (bg_tiles.graphic as Tilemap).setTile(i, j, FP.rand(14));
            
            if (_map[i + (j - 1) * 20] != 1 && _map[i + (j - 1) * 20] != 0) {
              (fg_tiles.graphic as Tilemap).setTile(i, j, FP.rand(14));
            }
            
            (bg_tiles.mask as Grid).setTile(i, j, true);
          } else {
            (bg_tiles.mask as Grid).setTile(i, j, false);
          }
          
          
          switch (_map[i + j * 20]) {
            case 0: // UNREACHABLE SOLID
              break;
            
            case 1: // SOLID
              //w.add(new Stone(i * 16, j * 16, 0));
              break;
              
            case 2: // COLOR
              coloring_entities.push(w.add(new Stone(i * 32, j * 32, 1)));
              break;
            case 3: // COLOR
              coloring_entities.push(w.add(new Stone(i * 32, j * 32, 2)));
              break;
            case 4: // COLOR
              coloring_entities.push(w.add(new Stone(i * 32, j * 32, 3)));
              break;
            case 5: // COLOR
              coloring_entities.push(w.add(new Stone(i * 32, j * 32, 4)));
              break;
              
            case 6: // LADDER
              w.add(new Ladder(i * 32, j * 32));
              break;
              
            case 7: // NOTHING YET
              FP.console.log("For some reason there's nothing, although it could be some item or cool block");
              break;
              
            case 8: // PLAYER
              player = new Player(i * 32, j * 32, this);
              w.add(player);
              break;
              
            case 9: // MAILBOX
              w.add(new Mailbox(i * 32, j * 32, this));
              objectives += 1;
              break;
              
            default:
              FP.console.log("You shouldn't be here");
          }
        }
      }
      
      // entities won't collide on the frame they are added, so we have to use initial map array to change frames
      for (i = 0; i < coloring_entities.length; i++) {
        (coloring_entities[i] as Stone).setFrame(_map);
      }
      
      w.add(bg_tiles);
      w.add(fg_tiles);
      
      w.add(new Sky());
    }
  }

}