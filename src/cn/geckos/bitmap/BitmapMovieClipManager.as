package cn.geckos.bitmap 
{
import cn.geckos.bitmap.BitmapMovieClip;
import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;
/**
 * ...位图动画管理
 * @author Kanon
 */
public class BitmapMovieClipManager 
{
	private var bmcDictory:Dictionary;
	private var shape:Shape;
	public function BitmapMovieClipManager() 
	{
		this.initData();
	}
	
	/**
	 * 初始化
	 */
	private function initData():void
	{
		this.bmcDictory = new Dictionary();
	}
	
	/**
	 * 开始播放
	 */
	public function startRender():void
	{
		if (!this.shape)
			this.shape = new Shape();
		if (!this.shape.hasEventListener(Event.ENTER_FRAME))
			this.shape.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	/**
	 * 暂停播放
	 */
	public function stopRender():void
	{
		if (this.shape)
			this.shape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		if (!this.bmcDictory) return;
		for each (var bmc:BitmapMovieClip in this.bmcDictory) 
		{
			bmc.nextFrame();
		}
	}
	
	/**
	 * 放入列表
	 * @param	bmc 位图动画对象
	 */
	public function push(bmc:BitmapMovieClip):void
	{
		if (this.bmcDictory)
			this.bmcDictory[bmc] = bmc;
	}
	
	/**
	 * 删除某个在列表中的位图动画
	 * @param	bmc 位图动画对象
	 */
	public function remove(bmc:BitmapMovieClip):void
	{
		if (this.bmcDictory)
			delete this.bmcDictory[bmc];
	}
	
	/**
	 * 播放所有位图动画
	 */
	public function playAllBitmapMovieClip():void
	{
		this.startRender();
	}
	
	/**
	 * 停止所有位图动画
	 */
	public function stopAllBitmapMovieClip():void
	{
		this.stopRender();
	}
	
	/**
	 * 所有的位图动画播放某一帧
	 * @param	frame  跳转的帧
	 */
	public function gotoAndPlayAllBitmapMovieClip(frame:int):void
	{
		this.gotoAndStopAllBitmapMovieClip(frame);
		this.startRender();
	}
	
	/**
	 * 所有的位图动画停止到某一帧
	 * @param	frame
	 */
	public function gotoAndStopAllBitmapMovieClip(frame:int):void
	{
		this.stopRender();
		for each (var bmc:BitmapMovieClip in this.bmcDictory) 
		{
			bmc.gotoAndStop(frame);
		}
	}
	
	/**
	 * 销毁所有的位图动画
	 */
	public function destoryAllBitmapMovieClip():void
	{
		for each (var bmc:BitmapMovieClip in this.bmcDictory) 
		{
			bmc.destory();
			bmc = null;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destory():void
	{
		this.destoryAllBitmapMovieClip();
		this.bmcDictory = null;
		if (this.shape)
		{
			if (this.shape.hasEventListener(Event.ENTER_FRAME))
				this.shape.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			this.shape = null;
		}
	}
}
}