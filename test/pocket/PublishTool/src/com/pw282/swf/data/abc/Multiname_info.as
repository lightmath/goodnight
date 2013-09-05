package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.utils.Tools;
	
	import flash.utils.ByteArray;
	
	public class Multiname_info extends BaseData
	{
		public static const MULTINAME_KIND:Object = {0x07:"QName"
			,0x0D:"QNameA"
			,0x0F:"RTQName"
			,0x10:"RTQNameA"
			,0x11:"RTQNameL"
			,0x12:"RTQNameLA"
			,0x09:"Multiname"
			,0x0E:"MultinameA"
			,0x1B:"MultinameL"
			,0x1C:"MultinameLA"};
		
		public var kind:int;
		public var dataVctr:Object;
		public var ns:int;
		public var name:int;
		public var ns_set:int;
		public function Multiname_info(bt:ByteArray = null)
		{
			super(bt);
		}
		override public function read(bt:ByteArray):void{
			kind = bt.readUnsignedByte();
			switch(kind){
				case 0x07:
				case 0x0D://The multiname_kind_QName format is used for kinds CONSTANT_QName and CONSTANT_QNameA
					ns = EncodedU32.read(bt);
					name = EncodedU32.read(bt);
					break;
				case 0x0F:
				case 0x10://The multiname_kind_RTQName format is used for kinds CONSTANT_RTQName and CONSTANT_RTQNameA
					name = EncodedU32.read(bt);
					break;
				case 0x11:
				case 0x12://The multiname_kind_RTQNameL format is used for kinds CONSTANT_RTQNameL and CONSTANT_RTQNameLA
					break;
				case 0x09:
				case 0x0E://The multiname_kind_Multiname format is used for kinds CONSTANT_Multiname and CONSTANT_MultinameA
					name = EncodedU32.read(bt);
					ns_set = EncodedU32.read(bt);
					break;
				case 0x1B:
				case 0x1C://The multiname_kind_MultinameL format is used for kinds CONSTANT_MultinameL and CONSTANT_MultinameLA
					ns_set = EncodedU32.read(bt);
					break;
				case 0x1D://sdk4.5使用vector会出现kind=1d。1d的kind多半是新增但avm还没出说明的
					/**
Vector是0x1D
 type            　 u30
 name_count    u30
 name               u30[name_count]
					 * */
					dataVctr = {};
					dataVctr.v1 = EncodedU32.read(bt);
					dataVctr.v2 = EncodedU32.read(bt);
					var arr:Array = [];
					for(var i:int = 0; i < dataVctr.v2; i++){
						arr.push(EncodedU32.read(bt));
					}
					dataVctr.v3 = arr;
					break;
				default:
					throw new Error("Multiname_info unknow kind:" + kind.toString(16));
			}
		}
		override public function write(bt:ByteArray):void{
			bt.writeByte(kind);
			switch(kind){
				case 0x07:
				case 0x0D://The multiname_kind_QName format is used for kinds CONSTANT_QName and CONSTANT_QNameA
					EncodedU32.write(bt, ns);
					EncodedU32.write(bt, name);
					break;
				case 0x0F:
				case 0x10://The multiname_kind_RTQName format is used for kinds CONSTANT_RTQName and CONSTANT_RTQNameA
					EncodedU32.write(bt, name);
					break;
				case 0x11:
				case 0x12://The multiname_kind_RTQNameL format is used for kinds CONSTANT_RTQNameL and CONSTANT_RTQNameLA
					break;
				case 0x09:
				case 0x0E://The multiname_kind_Multiname format is used for kinds CONSTANT_Multiname and CONSTANT_MultinameA
					EncodedU32.write(bt, name);
					EncodedU32.write(bt, ns_set);
					break;
				case 0x1B:
				case 0x1C://The multiname_kind_MultinameL format is used for kinds CONSTANT_MultinameL and CONSTANT_MultinameLA
					EncodedU32.write(bt, ns_set);
					break;
				case 0x1D:
					EncodedU32.write(bt, dataVctr.v1);
					EncodedU32.write(bt, dataVctr.v2);
					var arr:Array = dataVctr.v3;
					for(var i:int = 0; i < dataVctr.v2; i++){
						EncodedU32.write(bt, arr[i]);
					}
					break;
			}
		}
		override public function toString():String{
			return "kind:" + kind + ",data:" + dataVctr;
		}
		public function toFullString(arrString:Array, arrNamespace:Array, arrNs_set:Array):String{
			return getDataString(arrString, arrNamespace, arrNs_set)
		}
		private function getDataString(arrString:Array, arrNamespace:Array, arrNs_set:Array):String{
			var str:String = "";
			switch(kind){
				case 0x07:
				case 0x0D:
					str = (ns == 0 ? "" : arrNamespace[ns - 1])
					if(str == null){
						str = "";
					}
					if(str != ""){
						str += "."
					}
					str += (name == 0 ? "*" : arrString[name - 1])
					break;
				case 0x0F:
				case 0x10:
					str = (name == 0 ? "*" : arrString[name - 1])
					break;
				case 0x11:
				case 0x12:
					str = "*";
					break;
				case 0x09:
				case 0x0E:
					str = (name == 0 ? "*" : arrString[name - 1])
					+ "." + arrNs_set[ns_set - 1]
					break;
				case 0x1B:
				case 0x1C:
					str = arrNs_set[ns_set - 1]
					break;
				case 0x1D:
					str = dataVctr.v1 + "," + dataVctr.v2 + "," + dataVctr.v3;
					break;
			}
			return str;
		}
		public function addToEncryptWords():void{
			switch(kind){
				case 0x07:
				case 0x0D://The multiname_kind_QName format is used for kinds CONSTANT_QName and CONSTANT_QNameA
					(Tools.abcFile.cpool_info.arrNamespace[ns - 1] as Namespace_info).addToEncryptWords();
					if(Traits_info.isReadingClass){
						if(KeyWords.isEncryptClass){
							(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
						}
					}else{
						(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
					}
					break;
				case 0x0F:
				case 0x10://The multiname_kind_RTQName format is used for kinds CONSTANT_RTQName and CONSTANT_RTQNameA
					if(Traits_info.isReadingClass){
						if(KeyWords.isEncryptClass){
							(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
						}
					}else{
						(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
					}
					break;
				case 0x11:
				case 0x12://The multiname_kind_RTQNameL format is used for kinds CONSTANT_RTQNameL and CONSTANT_RTQNameLA
					break;
				case 0x09:
				case 0x0E://The multiname_kind_Multiname format is used for kinds CONSTANT_Multiname and CONSTANT_MultinameA
					(Tools.abcFile.cpool_info.arrNs_set[ns_set - 1] as Ns_set_info).addToEncryptWords();
					if(Traits_info.isReadingClass){
						if(KeyWords.isEncryptClass){
							(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
						}
					}else{
						(Tools.abcFile.cpool_info.arrString[name - 1] as String_info).addToEncryptWords();
					}
					break;
				case 0x1B:
				case 0x1C://The multiname_kind_MultinameL format is used for kinds CONSTANT_MultinameL and CONSTANT_MultinameLA
					(Tools.abcFile.cpool_info.arrNs_set[ns_set - 1] as Ns_set_info).addToEncryptWords();
					break;
				case 0x1D:
					break;
			}
		}
	}
}