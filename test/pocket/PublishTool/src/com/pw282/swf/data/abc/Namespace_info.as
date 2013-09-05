package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.utils.Tools;

	import flash.utils.ByteArray;

	public class Namespace_info extends BaseData
	{
		public static const NAMESPACE_KIND : Object = {0x08: "Namespace", 0x16: "PackageNamespace", 0x17: "PackageInternalNs", 0x18: "ProtectedNamespace", 0x19: "ExplicitNamespace", 0x1A: "StaticProtectedNs", 0x05: "PrivateNs"};

		public var kind : int;
		public var nameIndex : int;

		public function Namespace_info(bt : ByteArray = null)
		{
			super(bt);
		}

		override public function read(bt : ByteArray) : void
		{
			kind = bt.readUnsignedByte();
			nameIndex = EncodedU32.read(bt);
		}

		override public function write(bt : ByteArray) : void
		{
			bt.writeByte(kind);
			EncodedU32.write(bt, nameIndex);
		}

		override public function toString() : String
		{
			return "kind:" + kind + ",nameIndex:" + nameIndex;
		}

		public function toFullString(arrString : Array) : String
		{
			if(nameIndex <= 0)
			{
				return "";
			}
			return arrString[nameIndex - 1]
		}

		public function addToEncryptWords() : void
		{
			if(KeyWords.isEncryptPackage)
			{
				if(nameIndex <= 0)
					return;
				(Tools.abcFile.cpool_info.arrString[nameIndex - 1] as String_info).addToEncryptWords();
			}
		}

		override public function collectEncryptName() : void
		{
			if(nameIndex <= 0)
				return;
			(Tools.abcFile.cpool_info.arrString[nameIndex - 1] as String_info).addToEncryptWords();
		}
	}
}