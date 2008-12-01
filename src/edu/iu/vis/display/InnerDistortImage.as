package edu.iu.vis.display {
	
	import edu.iu.vis.utils.TrigUtil;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	
	/**
	 * Tesselates an area into several triangles to allow free transform distortion on BitmapData objects.
	 * 
	 * @author		Thomas Pfeiffer (aka kiroukou)
	 * 				kiroukou@gmail.com
	 * 				www.flashsandy.org
	 * @author		Ruben Swieringa
	 * 				ruben.swieringa@gmail.com
	 * 				www.rubenswieringa.com
	 * 				www.rubenswieringa.com/blog
	 * @version		1.1.0
	 * 
	 * 
	 * edit 2
	 * 
	 * The original Actionscript2.0 version of the class was written by Thomas Pfeiffer (aka kiroukou),
	 *   inspired by Andre Michelle (andre-michelle.com).
	 *   Ruben Swieringa rewrote Thomas Pfeiffer's class in Actionscript3.0, making some minor changes/additions.
	 * 
	 * 
	 * Copyright (c) 2005 Thomas PFEIFFER. All rights reserved.
	 * 
	 * Licensed under the CREATIVE COMMONS Attribution-NonCommercial-ShareAlike 2.0 you may not use this
	 *   file except in compliance with the License. You may obtain a copy of the License at:
	 *   http://creativecommons.org/licenses/by-nc-sa/2.0/fr/deed.en_GB
	 * 
	 */
	public class InnerDistortImage extends DistortImage {
		
		
		public var tlp:Point, trp:Point, blp:Point, brp:Point;
		
		
		public function InnerDistortImage( w:Number, h:Number, hseg:uint = 2, vseg:uint = 2 ):void {
			super( w, h, hseg, vseg );
		}


		
		/**
		 * Distorts the provided BitmapData according to the provided Point instances and draws it onto the provided Graphics.
		 * 
		 * @param	graphics	Graphics on which to draw the distorted BitmapData
		 * @param	bmd			The undistorted BitmapData
		 * @param	tl			Point specifying the coordinates of the top-left corner of the distortion
		 * @param	tr			Point specifying the coordinates of the top-right corner of the distortion
		 * @param	br			Point specifying the coordinates of the bottom-right corner of the distortion
		 * @param	bl			Point specifying the coordinates of the bottom-left corner of the distortion
		 * 
		 */

		public function setInnerTransform( graphics:Graphics,
										bmd:BitmapData,
										wp:Number, hp:Number,
										tl:Point, // Dynamic Points (Transformable)
										tr:Point, 
										br:Point, 
										bl:Point ):void {

			// Get initial values for stored points
			if (!tlp) tlp = tl;
			if (!trp) trp = tr;
			if (!blp) blp = bl;
			if (!brp) brp = br;
			
			if (!wp) wp = _w;
			if (!hp) hp = _h;
			
			// Corner points of image
			var tla:Point = new Point( 0, 0 );
			var tra:Point = new Point( _w, 0 );
			var bla:Point = new Point( 0, _h );
			var bra:Point = new Point( _w, _h );
			
			// Width, Height
			var dw:Number = _w;
			var dh:Number = _h;
			
			// Reusable Variables
			var dx21:Number, dy21:Number, dx30:Number, dy30:Number;
			var gx:Number, gy:Number, arc:Number, theta:Number;
			var cp:Point, bp:Point, ap:Point;
			
			
			
			/*
			Find Top Left Point
			===================
			*/
			
			// Relative difference between TR and BR points
			dx21 = brp.x - trp.x;
			dy21 = brp.y - trp.y;
			
			// Relative percentage position of draggable point on map
			gx = ( tl.x - tla.x ) / dw;
			gy = ( tl.y - tla.y ) / dh;
			
			// Relative anchor point along right edge of polygon
			cp = new Point();
			cp.x = trp.x + gy * ( dx21 );
			cp.y = trp.y + gy * ( dy21 );
			
			// Relative anchor point along left edge of polygon
			arc = TrigUtil.DistanceBetweenPoints( cp, tla );
			theta = TrigUtil.RadiansBetweenPoints( cp, tla );
			bp = TrigUtil.PointFromArc( cp, theta, arc / ( 1 - gx ) );
			
			// New Top Left anchor point
			arc = TrigUtil.DistanceBetweenPoints( bp, blp );
			theta = TrigUtil.RadiansBetweenPoints( bp, blp ) - Math.PI;
			ap = TrigUtil.PointFromArc( blp, theta, arc / ( 1 - gy ) );
			
			// Store point
			tlp = ap;
			
			// Draw guides for debugging
			this.drawGuides( graphics, cp, bp, ap );
			

			
			/*
			Find Top Right Point
			====================
			*/
			
			// Relative difference between TL and BL points
			dx30 = blp.x - tlp.x;
			dy30 = blp.y - tlp.y;
			
			// Relative percentage position of draggable point on map
			gx = ( tra.x - tr.x ) / dw;
			gy = ( tr.y - tra.y ) / dh;
			
			// Relative anchor point along left edge of polygon
			cp = new Point();
			cp.x = tlp.x + gy * ( dx30 );
			cp.y = tlp.y + gy * ( dy30 );
			
			// Relative anchor point along right edge of polygon
			arc = TrigUtil.DistanceBetweenPoints( cp, tra );
			theta = TrigUtil.RadiansBetweenPoints( cp, tra );
			bp = TrigUtil.PointFromArc( cp, theta, arc / ( 1 - gx ) );
			
			// New Top Right anchor point
			arc = TrigUtil.DistanceBetweenPoints( bp, brp );
			theta = TrigUtil.RadiansBetweenPoints( bp, brp ) - Math.PI;
			ap = TrigUtil.PointFromArc( brp, theta, arc / ( 1 - gy ) );
			
			// Store point
			trp = ap;
			
			// Draw guides for debugging
			this.drawGuides( graphics, cp, bp, ap );



			/*
			Find Bottom Left Point
			======================
			*/
			
			// Relative difference between TR and BR points
			dx21 = brp.x - trp.x;
			dy21 = brp.y - trp.y;
			
			// Relative percentage position of draggable point on map
			gx = ( bl.x - bla.x ) / dw;
			gy = ( bla.y - bl.y ) / dh;
			
			// Relative anchor point along right edge of polygon
			cp = new Point();
			cp.x = brp.x - gy * ( dx21 );
			cp.y = brp.y - gy * ( dy21 );
			
			// Relative anchor point along left edge of polygon
			arc = TrigUtil.DistanceBetweenPoints( cp, bla );
			theta = TrigUtil.RadiansBetweenPoints( cp, bla );
			bp = TrigUtil.PointFromArc( cp, theta, arc / ( 1 - gx ) );
			
			// New Bottom Left anchor point
			arc = TrigUtil.DistanceBetweenPoints( bp, tlp );
			theta = TrigUtil.RadiansBetweenPoints( bp, tlp ) + Math.PI;
			ap = TrigUtil.PointFromArc( tlp, theta, arc / ( 1 - gy ) );
			
			// Store point
			blp = ap;
			
			// Draw guides for debugging
			this.drawGuides( graphics, cp, bp, ap );
			
			
			
			/*
			Find Bottom Right Point
			=======================
			*/
			
			// Relative difference between TL and BL points
			dx30 = blp.x - tlp.x;
			dy30 = blp.y - tlp.y;
			
			// Relative percentage position of draggable point on map
			gx = ( bra.x - br.x ) / dw;
			gy = ( bra.y - br.y ) / dh;
			
			// Relative anchor point along left edge of polygon
			cp = new Point();
			cp.x = blp.x - gy * ( dx30 );
			cp.y = blp.y - gy * ( dy30 );
			
			// Relative anchor point along right edge of polygon
			arc = TrigUtil.DistanceBetweenPoints( cp, bra );
			theta = TrigUtil.RadiansBetweenPoints( cp, bra );
			bp = TrigUtil.PointFromArc( cp, theta, arc / ( 1 - gx ) );
			
			// New Bottom Right anchor point
			arc = TrigUtil.DistanceBetweenPoints( bp, trp );
			theta = TrigUtil.RadiansBetweenPoints( bp, trp ) + Math.PI;
			ap = TrigUtil.PointFromArc( trp, theta, arc / ( 1 - gy ) );
			
			// Store point
			brp = ap;

			// Draw guides for debugging
			this.drawGuides( graphics, cp, bp, ap );
			
			
			
			/*
			Transform Bitmap
			================
			*/
			
			if ( showGrid )
				graphics.lineStyle( 1, 0x0000FF );
			else
				graphics.lineStyle();
					
			setTransform( graphics, bmd, tlp, trp, brp, blp );
			
			if ( showGrid )
				this.drawPolygon( graphics, tla, tra, bra, bla );
		}
		
		public function setPointTransform( graphics:Graphics, bmd:BitmapData, aPoint:Point, bPoint:Point ):void {
			
			var apDx:Number = aPoint.x;
			var apDx2:Number = _w - apDx;
			
			var bpDx:Number = bPoint.x;
			var bpDx2:Number = _w - bpDx;
			
			var ratioDx:Number = bpDx / apDx;
			var ratioDx2:Number = bpDx2 / apDx2;
			
			var l:Number = _p.length;
			trace( '//', aPoint, bPoint, ratioDx, ratioDx2 );
			var tl:Point = new Point();
			
			for( var i:uint = 0; i < l; i++ ) {
				
				var point:Object = _p[ i ];
				var dx:Number = point.x - aPoint.x;
					
				// * ( point.x < aPoint.x ? ratioDx : ratioDx2 )
				point.sx = point.x + dx * ( point.x < aPoint.x ? ratioDx - 1 : ratioDx2 - 1 );
				point.sy = point.y;
				
				if ( i == 0 )
					tl = new Point( point.sx, point.sy );
					
				point.sx -= tl.x;
				point.sy -= tl.y;
			}
			
/*
			var dx30:Number = bl.x - tl.x;
			var dy30:Number = bl.y - tl.y;
			var dx21:Number = br.x - tr.x;
			var dy21:Number = br.y - tr.y;
			var l:Number = _p.length;
			while( --l> -1 ){
				var point:Object = _p[ l ];
				var gx:Number = ( point.x - _xMin ) / _w;
				var gy:Number = ( point.y - _yMin ) / _h;
				var bx:Number = tl.x + gy * ( dx30 );
				var by:Number = tl.y + gy * ( dy30 );
				point.sx = bx + gx * ( ( tr.x + gy * ( dx21 ) ) - bx );
				point.sy = by + gx * ( ( tr.y + gy * ( dy21 ) ) - by );
			}
			*/
			
			if ( showGrid )
				graphics.lineStyle( 1, 0x0000FF );
			else
				graphics.lineStyle();
				
			__render(graphics, bmd);
									
		}
		
		private function drawGuides( graphics:Graphics, cp:Point, bp:Point, ap:Point ):void {
			
			if (!showGrid)
				return;
			
			graphics.endFill();
			graphics.lineStyle( 4, 0xFFFF00 );
			
			graphics.moveTo( cp.x, cp.y );
			graphics.lineTo( bp.x, bp.y );
			
			StrokePoint( cp, graphics );
			StrokePoint( bp, graphics, 0x00FF00 );
			StrokePoint( ap, graphics, 0xFFFF00 );
			
			graphics.lineStyle( 1, 0x0000FF );
		}
		
		private function drawPolygon( graphics:Graphics, a:Point, b:Point, c:Point, d:Point ):void {
			graphics.endFill();
			graphics.lineStyle( 4, 0x00FF00 );
			
			graphics.moveTo( a.x, a.y );
			graphics.lineTo( b.x, b.y );
			graphics.lineTo( c.x, c.y );
			graphics.lineTo( d.x, d.y );
			graphics.lineTo( a.x, a.y );
			
			graphics.lineStyle( 1, 0x0000FF );
		}
		
		public static function StrokePoint( point:Point, graphics:Graphics, strokeColor:uint = 0xFF0000 ):void {
			graphics.lineStyle(2, strokeColor);
			graphics.drawRect(point.x - 1, point.y - 1, 2, 2);
		}
		
	}
	
	
}