package  
{
import cn.geckos.bitmap.BitmapMovieClip;
import cn.geckos.utils.Random;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import cn.geckos.bitmap.BitmapMovieClipManager;

/**
 * ...
 * @author Kanon
 */
public class Test extends Sprite 
{
	private var bitmapMovieClip:BitmapMovieClip;
	private var manager:BitmapMovieClipManager;
	private var spt:Sprite;
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
			this.bitmapMovieClip = new BitmapMovieClip(mc, this.spt);
			this.bitmapMovieClip.buttonMode = true;
			this.bitmapMovieClip.addEventListener(MouseEvent.CLICK, bitmapMovieClipClick);
			this.bitmapMovieClip.addEventListener(MouseEvent.MOUSE_DOWN, bitmapMovieClipDown);
			this.bitmapMovieClip.addEventListener(MouseEvent.MOUSE_UP, bitmapMovieClipUp);
			//this.manager.push(this.bitmapMovieClip);
			bitmapMovieClip.play();
			//this.spt.addChild(mc);
			//mc = null;
		}
		//this.manager.startRender();
		/*spt.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		spt.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);*/
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
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		spt.stopDrag();
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		spt.startDrag();
		//this.manager.destory();
	}
	
}
}