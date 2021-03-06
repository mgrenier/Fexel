package
{
	import apparat.math.FastMath;
	
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.events.*;
	import com.mgrenier.fexel.*;
	import com.mgrenier.fexel.display.*;
	import com.mgrenier.utils.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.System;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.utils.getTimer;
	import flash.display.BlendMode;
	import com.mgrenier.fexel.display.SpriteSheet;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.media.Camera;
	
	[SWF(backgroundColor="#000000", frameRate="30", width="400", height="400")]
	public class Sandbox2 extends Sprite
	{
		protected var params:Object;
		
		public function Sandbox2():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		final private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, uninit);
			// entry point
			this.initialize();
			
			Console.level = Console.DEBUG | Console.LOG;
			addChild(Console.getInstance());
			Console.addEventListener(ConsoleEvent.COMMAND, this.command);
			
			addChild(Input.getInstance());
			
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
		
		final private function uninit(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, uninit);
			addEventListener(Event.ADDED_TO_STAGE, init);
			// exit point
			this.uninitialize();
			
			removeChild(Console.getInstance());
			Console.removeEventListener(ConsoleEvent.COMMAND, this.command);
			
			removeChild(Input.getInstance());
		}
		
		[Embed(source="assets/YoshiSprite.gif")]
		protected var yoshi:Class;
		
		protected var _stage:Stage;
		protected var _screen1:Screen;
		protected var _screen2:Screen;
		protected var _tv:com.mgrenier.fexel.display.Bitmap;
		protected var _text:Text;
		protected var _shape:Shape;
		protected var _yoshi:AnimatedSpriteSheet;
		protected var _container:DisplayObjectContainer;
		
		protected function initialize ():void
		{
			_stage = new Stage();
			_screen1 = new Screen(stage.stageWidth / 2, stage.stageHeight);
			_screen1.debug = Screen.DEBUG_BOUNDINGBOX;
			_screen2 = new Screen(stage.stageWidth / 2, stage.stageHeight);
			_screen2.x = stage.stageWidth / 2;
			//_screen.zoom = 1.5;
			
			_text = new Text(200, "Hello World A", 30);
			_text.x = 250;
			_text.y = 200;
			_text.update();
			
			_tv = new com.mgrenier.fexel.display.Bitmap(200, 200);
			_tv.scaleX = _tv.scaleY = 0.5;
			_tv.x = 100;
			_tv.y = 100;
			
			_yoshi = new AnimatedSpriteSheet(48, 48, 12);
			_yoshi.spriteData = TextureLoader.load("yoshi", this.yoshi);
			_yoshi.addAnimation("runRight", new <int>[21, 22, 23, 24], true);
			_yoshi.play("runRight");
			_yoshi.x = 50;
			_yoshi.y = 200;
			_yoshi.update(30);
			
			_shape = new Shape(50, 50);
			_shape.x = stage.stageWidth / 2 / 2 - 25;
			_shape.y = stage.stageHeight / 2 - 25;
			_shape.graphics.beginFill(0xffffff);
			_shape.graphics.drawRect(0, 0, 50, 50);
			_shape.graphics.endFill();
			_shape.update();
			
			_container = new DisplayObjectContainer();
			_container.x = 100;
			_container.y = 100;
			
			_stage.addScreen(_screen1);
			_stage.addScreen(_screen2);
			addChild(_screen1);
			addChild(_screen2);
			
			_stage.addChild(_container);
			//_stage.addChild(_yoshi);
			_container.addChild(_yoshi);
			_stage.addChild(_shape);
			//_stage.addChild(_text);
			//_stage.addChild(_tv);
			
			
			this.addEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function enterFrame (e:Event = null):void
		{
			if (Input.keyState(Input.SPACE))
			{
				Memory.forceGC();
			}
			
			var step:int = 2;
			
			if (Input.keyState(Input.UP))
				_screen1.camY -= step;
			if (Input.keyState(Input.DOWN))
				_screen1.camY += step;
			if (Input.keyState(Input.RIGHT))
				_screen1.camX -= step;
			if (Input.keyState(Input.LEFT))
				_screen1.camX += step;
			
			if (Input.keyState(Input.W)) {
				_screen1.camStretchX += 0.05;
				_screen1.camStretchY += 0.05;
			}
			if (Input.keyState(Input.S)) {
				_screen1.camStretchX -= 0.05;
				_screen1.camStretchY -= 0.05;
			}
			if (Input.keyState(Input.A))
				_screen1.camRotation -= step;
			if (Input.keyState(Input.D))
				_screen1.camRotation += step;
			
			if (Input.keyState(Input.NUMPAD_0))
			{
				_screen1.camStretchX = _screen1.camStretchY = 1;
				_screen1.camX = stage.stageWidth / 2 / 2;
				_screen1.camY = stage.stageHeight / 2;
				_screen1.camRotation = 0;
			}
			
			
			//_screen.camRotation += 0.5;
			
			_yoshi.colorTransform.color = _text.colorTransform.color = Math.random() * 0xffffff;
			//_yoshi.blend = _text.blend = BlendMode.DIFFERENCE;
			//_yoshi.colorTransform.redMultiplier = _yoshi.colorTransform.greenMultiplier = _yoshi.colorTransform.blueMultiplier = _yoshi.colorTransform.alphaMultiplier = _text.colorTransform.redMultiplier = _text.colorTransform.greenMultiplier = _text.colorTransform.blueMultiplier = _text.colorTransform.alphaMultiplier = Math.max(0.8, Math.random());
			
			if (_tv.bitmapData)
				_tv.bitmapData.dispose();
			_tv.bitmapData = _screen1.bitmapData.clone();
			_stage.render();
		}
		
		protected function uninitialize ():void
		{
			this.removeEventListener(Event.ENTER_FRAME, this.enterFrame);
		}
		
		protected function command (e:ConsoleEvent):void
		{
			switch (e.text)
			{
				default:
					trace(e.text);
			}
		}
		
	}
}
