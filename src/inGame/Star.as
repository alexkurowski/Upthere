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
  public class Star extends Entity
  {
    private var lifespan: int;
    private var sky_ref: Sky;
    
    public function Star(s: Sky) 
    {
      var r: int = FP.rand(3);
      lifespan = 200 + FP.rand(200);
      
      sky_ref = s;
      
      graphic = new Image(Assets.spr_star, new Rectangle(3 * r, 0, 3, 3));
      (graphic as Image).alpha = 0;
      
      x = 20 + FP.rand(600);
      y = 20 + FP.rand(440);
      
      layer = 210;
    }
    
    override public function update():void 
    {
      super.update();
      
      if (lifespan > 0) {
        lifespan--;
        
        if ((graphic as Image).alpha < 1) 
          (graphic as Image).alpha += 0.05;
      }
      
      if (sky_ref.cur_color != 2) {
        lifespan = 0;
      }
      
      if (lifespan <= 0) {
        if ((graphic as Image).alpha > 0)
          (graphic as Image).alpha -= 0.1;
        else
          FP.world.remove(this);
      }
    }
  }

}