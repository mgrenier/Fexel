package com.mgrenier.fexel.display 
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import com.mgrenier.geom.Rectangle2D;
	
	/**
	 * Display Object Container
	 * 
	 * @author Michael Grenier
	 */
	public class DisplayObjectContainer extends DisplayObject
	{
		protected var childs:Vector.<DisplayObject>;
		
		private var _matrix:Matrix;
		private var _color:ColorTransform;
		
		/**
		 * Constructor
		 */
		public function DisplayObjectContainer() 
		{
			super();
			
			this.childs = new Vector.<DisplayObject>();
			this._matrix = new Matrix();
			this._color = new ColorTransform();
		}
		
		/**
		 * Dispose World
		 */
		override public function dispose ():void
		{
			var c:DisplayObject;
			while (c = this.childs.pop())
			{
				c.dispose();
				c = null;
			}
			this.childs = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		override public function update (rate:int = 0):void
		{
			var i:int,
				n:int,
				c:DisplayObject;
			
			for (i = 0, n = this.childs.length; i < n; ++i)
			{
				c = this.childs[i];
				c.update(rate);
			}
		}
		
		/**
		 * Render to buffer
		 * 
		 * @param	buffer
		 * @param	rect
		 * @param	bounds
		 * @param	transformation
		 * @param	color
		 * @param	debug
		 * @param	debugColor
		 */
		override fexel function render (buffer:BitmapData, rect:Rectangle2D, bounds:Rectangle2D, matrix:Matrix, color:ColorTransform, debug:uint, debugColor:DebugColor):void
		{
			var i:int,
				n:int,
				c:DisplayObject,
				m:Matrix = this.getMatrix();
			
			this._matrix.a = m.a;
			this._matrix.b = m.b;
			this._matrix.c = m.c;
			this._matrix.d = m.d;
			this._matrix.tx = m.tx;
			this._matrix.ty = m.ty;
			
			this._matrix.translate(-this.refX, -this.refY);
			this._matrix.concat(matrix);
			this._matrix.translate(this.refX, this.refY);
			
			this._color.alphaMultiplier = color.alphaMultiplier;
			this._color.alphaOffset = color.alphaOffset;
			this._color.redMultiplier = color.redMultiplier;
			this._color.redOffset = color.redOffset;
			this._color.greenMultiplier = color.greenMultiplier;
			this._color.greenOffset = color.greenOffset;
			this._color.blueMultiplier = color.blueMultiplier;
			this._color.blueOffset = color.blueOffset;
			
			this._color.concat(this.colorTransform);
			
			for (i = 0, n = this.childs.length; i < n; ++i)
			{
				c = this.childs[i];
				c.preRender(rect, bounds, this._matrix, this._color);
				if (!rect.intersects(c._bounds))
					continue;
				c.render(buffer, rect, bounds, this._matrix, this._color, debug, debugColor);
			}
		}
		
		/**
		 * Get child
		 * 
		 * @return
		 */
		public function children ():Vector.<DisplayObject>
		{
			return this.childs;
		}
		
		/**
		 * Add child
		 * 
		 * @param	e
		 * @return
		 */
		public function addChild (c:DisplayObject):DisplayObject
		{
			c.setStage(this.stage);
			c.setParent(this);
			this.childs.push(c);
			return c;
		}
		
		/**
		 * Remove child
		 * 
		 * @param	e
		 * @return
		 */
		public function removeChild (c:DisplayObject):DisplayObject
		{
			return this.removeChildAt(this.childs.indexOf(c));
		}
		
		/**
		 * Remove child at index
		 * 
		 * @param	e
		 * @return
		 */
		public function removeChildAt (i:int):DisplayObject
		{
			var splice:Vector.<DisplayObject> = this.childs.splice(i, 1);
			if (splice.length == 0)
				return null;
			splice[0].setStage(null);
			splice[0].setParent(null);
			return splice[0];
		}
		
		/**
		 * Remove childs
		 */
		public function removeAllChilds ():DisplayObjectContainer
		{
			for (var n:int = this.childs.length - 1; n >= 0; n--)
			{
				this.childs[n].setStage(null);
				this.childs[n].setParent(null);
				this.childs[n] = null;
			}
			this.childs = new Vector.<DisplayObject>();
			return this;
		}
		
		/**
		 * Change position of an existing entity
		 * 
		 * @param	e
		 * @param	index
		 * @return
		 */
		public function setChildIndex (c:DisplayObject, index:int):DisplayObjectContainer
		{
			this.childs.splice(index, 0, this.childs.splice(this.childs.indexOf(c), 1));
			return this;
		}
		
		/**
		 * Swap position of childs
		 * 
		 * @param	c1
		 * @param	c2
		 * @return
		 */
		public function swapChildren (c1:DisplayObject, c2:DisplayObject):DisplayObjectContainer
		{
			return this.swapChildrenAt(this.childs.indexOf(c1), this.childs.indexOf(c2));
		}
		
		/**
		 * Swap position
		 * 
		 * @param	i1
		 * @param	i2
		 * @return
		 */
		public function swapChildrenAt (i1:int, i2:int):DisplayObjectContainer
		{
			if (i1 < i2)
				this.childs.splice(i2 - 1, 0, this.childs.splice(i1, 1, this.childs.splice(i2, 1)));
			else
				this.childs.splice(i1 - 1, 0, this.childs.splice(i2, 1, this.childs.splice(i1, 1)));
			
			return this;
		}
		
	}
	
}