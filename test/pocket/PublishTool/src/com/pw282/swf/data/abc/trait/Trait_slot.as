package com.pw282.swf.data.abc.trait
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;

	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	
	/**
	 * 
	 * @author pw
	 * @Date：2011-6-13
	 */	
	public class Trait_slot extends BaseData
	{
		public var slot_id:int;
		public var type_name:int;
		public var vindex:int;
		public var vkind:int;
		public static function getConstantKind(kind:int):String{
			switch(kind){
				case 0x03:	return "integer";
				case 0x04:	return "uinteger";
				case 0x06:	return "double";
				case 0x01:	return "string";
				case 0x0B:	return "True";
				case 0x0A:	return "False";
				case 0x0C:	return "Null";
				case 0x00:	return "Undefined";
				case 0x08:
				case 0x16:
				case 0x17:
				case 0x18:
				case 0x19:
				case 0x1A:
				case 0x15:	return "Namespace";
			}
			return "";
		}
		public function Trait_slot(bt:ByteArray=null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			slot_id = EncodedU32.read(bt);
			type_name = EncodedU32.read(bt);
			vindex = EncodedU32.read(bt);
			if(vindex != 0){
				vkind = bt.readUnsignedByte();
			}
		}
		override public function write(bt:ByteArray):void{
			EncodedU32.write(bt, slot_id);
			EncodedU32.write(bt, type_name);
			EncodedU32.write(bt, vindex);
			if(vindex != 0){
				bt.writeByte(vkind);
			}
		}
		override public function encrypt():void{
//			type_name = 1;
		}
		override public function toString():String{
			if(vkind == 0x03){
				return "\t Trait_slot"
					+ "\n\t\t  slot_id:" + slot_id
					+ "\n\t\t  type_name:" + Tools.abcFile.cpool_info.arrMultiname_S[type_name - 1]
					+ "\n\t\t  vindex:" + vindex
					+ "\n\t\t  vkind:" + getConstantKind(vkind);
			}
			return "";
		}
	}
}