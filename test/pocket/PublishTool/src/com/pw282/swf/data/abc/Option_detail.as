package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	public class Option_detail extends BaseData
	{
		public static const KINDS:Object = {0x03:"Int"
			,0x04:"UInt"
			,0x06:"Double"
			,0x01:"Utf8"
			,0x0B:"True"
			,0x0A:"False"
			,0x0C:"Null"
			,0x00:"Undefined"
			,0x08:"Namespace"
			,0x16:"PackageNamespace"
			,0x17:"PackageInternalNs"
			,0x18:"ProtectedNamespace"
			,0x19:"ExplicitNamespace"
			,0x1A:"StaticProtectedNs"
			,0x05:"PrivateNs"};
		
		public var val:int;
		public var kind:int;
		public function Option_detail(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			val = EncodedU32.read(bt);
			kind = bt.readUnsignedByte();
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, val);
			bt.writeByte(kind);
		}
		override public function toString():String{
			return "val:" + val + ",kind:" + KINDS[kind];
		}
		public function toFullString():String{
			var trueVal:String = "";
			switch(kind){
				case 0x03:
					trueVal = Tools.abcFile.cpool_info.arrInt[val - 1].toString();
					break;
				case 0x04:
					if(Tools.abcFile.cpool_info.arrUint.length >= val){
						trueVal = Tools.abcFile.cpool_info.arrUint[val - 1].toString();
					}else{
						trace("arrUint.length < val:" + val);
					}
					break;
				case 0x06:
					if(Tools.abcFile.cpool_info.arrDouble.length >= val){
						trueVal = Tools.abcFile.cpool_info.arrDouble[val - 1].toString();
					}else{
						trace("arrDouble.length < val:" + val);
					}
					break;
				case 0x01:
					trueVal = "\"" + Tools.abcFile.cpool_info.arrString[val - 1] + "\"";
					break;
				case 0x0B:
				case 0x0A:
				case 0x0C:
				case 0x00:
					trueVal = KINDS[kind];
					break;
				default:
					trueVal = "\"" + Tools.abcFile.cpool_info.arrNamespace_S[val - 1] + "\"";
					break;
			}
			return trueVal;
		}
	}
}