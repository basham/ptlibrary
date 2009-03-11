package edu.iu.vis.utils {
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Pool {
		
		private static var Pools:Dictionary = new Dictionary(true);
		
		public var type:Class;
		public var pool:Array;
		
		function Pool( type:Class ) {
			this.type = type;
			pool = new Array();
			Pools[ type ] = this;
		}
		
		public function getInstance( ...parameters ):* {
			return getInstanceByArray( parameters );
		}
		
		public function getInstanceByArray( parameters:Array ):* {
			return ( pool.length > 0 ? pool.pop() : Util.Construct( type, parameters ) );
			//var obj:Object = ( pool.length > 0 ? pool.pop() : Util.Construct( type, parameters ) ) as Object;
			//if ( obj.hasOwnProperty( "PoolConstructor" ) )
			//	obj.PoolConstructor();
			//return obj;
		}
		
		public function dispose( object:* ):void {
			pool.push( object );
			var obj:Object = object as Object;
			if ( obj.hasOwnProperty( "PoolDisposer" ) )
				obj.PoolDisposer();
		}
		
		public function purge():void {
			pool = new Array();
		}
		

		
		public static function GetPool( type:Class ):Pool {
			if ( !Pools[ type ] )
				new Pool( type );
			return Pools[ type ];
		}
		
		public static function DisposePool( type:Class ):void {
			Pools[ type ] = null
			delete( Pools[ type ] );
		}
		
		public static function Get( type:Class, ...parameters ):* {
			return GetPool( type ).getInstanceByArray( parameters );
		}
		
		public static function Dispose( object:*, type:Class = null ):void {
			if ( object == null )
				return;
			if ( type == null )
				type = getDefinitionByName( getQualifiedClassName( object ) ) as Class;
			GetPool( type ).dispose( object );
		}

	}
	
}
