package com.pw282.swf.data.abc
{
	import com.pw282.swf.data.BaseData;
	import com.pw282.swf.data.EncodedU32;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.data.abc.trait.Trait_class;
	import com.pw282.swf.data.abc.trait.Trait_function;
	import com.pw282.swf.data.abc.trait.Trait_method;
	import com.pw282.swf.data.abc.trait.Trait_slot;
	import com.pw282.swf.utils.Tools;

	import flash.utils.ByteArray;


	/**
	 *
	 * @author pw
	 * @Date：2011-6-13
	 */
	public class Traits_info extends BaseData
	{
		public static const Trait_Slot : int = 0;
		public static const Trait_Method : int = 1;
		public static const Trait_Getter : int = 2;
		public static const Trait_Setter : int = 3;
		public static const Trait_Class : int = 4;
		public static const Trait_Function : int = 5;
		public static const Trait_Const : int = 6;

		public static const ATTR_Final : int = 0x1;
		public static const ATTR_Override : int = 0x2;
		public static const ATTR_Metadata : int = 0x4;

		public var name : int;
		public var kind : int;
		public var trait : *;
		public var metadata_count : int;
		public var arrMetadata : Array;
		public static var isReadingClass : Boolean = false;

		public function Traits_info(bt : ByteArray = null)
		{
			super(bt);
		}

		public function get traitType() : int
		{
			return kind & 0xF;
		}

		override public function read(bt : ByteArray) : void
		{
			name = EncodedU32.read(bt);
			kind = bt.readByte();
			var _traitType : int = traitType;

			switch(_traitType)
			{
				case Trait_Slot:
				case Trait_Const:
					trait = new Trait_slot(bt);

					if(KeyWords.isEncryptVariable)
					{
						//TODO:删除下面一行，针对doswf加密同名方法
//						(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).name = Tools.getRandom(1, Tools.abcFile.cpool_info.string_count);
						(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
					}
					break;
				case Trait_Method:
					if(KeyWords.isEncryptMethod)
					{
						//TODO:删除下面一行，针对doswf加密同名方法
//						(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).name = Tools.getRandom(1, Tools.abcFile.cpool_info.string_count);
						(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
					}
				case Trait_Getter:
				case Trait_Setter:
					trait = new Trait_method(bt);


					var method_index : int = (trait as Trait_method).method_v;
					(Tools.abcFile.arrMethod[method_index] as Method_info).strName = Instance_info.name_S + "." + Tools.abcFile.cpool_info.arrMultiname_S[name - 1];
					break;
				case Trait_Class:
					isReadingClass = true;
					trait = new Trait_class(bt);
					if(KeyWords.isEncryptClass || KeyWords.isEncryptPackage)
					{
						//排除fl包内的类和包被混淆，因为要和fla中资源对应
						if(Tools.abcFile.cpool_info.arrMultiname_S[name - 1].indexOf("fl.") != 0)
						{
							(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
						}
					}
					isReadingClass = false;
					break;
				case Trait_Function:
					trait = new Trait_function(bt);
					break;
			}

			metadata_count = 0;
			arrMetadata = [];
			var traitAttributes : int = kind >> 4;

			if(traitAttributes & ATTR_Metadata)
			{
				metadata_count = EncodedU32.read(bt);
				var i : int = 0;

				for(i = 0; i < metadata_count; i++)
				{
					arrMetadata.push(EncodedU32.read(bt));
				}
			}
		}

		override public function collectEncryptName() : void
		{
			var _traitType : int = traitType;

			switch(_traitType)
			{
				case Trait_Slot:
				case Trait_Const:
					(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
					break;
				case Trait_Method:
					(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
				case Trait_Getter:
				case Trait_Setter:
					var method_index : int = (trait as Trait_method).method_v;
					(Tools.abcFile.arrMethod[method_index] as Method_info).strName = Instance_info.name_S + "." + Tools.abcFile.cpool_info.arrMultiname_S[name - 1];
					break;
				case Trait_Class:
					if(Tools.abcFile.cpool_info.arrMultiname_S[name - 1].indexOf("fl.") != 0)
					{
						(Tools.abcFile.cpool_info.arrMultiname[name - 1] as Multiname_info).addToEncryptWords();
					}
					break;
				case Trait_Function:
					break;
			}
		}

		override public function write(bt : ByteArray) : void
		{
			EncodedU32.write(bt, name);
			bt.writeByte(kind);
			var traitType : int = kind & 0xF;

			switch(traitType)
			{
				case Trait_Slot:
				case Trait_Const:
					(trait as Trait_slot).write(bt);
					break;
				case Trait_Method:
				case Trait_Getter:
				case Trait_Setter:
					(trait as Trait_method).write(bt);
					break;
				case Trait_Class:
					(trait as Trait_class).write(bt);
					break;
				case Trait_Function:
					(trait as Trait_function).write(bt);
					break;
			}
			var traitAttributes : int = kind >> 4;

			if(traitAttributes & ATTR_Metadata)
			{
				EncodedU32.write(bt, metadata_count);
				var i : int = 0;

				for(i = 0; i < metadata_count; i++)
				{
					EncodedU32.write(bt, arrMetadata[i]);
				}
			}
		}

		override public function encrypt() : void
		{
			trait.encrypt();
		}

		override public function toString() : String
		{
			var traitType : int = kind & 0xF;

			if(traitType != Trait_Const)
				return "";
			return "\n name:" + Tools.abcFile.cpool_info.arrMultiname_S[name - 1] + "\n trait:" + trait
		}
	}
}