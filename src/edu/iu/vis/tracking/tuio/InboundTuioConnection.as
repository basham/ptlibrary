package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.tuio.Tuio2DObjEventMessage;
	
	public class InboundTuioConnection extends AbstractTuioConnection {
		
		public function InboundTuioConnection( connectionName:String ) {
			super( connectionName, true );
		}
		
		public function tuioDispatcher( event:Tuio2DObjEventMessage ):void {
			this.dispatchEvent( event.event() );
			trace('Dispatch', event.event().data.x);
			//var e:Tuio2DObjEvent = event as Tuio2DObjEvent;
			//var e:Event = event as Event;
			//trace( e.toString() );
		}
	}
}