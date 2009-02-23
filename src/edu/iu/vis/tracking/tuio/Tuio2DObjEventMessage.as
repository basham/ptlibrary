package edu.iu.vis.tracking.tuio {
	
	import it.h_umus.tuio.Tuio2DObj;
	import it.h_umus.tuio.events.Tuio2DObjEvent;
	
	public class Tuio2DObjEventMessage {
		
		public var type:String = '';
		public var data:Tuio2DObjMessage;
		
		public function Tuio2DObjEventMessage( tuioEvent:Tuio2DObjEvent = null ) {
			if ( tuioEvent != null )
				setMessage( tuioEvent.type, tuioEvent.data );
		}
		
		public function setMessage( type:String, data:Tuio2DObj ):void {
			this.type = type;
			convertData( data );
		}
		
		private function convertData( value:Tuio2DObj ):void {
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