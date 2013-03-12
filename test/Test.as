package  
{
import cn.geckos.bitmap.BitmapMovieClip;
import cn.geckos.bitmap.BitmapMovieClipManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;

/**
 * ...
 * @author Kanon
 */
public class Test extends Sprite 
{
	private var bitmapMovieClip:BitmapMovieClip;
	private var manager:BitmapMovieClipManager;
	private var spt:Sprite;
	private var effectMc:MovieClip;
	private var bitmap:Bitmap;
	public function Test() 
	{
		this.manager = new BitmapMovieClipManager();
		this.spt = new Sprite();
		this.addChild(this.spt);
		for (var i:int = 0; i < 2; i += 1)
		{
			//var mc:MovieClip = new bgj_man_mcStandL();
			var mc:MovieClip = new MC();
			//mc.filters = [new GlowFilter(0xFF3333, 1, 8, 8, 3.5)];
			mc.scaleX = -1;
			//mc.gotoAndStop(1);
			//var rect:Rectangle = mc.getBounds(mc);
			//mc.x = Random.randnum( -rect.left, stage.stageWidth - rect.right);
			//mc.y = Random.randnum( -rect.top, stage.stageHeight - rect.bottom);
			mc.x = 209.6;
			mc.y = 295.85;
			var bitmapMovieClip:BitmapMovieClip = new BitmapMovieClip(mc, c1);
			bitmapMovieClip.buttonMode = true;
			bitmapMovieClip.addEventListener(MouseEvent.CLICK, bitmapMovieClipClick);
			bitmapMovieClip.addEventListener(MouseEvent.MOUSE_DOWN, bitmapMovieClipDown);
			bitmapMovieClip.addEventListener(MouseEvent.MOUSE_UP, bitmapMovieClipUp);
			bitmapMovieClip.name = "bitmapMovieClip" + i;
			this.manager.push(bitmapMovieClip);
			bitmapMovieClip.play();
			//this.spt.addChild(mc);
			//mc = null;
		}
		
		this.bitmapMovieClip = this.manager.getBitmapMovieClipByName("bitmapMovieClip0");
		//this.manager.startRender();
		
		var bitmapData:BitmapData = new BitmapData(39, 21, true, 0x00000000);
		bitmapData.draw(new Bmp(39, 21));
		this.bitmap = new Bitmap(bitmapData);
		this.addChild(this.bitmap);
		
		this.effectMc = new ACTION_EFFECT_RUN();
		this.addChild(this.effectMc);
		
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}
	
	private function mouseMoveHandler(event:MouseEvent):void 
	{
		var bitmapMovieClip1:BitmapMovieClip = this.manager.getBitmapMovieClipByName("bitmapMovieClip1");
		bitmapMovieClip1.x = mouseX - bitmapMovieClip1.width * .5;
		bitmapMovieClip1.y = mouseY - bitmapMovieClip1.height * .5;
		if (bitmapMovieClip1.hitTestBitmapMovieClip(this.bitmapMovieClip))
			bitmapMovieClip1.alpha = .4;
		else
			bitmapMovieClip1.alpha = 1;
		/*this.bitmap.x = mouseX;
		this.bitmap.y = mouseY;
		trace(this.bitmapMovieClip.hitTest(this.bitmap));*/
	}
	
	private function keyDownHandler(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.D)
			this.bitmapMovieClip.removeChild(c2);
		if (event.keyCode == Keyboard.C)
			this.bitmapMovieClip.destroy();
	}
	
	private function bitmapMovieClipClick(e:MouseEvent):void 
	{
		trace(e);
	}
	
	private function bitmapMovieClipUp(e:MouseEvent):void 
	{
		trace(e);
	}
	
	private function bitmapMovieClipDown(e:MouseEvent):void 
	{
		trace(e);
		//this.bitmapMovieClip.beRemoveChild();
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		//spt.stopDrag();
		this.bitmapMovieClip.beAddChild(c2);
		//this.bitmapMovieClip.addChild(c2, new Point(100, -280));
		this.bitmapMovieClip.addChild(this.effectMc, new Point(100, -280));
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		//spt.startDrag();
		//this.manager.destroy();
	}
	
}
}