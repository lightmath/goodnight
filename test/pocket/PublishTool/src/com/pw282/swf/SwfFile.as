package com.pw282.swf
{
	import com.pw282.swf.data.Rect;
	import com.pw282.swf.utils.TagTypes;
	import com.pw282.swf.tags.Tag;
	import com.pw282.swf.tags.actions.DoABCTag;
	import com.pw282.swf.tags.control.MetadataTag;


	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SwfFile
	{
		public static const FWS : String = "FWS";
		public static const CWS : String = "CWS";

		public static var addEncryptDoABCTag : Boolean = false;

		public var signature : String;
		public var version : int;
		public var fileLength : int;
		public var rect : Rect;
		public var frameRate : int;
		public var frameCount : int;
		public var tags : Array;
		public var bt : ByteArray;

		public function SwfFile(_bt : ByteArray = null)
		{
			bt = _bt;
			parse();
		}

		public function parse() : void
		{
			if(!bt)
				return;

			bt.endian = Endian.LITTLE_ENDIAN;
			signature = bt.readUTFBytes(3);
			version = bt.readByte();
			fileLength = bt.readUnsignedInt();

			if(signature == CWS)
			{
				var tempBytes : ByteArray = new ByteArray();
				tempBytes.writeBytes(bt, bt.position);
				tempBytes.uncompress();

				var temp : int = bt.position;
				bt.length = bt.position;
				bt.writeBytes(tempBytes);
				tempBytes.length = 0;
				bt.position = temp;
			}

			rect = new Rect(bt);
			bt.position++;
			frameRate = bt.readByte();
			frameCount = bt.readUnsignedShort();

			readTags(bt);
		}

		public function encode() : void
		{
			bt = new ByteArray();
			bt.endian = Endian.LITTLE_ENDIAN;

			bt.writeUTFBytes(signature);
			bt.writeByte(version);

			var tempBytes : ByteArray = new ByteArray();
			tempBytes.endian = Endian.LITTLE_ENDIAN;
			tempBytes.length = 20;
			rect.write(tempBytes);
			tempBytes.writeByte(0);
			tempBytes.writeByte(frameRate);
			tempBytes.writeShort(frameCount);

			var i : int = 0;

			for(i = 0; i < tags.length; i++)
			{
				var tag : Tag = tags[i];
				tag.encode();
				tempBytes.writeBytes(tag.bt);
				var allow : Boolean;

				if(tag.tagType == TagTypes.TAG_METADATA)
				{
					var metadataTag : MetadataTag = new MetadataTag();
					allow = Tag.allowChildEncode;
					Tag.allowChildEncode = true;
					metadataTag.encode();
					Tag.allowChildEncode = allow;
					tempBytes.writeBytes(metadataTag.bt);
				}

				if(addEncryptDoABCTag && tag.tagType == TagTypes.TAG_SHOWFRAME)
				{
					var encryptABCTag : DoABCTag = new DoABCTag();
					encryptABCTag.abcFile.metadata_count = 0xffffff;
					allow = Tag.allowChildEncode;
					Tag.allowChildEncode = true;
					encryptABCTag.encode();
					Tag.allowChildEncode = allow;
					tempBytes.writeBytes(encryptABCTag.bt);
					addEncryptDoABCTag = false;
				}
			}

			bt.writeUnsignedInt(bt.position + 4 + tempBytes.length);

			if(signature == CWS)
			{
				tempBytes.compress();
			}
			bt.writeBytes(tempBytes);
			tempBytes.length = 0;
		}

		public function encrypt() : void
		{
			var i : int = 0;

			for(i = 0; i < tags.length; i++)
			{
				var tag : Tag = tags[i];
				tag.encrypt();
			}
		}

		public function getTypeTags(tagType : int) : Array
		{
			var i : int = 0;
			var arrTmp : Array = [];

			for(i = 0; i < tags.length; i++)
			{
				var tag : Tag = tags[i];

				if(tag.tagType == tagType)
				{
					arrTmp.push(tag);
				}
			}
			return arrTmp;
		}

		/**
		 * 读取tag列表
		 * @param bytes
		 */
		private function readTags(bytes : ByteArray) : void
		{
			tags = [];

			var tagType : uint;
			var tagLength : uint;
			var tag : Tag;
			var TagClass : Class;
			var count : int = 0;

			while(bytes.bytesAvailable > 0)
			{
				tagType = readTagType(bytes);
				tagLength = readTagLength(bytes);

				TagClass = TagTypes.getTagClassByTagType(tagType);

				if(TagClass == null)
				{
					TagClass = Tag;
				}
				tag = new TagClass();
				tag.tagType = tagType;
				tag.tagLength = tagLength;

				if(tag.tagLength < 0 || bytes.position + tag.tagLength > bytes.length)
				{
					//trace("error tag length:" + tag.tagLength);
					continue;
				}

				if(tagLength > 0)
				{
					bytes.readBytes(tag.bt, 0, tagLength);
				}
				//				if(count >= 62 && tag.tagType == TagTypes.TAG_DOABC){
				//					trace(count)
				//				}
				//				if([62,63,64,65,66,67,72,75,78,100].indexOf(count) >= 0){
				//					count++;//天地会做的熊猫来了的swf【app.swf】不能解析的部分
				//					continue;
				//				}
				//				try{
				tag.parse();

				//				}catch(err:Error){
				//					trace("Error:" + count + "," + tag.tagName);
				//					continue;
				//				}
				if(tagType == TagTypes.TAG_DOACTION || (tagType == TagTypes.TAG_DEFINEBITSJPEG2 || tagType == TagTypes.TAG_DEFINEBITS || tagType == TagTypes.TAG_DEFINEBITSLOSSLESS) && tagLength == 0)
				{
					continue;
				}
				tags.push(tag);
				count++;

				if(tagType == TagTypes.TAG_END)
				{
					break;
				}
			}
		}

		/**
		 * 读取tag类型，不移动position
		 * @param bytes
		 * @return
		 */
		private function readTagType(bytes : ByteArray) : uint
		{
			var result : uint = bytes.readUnsignedShort();
			result = result >> 6;

			bytes.position -= 2;

			return result;
		}

		/**
		 * 读取tag长度 不包括头本身占的长度
		 * @param bytes
		 * @return
		 *
		 */
		public function readTagLength(bytes : ByteArray) : uint
		{
			var tagLength : uint = (bytes.readUnsignedShort() & 0x3F);

			if(tagLength == 0x3F)
			{
				tagLength = bytes.readUnsignedInt();
			}

			if(tagLength < 0)
			{
				throw(Error("SWFReader:无效的tag长度"));
			}

			return tagLength;
		}
	}
}