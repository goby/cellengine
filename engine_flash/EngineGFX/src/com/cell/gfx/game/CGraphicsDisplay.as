package com.cell.gfx.game
{
	import flash.display.Graphics;
	import flash.geom.Matrix;

	public class CGraphicsDisplay implements IGraphics
	{
		private var g : Graphics;
		
		public function CGraphicsDisplay(g:Graphics)
		{
			this.g = g;
		}
		
		/**
		 * 绘制指定图像中当前可用的图像。图像的左上角位于该图形上下文坐标空间的 (x, y)。
		 * @param img 要绘制的指定图像。
		 * @param x x 坐标。
		 * @param y y 坐标。
		 * @param transform 翻转方式
		 */
		public function drawImage(img:CImage, x:int, y:int, w:int, h:int, transform:int) : void
		{
			g.beginBitmapFill(img.src, 
				Transform.getMatrix(x, y, w, h, transform), 
				false, false);
			g.drawRect(x, y, w, h);
			g.endFill();
			
		}

		/**
		 * 绘制指定图像中的一部分。 
		 * @param src 要绘制的指定图像。
		 * @param x_src 原图片部分的X位置
		 * @param y_src 原图片部分的Y位置
		 * @param width 原图片矩形的宽度。
		 * @param height 原图片矩形的高度。
		 * @param transform 翻转方式
		 * @param x_dest 目标X坐标。
		 * @param y_dest 目标Y坐标。
		 */
		public function drawImageRegion(img:CImage,
										x_src:int,
										y_src:int,
										width:int, 
										height:int, 
										x_dest:int, 
										y_dest:int) : void
		{
			g.beginBitmapFill(img.src, null, false, false);
			g.drawRect(x_dest, y_dest, width, height);
			g.endFill();
		} 
		
		
		
	}
}