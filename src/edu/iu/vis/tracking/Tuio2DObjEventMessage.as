package edu.iu.vis.tracking {
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	public class Tuio2DObjEventMessage {
		
		public var type:String = '';
		public var data:Tuio2DObjMessage;
		
		public function Tuio2DObjEventMessage( type:String = '', data:Tuio2DObj = null ) {
			this.type = type;
			if ( data != null )
				setData( data );
		}
		
		private function setData( value:Tuio2DObj ):void {
			data = Tuio2DObjMessage.GenerateTuio2DObjMessage( value );
		}

		public function event():Tuio2DObjEvent {
			return new Tuio2DObjEvent( type, data.generateTuio2DObj() );
		}

		public function toString():String {
			return type;
		}
	}
}