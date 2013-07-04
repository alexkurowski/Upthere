package  
{
  import fx.FadeOut;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Text;
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import net.flashpunk.World;
	/**
   * ...
   * @author MapiMopi
   */
  public class LetterWorld extends World
  {
    private var levelID: int;
    
    public var fade: FadeOut;
    
    public function LetterWorld(_id: int) 
    {
      levelID = _id;
      
      text = new Entity(10, 10, new Text(""));
      
      pickText();
      
      add(text);
    }
    
    public function pickText(): void
    {
      switch(levelID) {
        case 0:
          (text.graphic as Text).text = 
          "TEST";
          break;
      }
    }
    
    override public function update():void 
    {
      super.update();
      
      if (!fade) {
        if (Input.pressed(Key.Z) || Input.pressed(Key.ENTER) || Input.pressed(Key.ESCAPE)) {
          fade = new FadeOut(0, 0.02, 0xff000000, fadeComplete);
          add(fade);
        }
      }
    }
    
    public function fadeComplete(): void
    {
      removeAll();
      FP.world = new LevelMenuState();
    }
    
  }

}