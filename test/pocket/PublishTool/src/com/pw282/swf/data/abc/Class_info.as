package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.abc.trait.Trait_class;

	import com.pw282.swf.data.abc.trait.Trait_method;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 貌似包含静态的方法，变量，Instance_info则相反
	 * @author pw
	 * @Date：2011-6-14
	 */	
	public class Class_info extends BaseData
	{
		public var cinit:int;
		public var trait_count:int;
		/**
		 * 静态变量 
		 */
		public var arrTraits:Array;
		public function Class_info(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			cinit = EncodedU32.read(bt);
			trait_count = EncodedU32.read(bt);
			var i:int = 0;
			arrTraits = [];
			for(i = 0; i < trait_count; i++){
				arrTraits.push(new Traits_info(bt));
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, cinit);
			EncodedU32.write(bt, trait_count);
			var i:int = 0;
			for(i = 0; i < trait_count; i++){
				(arrTraits[i] as Traits_info).write(bt);
			}
		}
		override public function toString():String{
			return "cinit:" + cinit
				+ ",trait_count:" + trait_count
				+ ",arrTraits:" + arrTraits
		}
		public function getMethodList():Array{
			var arr:Array = [];
			var ob:Object = {};
			
			var i:int = 0;
			for(i = 0; i < trait_count; i++){
				var traits_info:Traits_info = arrTraits[i];
				if(traits_info.traitType == Traits_info.Trait_Class){
					var trait_class:Trait_class = traits_info.trait;
					var instance_info:Instance_info = Tools.abcFile.arrInstance[trait_class.classi];
					ob = {};
					ob.label = Tools.abcFile.cpool_info.arrMultiname_S[instance_info.name - 1];
					ob.data = cinit;
					arr.push(ob);
				}else if(traits_info.traitType == Traits_info.Trait_Method){
					var trait_method:Trait_method = traits_info.trait;
					ob = {};
					ob.label = Tools.abcFile.cpool_info.arrMultiname_S[traits_info.name - 1];
					ob.data = trait_method.method_v;
					arr.push(ob);
				}
			}
			return arr;
		}
	}
}