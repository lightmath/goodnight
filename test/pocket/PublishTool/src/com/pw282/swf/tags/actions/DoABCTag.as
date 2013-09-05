package com.pw282.swf.tags.actions
{
	import com.pw282.swf.data.DString;
	import com.pw282.swf.data.KeyWords;
	import com.pw282.swf.data.abc.AbcFile;
	import com.pw282.swf.tags.Tag;
	import com.pw282.swf.utils.TagTypes;

	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class DoABCTag extends Tag
	{
		public var Flags : int = 1;
		public var Name : String = "frame2";
		public var abcFile : AbcFile = new AbcFile();

		public function DoABCTag()
		{
			super();
			this.tagType = TagTypes.TAG_DOABC;
		}

		override public function parse() : void
		{
			super.parse();

			if(!allowChildParse)
			{
				return;
			}
			Flags = bt.readUnsignedInt();
			Name = DString.read(bt);
			abcFile = new AbcFile(bt);
		}

		override public function toString() : String
		{
			return super.toString() + "\n Flags:" + Flags + "\n Name:" + Name + "\n abcFile:" + abcFile
		}

		override public function toXmlString() : String
		{
			return "Flags:" + Flags + "\n Name:" + Name
		}

		override public function getXmlStr() : String
		{
			return "<node label='DoABCTag' txt='" + this.toXmlString() + "'>" + (abcFile == null ? "" : abcFile.getXmlStr()) + "</node>"
		}

		override public function encode() : void
		{
			if(allowChildEncode)
			{
				var btRemain : ByteArray = new ByteArray();
				btRemain.endian = Endian.LITTLE_ENDIAN;
				bt.readBytes(btRemain);

				bt = new ByteArray();
				bt.endian = Endian.LITTLE_ENDIAN;
				bt.writeUnsignedInt(Flags);
				DString.write(bt, Name);
				abcFile.write(bt);

				bt.writeBytes(btRemain);
			}

			super.encode();
		}

		override public function encrypt() : void
		{
			if(!allowChildEncrypt)
			{
				return;
			}
			Name = KeyWords.encryptStr(Name);
			abcFile.encrypt();
		}
	}
}