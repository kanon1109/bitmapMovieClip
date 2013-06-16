package cn.geckos.bitmap
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
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
	//需要显示这个位图动画的容器
	protected var container:Sprite;
	//存放多个帧的位图列表。
	protected var bitmapDataList:Vector.<BitmapData>;
	//一个位图用于创建位图动画
	protected var _bitmap:Bitmap;
	//当前帧
	protected var _currentFrame:int = 1;
	//总帧数 
	protected var _totalFrames:int;
	//可见值
	protected var _visible:Boolean;
	//纵横缩放比例
	protected var _scaleX:Number = 1;
	protected var _scaleY:Number = 1;
	//实例名
	protected var _name:String;
	//按钮模式
	protected var _buttonMode:Boolean;
	//是否允许鼠标点击
	protected var _mouseEnabled:Boolean;
	protected var _mouseChildren:Boolean
	//坐标
	protected var _x:Number = 0
	protected var _y:Number = 0;
	//高宽
	protected var _width:Number;
	protected var _height:Number;
	//透明度 0-1
	protected var _alpha:Number;
	//---private----
	//需要创建位图动画的mc
	private var mc:MovieClip;
	//保存尺寸的对象
	private var drawRectangle:Rectangle;
	//动画是否在播放
	private var _isPlaying:Boolean;
	public function BitmapMovieClip(movieClip:MovieClip, bitmapDataList:Vector.<BitmapData>, 
									rect:Rectangle, container:Sprite)
	{
		this.mc = movieClip;
		this.container = container;
		this.drawRectangle = rect;
		this._totalFrames = mc.totalFrames;
		this.bitmapDataList = bitmapDataList;
		this.createBitmap(this.drawRectangle.left, this.drawRectangle.top, this.mc, container);
		//默认播放第一帧
		this.gotoAndStop(this._currentFrame);
		this.mouseEnabled = true;
	}
	
	/**
	 * 获取绘制mc的范围
	 * @param	movieClip	需要绘制的mc
	 * @return	范围矩形
	 */
	public static function getDrawRectangle(movieClip:MovieClip):Rectangle
	{
		var totalFrames:int = movieClip.totalFrames;
		var maxWidth:Number = 0;
		var maxHeight:Number = 0;
		var maxTop:Number = 0;
		var maxLeft:Number = 0;
		var maxRight:Number = 0;
		var maxBottom:Number = 0;
		var rect:Rectangle;
		for (var i:int = 1; i <= totalFrames; i += 1)
		{
			movieClip.gotoAndStop(i);
			//获取最左上角的坐标 用于计算最大高宽
			rect = movieClip.getBounds(movieClip);
			if (rect.left < maxLeft)
				maxLeft = rect.left;
			if (rect.top < maxTop)
				maxTop = rect.top;
			//获取最右下角的坐标 用于计算最大高宽
			if (rect.right > maxRight)
				maxRight = rect.right;
			if (rect.bottom > maxBottom)
				maxBottom = rect.bottom;
		}
		//获取最大的高宽
		maxWidth = maxRight - maxLeft;
		maxHeight = maxBottom - maxTop;
		return new Rectangle(maxLeft, maxTop, maxWidth, maxHeight);
	}
	
	/**
	 * 将mc转换成bitmapData序列
	 * @param	movieClip	需要转换的mc
	 * @return	位图序列
	 */
	public static function drawMovieClip(movieClip:MovieClip, rect:Rectangle):Vector.<BitmapData>
	{
		var totalFrames:int = movieClip.totalFrames;
		var vect:Vector.<BitmapData> = new Vector.<BitmapData>();
		var bitmapData:BitmapData;
		var matrix:Matrix = new Matrix(1, 0, 0, 1, -rect.left, -rect.top);
		for (var i:int = 1; i <= totalFrames; i += 1)
		{
			movieClip.gotoAndStop(i);
			bitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
			bitmapData.draw(movieClip, matrix);
			vect.push(bitmapData);
		}
		return vect;
	}
	
	/**
	 *  * 创建位图
	 * @param	maxLeft	左坐标
	 * @param	maxTop	上坐标
	 * @param	mc		绘制的mc
	 * @param	container 容器
	 */
	private function createBitmap(maxLeft:Number, maxTop:Number, mc:MovieClip, container:Sprite):void
	{
		if (this._bitmap) return;
		this._bitmap = new Bitmap();
		this._bitmap.smoothing = true;
		this._bitmap.x = mc.x + maxLeft;
		this._bitmap.y = mc.y + maxTop;
		container.addChild(this._bitmap);
	}
	
	/**
	 * 播放
	 */
	public function play():void
	{
		if (!this._bitmap) return;
		if (!this._bitmap.hasEventListener(Event.ENTER_FRAME))
			this._bitmap.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this._isPlaying = true;
	}
	
	/**
	 * 暂停
	 */
	public function stop():void
	{
		if (!this._bitmap) return;
		if (this._bitmap.hasEventListener(Event.ENTER_FRAME))
			this._bitmap.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		this._isPlaying = false;
	}
	
	/**
	 * 从某一帧开始播放
	 * @param	frame  帧
	 */
	public function gotoAndPlay(frame:int):void
	{
		if (!this._bitmap) return;
		this._currentFrame = frame;
		this.checkCurrentFrame();
		this._bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
		this.play();
	}
	
	/**
	 * 暂停在某一帧
	 * @param	frame 帧
	 */
	public function gotoAndStop(frame:int):void
	{
		if (!this._bitmap) return;
		this.stop();
		this._currentFrame = frame;
		this.checkCurrentFrame();
		this._bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	/**
	 * 下一帧
	 */
	public function nextFrame():void
	{
		this.stop();
		this._currentFrame++;
		this.checkCurrentFrame();
		this._bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	/**
	 * 上一帧
	 */
	public function prevFrame():void
	{
		this.stop();
		this._currentFrame--;
		this.checkCurrentFrame();
		this._bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
	}
	
	/**
	 * 被添加进显示对象
	 * @param	container  外部容器
	 */
	public function addChildToParent(container:DisplayObjectContainer):void
	{
		if (!container) return;
		if (!this._bitmap) return;
		if (this.container == container) return;
		this.container = Sprite(container);
		this.container.addChild(this._bitmap);
	}
	
	/**
	 * 从外部容器删除
	 */
	public function removeFromParent():void
	{
		if (!this._bitmap) return;
		if (!this.container) return;
		this.container.removeChild(this._bitmap);
		this.container = null;
	}
	
	/**
	 * 添加到显示对象中去
	 * @param	displayObject 显示对象
	 * @param	pos           要添加到的位置
	 */
	public function addChild(displayObject:DisplayObject, pos:Point):void
	{
		if (!this.container) return;
		if (!this.mc) return;
		if (this.container == displayObject)
			throw new ArgumentError("Error #2150: 无法将对象添加为自身的子对象（或孙对象）的子对象。", 2150);
		if (this.mc.contains(displayObject)) return;
		this.mc.addChild(displayObject);
		displayObject.x = pos.x;
		displayObject.y = pos.y;
		//先保存之前的一些数据
		this.updateBitmapDataList();
	}
	
	/**
	 * 将内部的显示对象销毁
	 * @param	displayObject  需要销毁的显示对象
	 */
	public function removeChild(displayObject:DisplayObject):void
	{
		if (!this.container) return;
		if (!this.mc) return;
		if (!this.mc.contains(displayObject)) return;
		if (displayObject && 
			displayObject.parent)
			displayObject.parent.removeChild(displayObject);
		else
			return;
		this.updateBitmapDataList();
	}
	
	/**
	 * 更新位图数据列表
	 */
	protected function updateBitmapDataList():void
	{
		if (!this.mc) return;
		var isPlaying:Boolean = this._isPlaying;
		if (isPlaying) this.stop();
		var prevLeft:Number = this.drawRectangle.left;
		var prevTop:Number = this.drawRectangle.top;
		this.drawRectangle = BitmapMovieClip.getDrawRectangle(this.mc);
		this.removeBitmapDataList();
		this.bitmapDataList = BitmapMovieClip.drawMovieClip(this.mc, this.drawRectangle);
		this.x -= prevLeft - this.drawRectangle.left;
		this.y -= prevTop - this.drawRectangle.top;
		this.gotoAndStop(this._currentFrame);
		if (isPlaying) this.play();
	}
	
	/**
	 * 渲染
	 */
	protected function doRender():void
	{
		if (!this.bitmapDataList) return;
		this._bitmap.bitmapData = this.bitmapDataList[this._currentFrame - 1];
		this._currentFrame++;
		this.checkCurrentFrame();
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		this.doRender();
	}
	
	/**
	 * 判断当前帧是否越界
	 * @param	bitmapDataList 位图数据列表
	 */
	private function checkCurrentFrame():void
	{
		if (this._currentFrame > this.bitmapDataList.length)
			this._currentFrame = 1;
		else if (this._currentFrame <= 0)
			this._currentFrame = this.totalFrames;
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
	 * 2个位图精确碰撞
	 * @param	bitmapData  位图数据
	 * @return  是否碰撞
	 */
	public function hitTest(bitmap:Bitmap):Boolean
	{
		if (bitmap && 
			bitmap.parent && 
			this._bitmap && 
			this._bitmap.parent)
		{
			var p1:Point = new Point(this._bitmap.x, this._bitmap.y);
			var p2:Point = new Point(bitmap.x, bitmap.y);
			//转成全局坐标防止,层级不同时碰撞不同。
			p1 = this._bitmap.parent.localToGlobal(p1);
			p2 = bitmap.parent.localToGlobal(p2);
			return this._bitmap.bitmapData.hitTest(p1, 0xFF, bitmap.bitmapData, p2, 0xFF);
		}
		return false;
	}
	
	/**
	 * 位图动画碰撞检测
	 * @param	bitmapMc  位图动画
	 * @return  是否碰撞
	 */
	public function hitTestBitmapMovieClip(bitmapMc:BitmapMovieClip):Boolean
	{
		if (bitmapMc && bitmapMc.bitmap)
			return this.hitTest(bitmapMc.bitmap);
		return false;
	}
	
	/**
	 * 是否碰撞到显示对象
	 * @param	obj  显示对象
	 * @return  是否碰撞
	 */
	public function hitTestObject(obj:DisplayObject):Boolean
	{
		if (this._bitmap && obj)
			return this._bitmap.hitTestObject(obj);
		return false;
	}
	
	/**
	 * 与某个坐标是否发生碰撞
	 * @param	x          x坐标
	 * @param	y		   y坐标
	 * @param	shapeFlag  碰撞到矩形范围还实际像素
	 * @return  是否碰撞
	 */
	public function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean=false):Boolean
	{
		if (this._bitmap)
			return this._bitmap.hitTestPoint(x, y, shapeFlag);
		return false;
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
		if (this._bitmap)
			this._bitmap.visible = value;
	}
	
	/**
	 * x缩放比例
	 */
	public function get scaleX():Number { return _scaleX; };
	public function set scaleX(value:Number):void 
	{
		_scaleX = value;
		this._bitmap.scaleX = this.scaleX;
	}
	
	/**
	 * y缩放比例
	 */
	public function get scaleY():Number { return _scaleY; };
	public function set scaleY(value:Number):void 
	{
		_scaleY = value;
		this._bitmap.scaleY = this.scaleY;
	}
	
	public function get name():String { return _name; };
	public function set name(value:String):void 
	{
		_name = value;
		if (this._bitmap)
			this._bitmap.name = this.name;
	}
	
	/**
	 * 按钮模式
	 */
	public function get buttonMode():Boolean { return _buttonMode; };
	public function set buttonMode(value:Boolean):void 
	{
		_buttonMode = value;
		if (!this.container || !this.container.stage) return;
		if (this.buttonMode)
			this.container.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		else
			this.container.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		this.container.buttonMode = value;
	}
	
	/**
	 * 鼠标事件
	 */
	public function get mouseEnabled():Boolean { return _mouseEnabled; };
	public function set mouseEnabled(value:Boolean):void 
	{
		_mouseEnabled = value;
		if (!this.container || !this.container.stage) return;
		if (this.mouseEnabled)
		{
			this.container.stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.container.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.container.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		else
		{
			this.container.stage.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.container.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.container.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
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
		if (!this._bitmap || !this._bitmap.parent) return;
		//首先需要把屏幕上的鼠标坐标位置转换为bitmap内的鼠标位置
		var localPos:Point = this._bitmap.globalToLocal(new Point(event.stageX, event.stageY));
		if (this.isTransparentPoint(localPos, this._bitmap.bitmapData))
			this.container.buttonMode = false;
		else
			this.container.buttonMode = true;
	}
	
	/**
	 * 鼠标事件操作
	 * @param	eventType  事件类型
	 * @param	mousePos   鼠标位置
	 */ 
	private function mouseEventOption(event:MouseEvent):void
	{
		if (!this._bitmap) return;
		var localPos:Point = this._bitmap.globalToLocal(new Point(event.stageX, event.stageY));
		if (!this.isTransparentPoint(localPos, this._bitmap.bitmapData))
			this.dispatchEvent(event);
	}
	
	/**
	 * 删除位图数据列表
	 */
	private function removeBitmapDataList():void
	{
		if (!this.bitmapDataList) return;
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
	 * 销毁位图对象
	 */
	private function removeBitmap():void
	{
		if (this._bitmap && 
			this._bitmap.parent)
			this._bitmap.parent.removeChild(this._bitmap);
		this._bitmap = null;
	}
	
	/**
	 * 销毁mc
	 */
	private function removeMovieClip():void
	{
		if (this.mc && 
			this.mc.parent)
		{
			var numChildren:int = this.mc.numChildren;
			for (var i:int = numChildren - 1; i >= 0; i -= 1)
			{
				this.mc.removeChild(this.mc.getChildAt(i));
			}
			this.mc.parent.removeChild(this.mc);
		}
		this.mc = null;
	}
	
	/**
	 * 移动到某个位置
	 * @param	x  x坐标
	 * @param	y  y坐标
	 */
	public function move(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
	}
	
	/**
	 * 克隆一个位图动画，当如果重复需要创建相同的
	 * 位图动画时，推荐使用clone，可以方便快速生成副本(因为不需要draw)。
	 * @return
	 */
	public function clone(depth:Boolean = true):BitmapMovieClip
	{
		var bitmapDataList:Vector.<BitmapData>;
		if (depth)
		{
			bitmapDataList = new Vector.<BitmapData>();
			var length:int = this.bitmapDataList.length;
			var bitmapData:BitmapData;
			for (var i:int = 0; i < length; i += 1)
			{
				bitmapData = this.bitmapDataList[i];
				bitmapData.lock();
				bitmapDataList.push(bitmapData.clone());
				bitmapData.unlock();
			}
		}
		else bitmapDataList = this.bitmapDataList.slice();
		var drawRectangle:Rectangle = this.drawRectangle.clone();
		var bitmapMovieClip:BitmapMovieClip = new BitmapMovieClip(this.mc, bitmapDataList, drawRectangle, this.container);
		return bitmapMovieClip;
	}
	
	/**
	 * x坐标
	 */
	public function get x():Number{ return _x; }
	public function set x(value:Number):void 
	{
		_x = value;
		this._bitmap.x = this.x;
	}
	
	/**
	 * y坐标
	 */
	public function get y():Number{ return _y; }
	public function set y(value:Number):void 
	{
		_y = value;
		this._bitmap.y = this.y;
	}
	
	/**
	 * 宽度
	 */
	public function get width():Number{ return this._bitmap.width; }
	public function set width(value:Number):void 
	{
		_width = value;
		this._bitmap.width = width;
	}
	
	/**
	 * 高度
	 */
	public function get height():Number { return this._bitmap.height; };
	public function set height(value:Number):void 
	{
		_height = value;
		this._bitmap.height = width;
	}
	
	/**
	 * 透明度
	 */
	public function get alpha():Number { return _alpha; }
	public function set alpha(value:Number):void 
	{
		_alpha = value;
		if (_alpha < 0)
			_alpha = 0;
		else if (_alpha > 1) 
			_alpha = 1;
		this._bitmap.alpha = alpha;
	}
	
	/**
	 * 是否在播放中
	 */
	public function get isPlaying():Boolean { return _isPlaying; }
	
	/**
	 * 位图对象
	 */
	public function get bitmap():Bitmap { return _bitmap; }
	
	/**
	 * 子对象是否可接受鼠标事件
	 */
	public function get mouseChildren():Boolean{ return _mouseChildren; }
	public function set mouseChildren(value:Boolean):void 
	{
		_mouseChildren = value;
		this.mc.mouseChildren = this.mouseChildren;
	}
	
	/**
	 * 销毁自己
	 */
	public function destroy():void
	{
		this.stop();
		this.removeBitmapDataList();
		this.buttonMode = false;
		this.mouseEnabled = false;
		this.container = null;
		this.removeMovieClip();
		this.drawRectangle = null;
		this.removeBitmap();
	}
}
}