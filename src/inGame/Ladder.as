package inGame 
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Spritemap;
	/**
     * ...
     * @author MapiMopi
     */
    public class Ladder extends Entity
    {
        public var sprite: Spritemap = new Spritemap(Assets.spr_ladder, 32, 32);
        
        public function Ladder(X: int, Y: int) 
        {
            x = X;
            y = Y;
            
            graphic = sprite;
            
            type = "ladder";
            setHitbox(4, 40, -14, 4);
            
            layer = 30;
        }
        
    }

}