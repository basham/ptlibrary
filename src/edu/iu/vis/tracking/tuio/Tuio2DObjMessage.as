package edu.iu.vis.tracking.tuio {
	
	import it.h_umus.tuio.Tuio2DObj;

	public class Tuio2DObjMessage extends Tuio2DObj {
		
		public function Tuio2DObjMessage(s:int = 0, i:int = 0, x:Number = 0, y:Number = 0, a:Number = 0, X:Number = 0, Y:Number = 0, A:Number = 0, m:Number = 0, r:Number = 0) {
			super(s, i, x, y, a, X, Y, A, m, r);
		}
		
		public function generateTuio2DObj():Tuio2DObj {
			return new Tuio2DObj(s, i, x, y, a, X, Y, A, m, r);
		}
		
		public static function GenerateTuio2DObjMessage( tuio:Tuio2DObj ):Tuio2DObjMessage {
			return new Tuio2DObjMessage( tuio.s, tuio.i, tuio.x, tuio.y, tuio.a, tuio.X, tuio.Y, tuio.A, tuio.m, tuio.r );
		}
		
	}
}