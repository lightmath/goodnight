package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	public class Cpool_info extends BaseData
	{
		public var int_count:int = 0;
		public var arrInt:Array = [];
		
		public var uint_count:int = 0;
		public var arrUint:Array = [];
		
		public var double_count:int = 0;
		public var arrDouble:Array = [];
		
		public var string_count:int = 0;
		public var arrString:Array = [];
		
		public var namespace_count:int = 0;
		public var arrNamespace:Array = [];
		public var arrNamespace_S:Array = [];
		
		public var ns_set_count:int = 0;
		public var arrNs_set:Array = [];
		public var arrNs_set_S:Array = [];
		
		public var multiname_count:int = 0;
		public var arrMultiname:Array = [];
		public var arrMultiname_S:Array = [];
		public function Cpool_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			var i:int = 0;
			
			int_count = EncodedU32.read(bt);
			arrInt = [];
			for(i = 1; i < int_count; i++){
				arrInt.push(EncodedU32.read(bt));
			}
			
			uint_count = EncodedU32.read(bt);
			arrUint = [];
			for(i = 1; i < uint_count; i++){
				arrUint.push(EncodedU32.read(bt));
			}
			
			double_count = EncodedU32.read(bt);
			arrDouble = [];
			for(i = 1; i < double_count; i++){
				arrDouble.push(bt.readDouble());
			}
			
			string_count = EncodedU32.read(bt);
			arrString = [];
			for(i = 1; i < string_count; i++){
				arrString.push(new String_info(bt));
			}
			
			namespace_count = EncodedU32.read(bt);
			arrNamespace = [];
			arrNamespace_S = [];
			for(i = 1; i < namespace_count; i++){
				arrNamespace.push(new Namespace_info(bt));
				arrNamespace_S.push((arrNamespace[i - 1] as Namespace_info).toFullString(arrString));
			}
			
			ns_set_count = EncodedU32.read(bt);
			arrNs_set = [];
			arrNs_set_S = [];
			for(i = 1; i < ns_set_count; i++){
				arrNs_set.push(new Ns_set_info(bt));
				arrNs_set_S.push((arrNs_set[i - 1] as Ns_set_info).toFullString(arrNamespace_S));
			}
			
			multiname_count = EncodedU32.read(bt);
			arrMultiname = [];
			arrMultiname_S = [];
			for(i = 1; i < multiname_count; i++){
				arrMultiname.push(new Multiname_info(bt));
				arrMultiname_S.push((arrMultiname[i - 1] as Multiname_info).toFullString(arrString, arrNamespace_S, arrNs_set_S));
			}
		}
		override public function write(bt:ByteArray):void{
			var i:int = 0;
			
			EncodedU32.write(bt, int_count);
			for(i = 1; i < int_count; i++){
				EncodedU32.write(bt, arrInt[i - 1]);
			}
			
			EncodedU32.write(bt, uint_count);
			for(i = 1; i < uint_count; i++){
				EncodedU32.write(bt, arrUint[i - 1]);
			}
			
			EncodedU32.write(bt, double_count);
			for(i = 1; i < double_count; i++){
				bt.writeDouble(arrDouble[i - 1]);
			}
			
			EncodedU32.write(bt, string_count);
			for(i = 1; i < string_count; i++){
				(arrString[i - 1] as BaseData).write(bt);
			}
			
			EncodedU32.write(bt, namespace_count);
			for(i = 1; i < namespace_count; i++){
				(arrNamespace[i - 1] as BaseData).write(bt);
			}
			
			EncodedU32.write(bt, ns_set_count);
			for(i = 1; i < ns_set_count; i++){
				(arrNs_set[i - 1] as BaseData).write(bt);
			}
			
			EncodedU32.write(bt, multiname_count);
			for(i = 1; i < multiname_count; i++){
				(arrMultiname[i - 1] as BaseData).write(bt);
			}
		}
		override public function encrypt():void{
			var i:int = 0;
			for(i = 1; i < string_count; i++){
				var strInfo:String_info = arrString[i - 1];
				strInfo.str = KeyWords.encryptStr(strInfo.str);
			}
		}
		override public function toString():String{
			return "int_count:" + int_count
				+ "\n arrInt:" + arrInt
				+ "\n uint_count:" + uint_count
				+ "\n arrUint:" + arrUint
				+ "\n double_count:" + double_count
				+ "\n arrDouble:" + arrDouble
				+ "\n string_count:" + string_count
				+ "\n arrString:" + arrString
				+ "\n namespace_count:" + namespace_count
				+ "\n arrNamespace:" + arrNamespace
				+ "\n ns_set_count:" + ns_set_count
				+ "\n arrNs_set:" + arrNs_set
				+ "\n multiname_count:" + multiname_count
				+ "\n arrMultiname:" + arrMultiname
		}
		public function toXmlString():String{
			return "int_count:" + int_count
				+ "\n uint_count:" + uint_count
				+ "\n double_count:" + double_count
				+ "\n string_count:" + string_count
				+ "\n namespace_count:" + namespace_count
				+ "\n ns_set_count:" + ns_set_count
				+ "\n multiname_count:" + multiname_count
		}
		public function getXmlStr():String{
			return "<node label='Cpool_info' txt='" + this.toXmlString() + "'>"
//				+ "<node label='arrInt' txt='" + Tools.toArrString(arrInt) + "' />"
//				+ "<node label='arrUint' txt='" + Tools.toArrString(arrUint) + "' />"
//				+ "<node label='arrDouble' txt='" + Tools.toArrString(arrDouble) + "' />"
				+ "<node label='arrString' txt='" + Tools.toArrString2(arrString) + "' />"
//				+ "<node label='arrNamespace' txt='" + Tools.toArrString(arrNamespace_S) + "' />"
//				+ "<node label='arrNs_set' txt='" + Tools.toArrString(arrNs_set_S) + "' />"
//				+ "<node label='arrMultiname' txt='" + Tools.toArrString(arrMultiname_S) + "' />"
				+ "</node>"
		}
		public function getArrayList(arr:Array):void{
			var ob:Object = {};
			ob.label = "----arrInt:" + int_count;
			ob.data = Tools.toArrString(arrInt);
			arr.addItem(ob);
			ob = {};
			ob.label = "----arrUint:" + uint_count;
			ob.data = Tools.toArrString(arrUint);
			arr.addItem(ob);
			ob = {};
			ob.label = "----arrDouble:" + double_count;
			ob.data = Tools.toArrString(arrDouble);
			arr.addItem(ob);
			ob = {};
			ob.label = "----arrString:" + string_count;
			ob.data = Tools.toArrString2(arrString);
			arr.addItem(ob);
			ob = {};
			ob.label = "----arrNamespace:" + namespace_count;
			ob.data = Tools.toArrString(arrNamespace_S);
			arr.addItem(ob);
			ob = {};
			ob.label = "----arrMultiname:" + multiname_count;
			ob.data = Tools.toArrString(arrMultiname_S);
			arr.addItem(ob);
		}
	}
}