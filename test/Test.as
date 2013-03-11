package  
{
import cn.geckos.bitmap.BitmapMovieClip;
import cn.geckos.utils.Random;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import cn.geckos.bitmap.BitmapMovieClipManager;
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
	public function Test() 
	{
		this.manager = new BitmapMovieClipManager();
		this.spt = new Sprite();
		this.addChild(this.spt);
		for (var i:int = 0; i < 1; i += 1)
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
			this.bitmapMovieClip = new BitmapMovieClip(mc, c1);
			this.bitmapMovieClip.buttonMode = true;
			this.bitmapMovieClip.addEventListener(MouseEvent.CLICK, bitmapMovieClipClick);
			this.bitmapMovieClip.addEventListener(MouseEvent.MOUSE_DOWN, bitmapMovieClipDown);
			this.bitmapMovieClip.addEventListener(MouseEvent.MOUSE_UP, bitmapMovieClipUp);
			bitmapMovieClip.alpha = .9;
			//this.manager.push(this.bitmapMovieClip);
			bitmapMovieClip.play();
			//this.spt.addChild(mc);
			//mc = null;
		}
		this.effectMc = new ACTION_EFFECT_RUN();
		this.addChild(this.effectMc);
		//this.manager.startRender();
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
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