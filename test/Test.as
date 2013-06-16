package  
{
import cn.geckos.bitmap.BitmapMovieClip;
import cn.geckos.bitmap.BitmapMovieClipManager;
import cn.geckos.utils.Random;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import net.hires.debug.Stats

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
		var mc:MovieClip = new MC();
		var rect:Rectangle = mc.getBounds(mc);
		var drawRect:Rectangle = BitmapMovieClip.getDrawRectangle(mc);
		var bitmapDataList:Vector.<BitmapData> = BitmapMovieClip.drawMovieClip(mc, drawRect);
		var bitmapMovieClip:BitmapMovieClip = new BitmapMovieClip(mc, bitmapDataList, drawRect, this);
		//bitmapMovieClip.play();
		bitmapMovieClip.x = 250;
		bitmapMovieClip.y = 200;
		bitmapMovieClip.name = "bitmapMovieClip0";
		bitmapMovieClip.buttonMode = true;
		this.manager.push(bitmapMovieClip);
		for (var i:int = 1; i <= 300; i += 1)
		{
			//mc.scaleX = -1;
			bitmapMovieClip = bitmapMovieClip.clone();
			bitmapMovieClip.buttonMode = true;
			bitmapMovieClip.addEventListener(MouseEvent.CLICK, bitmapMovieClipClick);
			bitmapMovieClip.addEventListener(MouseEvent.MOUSE_DOWN, bitmapMovieClipDown);
			bitmapMovieClip.addEventListener(MouseEvent.MOUSE_UP, bitmapMovieClipUp);
			bitmapMovieClip.name = "bitmapMovieClip" + i;
			bitmapMovieClip.x = Random.randint(0, 550);
			bitmapMovieClip.y = Random.randint(0, 400);
			//bitmapMovieClip.alpha = .5;
			this.manager.push(bitmapMovieClip);
			bitmapMovieClip.play();
		}
		this.bitmapMovieClip = this.manager.getBitmapMovieClipByName("bitmapMovieClip0");
		//this.manager.startRender();
		
		this.effectMc = new ACTION_EFFECT_RUN();
		this.effectMc.x = 200;
		this.effectMc.y = 100;
		this.addChild(this.effectMc);
		
		//c1.buttonMode = true;
		
		//stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		this.bitmapMovieClip.addChildToParent(c1);
		//this.addChild(new Stats())
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
		//trace(e);
	}
	
	private function bitmapMovieClipUp(e:MouseEvent):void 
	{
		//trace(e);
	}
	
	private function bitmapMovieClipDown(e:MouseEvent):void 
	{
		//trace("bitmapMovieClipDown");
		this.bitmapMovieClip.removeFromParent();
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		//spt.stopDrag();
		//this.bitmapMovieClip.addChildToParent(c2);
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