package edu.iu.vis.tracking.tuio {
	
	import edu.iu.vis.tracking.tuio.Tuio2DObjEventMessage;
	
	import flash.events.AsyncErrorEvent;
	
	public class InboundTuioConnection extends AbstractTuioConnection {
		
		public function InboundTuioConnection( connectionName:String ) {
			super( connectionName );
			connection.client = this;
			connection.allowDomain('*');
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			connect();
		}
		
		private function connect():void {
			try {
		    	connection.connect(connectionName);
			}
			catch (error:ArgumentError) {
		    	trace("Error:" + error.message);
			}
		}
		
		private function onAsyncError( e:AsyncErrorEvent ):void {
			trace('Client', e);
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