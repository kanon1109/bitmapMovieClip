package cn.geckos.bitmap
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * ...位图动画 
 * 在子显示对象很多的影片剪辑里，移动舞台或者移动容器效率低下。
 * 为了提高效率，将影片剪辑的每一帧绘制成位图以便提高运动或移动时的效率
 * @author Kanon
 */
public class BitmapMovieClip extends EventDispatcher
{
	private var bitmap:Bitmap;
	private var bitmapDataList:Array;
	//当前帧
	private var _currentFrame:int = 1;
	private var _totalFrames:int;
	private var _visible:Boolean;
	private var _scaleX:int = 1;
	private var _scaleY:int = 1;
	private var mc:MovieClip;
	private var size:Object;
	private var _name:String;
	//需要显示这个位图动画的容器
	private var container:Sprite;
	//按钮模式
	private var _buttonMode:Boolean;
	private var _mouseEnabled:Boolean;
	public function BitmapMovieClip(mc:MovieClip, container:Sprite)
	{
		if (!mc) 
			throw new Error("需要转换的影片剪辑不存在");
		this.mc = mc;
		this.container = container;
		this.size = this.getMaxSize(mc);
		this._totalFrames = mc.totalFrames;
		this.bitmapDataList = this.drawMovieClip(this.mc, this.size.maxWidth, this.size.maxHeight, 
												 this.size.maxLeft, this.size.maxTop);
		this.createBitmap(this.size.maxLeft, this.size.maxTop, this.mc, container);
		//默认播放第一帧
		this.gotoAndStop(this._currentFrame);
		this.mouseEnabled = true;
	}
	
	/**
	 * 创建位图
	 * @param	mc 容器
	 * @param	contener 容器
	 */
	private function createBitmap(maxLeft:Number, maxTop:Number, mc:MovieClip, container:Sprite):void
	{
		if (this.bitmap) return;
		this.bitmap = new Bitmap();
		this.bitmap.smoothing = true;
		var rect:Rectangle = mc.getBounds(mc);
		this.bitmap.x = mc.x + maxLeft;
		this.bitmap.y = mc.y + maxTop;
		container.addChild(this.bitmap);
	}
	
	/**
	 * 播放
	 */
	public function play():void
	{
		if (!this.bitmap) return;
		if (!this.bitmap.hasEventListener(Event.ENTER_FRAME))
			this.bitmap.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	/**
	 * 暂停
	 */
	public function stop():void
	{
		if (this.bitmap.hasEventListener(Event.ENTER_FRAME))
			this.bitmap.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	/**
	 * 从某一帧开始播放
	 * @param	frame  帧
	 */
	public function gotoAndPlay(frame:int):void
	{
		this._currentFrame = frame;
		this.checkCurrentFrame(this.bitmapDataList);
		this.bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
		this.play();
	}
	
	/**
	 * 暂停在某一帧
	 * @param	frame 帧
	 */
	public function gotoAndStop(frame:int):void
	{
		this.stop();
		this._currentFrame = frame;
		this.checkCurrentFrame(this.bitmapDataList);
		this.bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	/**
	 * 下一帧
	 */
	public function nextFrame():void
	{
		this.stop();
		this._currentFrame++;
		this.checkCurrentFrame(this.bitmapDataList);
		this.bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	/**
	 * 上一帧
	 */
	public function prevFrame():void
	{
		this.stop();
		this._currentFrame--;
		this.checkCurrentFrame(this.bitmapDataList);
		this.bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		this.bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
		this._currentFrame++;
		this.checkCurrentFrame(this.bitmapDataList);
	}
	
	/**
	 * 判断当前帧是否越界
	 * @param	bitmapDataList 位图数据列表
	 */
	private function checkCurrentFrame(bitmapDataList:Array):void
	{
		if (this._currentFrame > bitmapDataList.length)
			this._currentFrame = 1;
		else if (this._currentFrame <= 0)
			this._currentFrame = this.totalFrames;
	}
	
	/**
	 * 获取影片剪辑尺寸
	 * @param	mc  需要转换bitmapMovieClip的 影片剪辑
	 * @return  尺寸数据对象
	 */
	private function getMaxSize(mc:MovieClip):Object
	{
		var totalFrames:int = mc.totalFrames;
		mc.gotoAndStop(1);
		var rect:Rectangle = mc.getBounds(mc);
		var maxRight:Number = rect.right;
		var maxBottom:Number = rect.bottom;
		var maxLeft:Number = rect.left;
		var maxTop:Number = rect.top;
		//最大高宽
		var maxWidth:Number = rect.right - rect.left;
		var maxHeight:Number = rect.bottom - rect.top;
		if (totalFrames == 1)
			return { "maxWidth":maxWidth, "maxHeight":maxHeight, 
					 "maxLeft":maxLeft, "maxTop":maxTop };
		for (var i:int = 2; i <= totalFrames; i += 1)
		{
			mc.gotoAndStop(i);
			//找出矩形范围最大的位置
			rect = mc.getBounds(mc);
			if (rect.right > maxRight) 
				maxRight = rect.right;
			if (rect.bottom > maxBottom) 
				maxBottom = rect.bottom;
			if (rect.left < maxLeft) 
				maxLeft = rect.left;
			if (rect.top < maxTop)
				maxTop = rect.top;
		}
		maxWidth = maxRight - maxLeft;
		maxHeight = maxBottom - maxTop;
		return { "maxWidth":maxWidth, "maxHeight":maxHeight, 
				 "maxLeft":maxLeft, "maxTop":maxTop };
	}
	
	/**
	 * 绘制mc的位图数据
	 * @param	mc      需要绘制的mc
	 * @param	width   宽度
	 * @param	height  高度
	 * @param	left  	mc的矩形范围最左位置
	 * @param	top  	mc的矩形范围最上位置
	 * @return
	 */
	private function drawMovieClip(mc:MovieClip, width:Number, height:Number, maxLeft:Number, maxTop:Number):Array
	{
		var bitmapDataList:Array = [];
		var matrix:Matrix = new Matrix();
		var totalFrames:int = mc.totalFrames;
		for (var i:int = 1; i <= totalFrames; i += 1)
		{
			mc.gotoAndStop(i);
			matrix.tx = -maxLeft;
			matrix.ty = -maxTop;
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x000000);
			bitmapData.draw(mc, matrix); 
			bitmapDataList.push(bitmapData);
		}
		return bitmapDataList;
	}
	
	/**
	 * 是否是透明区域
	 * @param	pos         需要确认的透明位置
	 * @param	bitmapData  位图
	 * @return  是否是透明
	 */
	protected function isTransparentPoint(pos:Point, bitmapData:BitmapData):Boolean
	{
		if (!bitmapData) return false;
		var color:uint = bitmapData.getPixel32(pos.x, pos.y);
		//获取alpha通道
		var alpha:uint = color >> 24;
		return alpha == 0;
	}
	
	/**
	 * 当前帧
	 */
	public function get currentFrame():int { return _currentFrame; };
	
	/**
	 * 总帧数
	 */
	public function get totalFrames():int { return _totalFrames; };
	
	/**
	 * 设置可见值
	 */
	public function get visible():Boolean { return _visible; };
	public function set visible(value:Boolean):void 
	{
		_visible = value;
		if (this.bitmap)
			this.bitmap.visible = value;
	}
	
	/**
	 * x缩放比例
	 */
	public function get scaleX():int { return _scaleX; };
	public function set scaleX(value:int):void 
	{
		_scaleX = value;
		if (this.scaleX > 0)
			this.bitmap.x = this.mc.x + this.size.maxLeft;
		else if (this.scaleX < 0)
			this.bitmap.x = this.mc.x - this.size.maxLeft;
		this.bitmap.scaleX = this.scaleX;
	}
	
	/**
	 * y缩放比例
	 */
	public function get scaleY():int { return _scaleY; };
	public function set scaleY(value:int):void 
	{
		_scaleY = value;
		if (this.scaleY > 0)
			this.bitmap.y = this.mc.y + this.size.maxTop;
		else if (this.scaleY < 0)
			this.bitmap.y = this.mc.y - this.size.maxTop;
		this.bitmap.scaleY = this.scaleY;
	}
	
	public function get name():String { return _name; };
	public function set name(value:String):void 
	{
		_name = value;
		if (this.bitmap)
			this.bitmap.name = this.name;
	}
	
	/**
	 * 按钮模式
	 */
	public function get buttonMode():Boolean { return _buttonMode; };
	public function set buttonMode(value:Boolean):void 
	{
		_buttonMode = value;
		if (this.container)
		{
			this.container.buttonMode = this.buttonMode;
			if (this.buttonMode)
			{
				this.container.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				this.container.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
			else
			{
				this.container.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
				this.container.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
				this.container.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			}
		}
	}
	
	/**
	 * 鼠标事件
	 */
	public function get mouseEnabled():Boolean { return _mouseEnabled; };
	public function set mouseEnabled(value:Boolean):void 
	{
		_mouseEnabled = value;
		if (this.mouseEnabled)
		{
			this.container.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.container.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.container.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		else
		{
			this.container.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.container.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.container.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
	}
	
	private function mouseClickHandler(event:MouseEvent):void 
	{
		this.mouseEventOption(event);
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		this.mouseEventOption(event);
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		this.mouseEventOption(event);
	}
	
	private function mouseMoveHandler(event:MouseEvent):void 
	{
		//首先需要把屏幕上的鼠标坐标位置转换为bitmap内的鼠标位置
		var localPos:Point = this.bitmap.globalToLocal(new Point(event.stageX, event.stageY));
		if (this.isTransparentPoint(localPos, this.bitmap.bitmapData))
			this.container.buttonMode = false;
		else
			this.container.buttonMode = true;
	}
	
	private function rollOutHandler(event:MouseEvent):void 
	{
		this.container.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	private function rollOverHandler(event:MouseEvent):void 
	{
		this.container.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	/**
	 * 鼠标事件操作
	 * @param	eventType  事件类型
	 * @param	mousePos   鼠标位置
	 */ 
	private function mouseEventOption(event:MouseEvent):void
	{
		if (!this.bitmap) return;
		var localPos:Point = this.bitmap.globalToLocal(new Point(event.stageX, event.stageY));
		if (!this.isTransparentPoint(localPos, this.bitmap.bitmapData))
			this.dispatchEvent(event);
	}
	
	/**
	 * 删除位图数据列表
	 */
	private function removeBitmapDataList():void
	{
		var length:int = this.bitmapDataList.length;
		for (var i:int = length - 1; i >= 0; i -= 1)
		{
			var bitmapData:BitmapData = this.bitmapDataList[i];
			bitmapData.dispose();
			this.bitmapDataList.splice(i, 1);
		}
		this.bitmapDataList = null;
	}
	
	/**
	 * 销毁自己
	 */
	public function destory():void
	{
		this.stop();
		this.removeBitmapDataList();
		if (this.bitmap && 
			this.bitmap.parent)
			this.bitmap.parent.removeChild(this.bitmap);
		this.buttonMode = false;
		this.mouseEnabled = false;
		this.container = null;
		this.mc = null;
		this.bitmap = null;
	}
	
}
}