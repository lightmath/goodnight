package com.pw282.swf.data
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class BaseData
	{
		public function BaseData(bt : ByteArray = null)
		{
			if(bt != null)
			{
				read(bt);
			}
		}

		public function read(bt : ByteArray) : void
		{

		}

		public function write(bt : ByteArray) : void
		{
			trace(getQualifiedClassName(this));
		}

		public function toString() : String
		{
			return "BaseData";
		}

		public function encrypt() : void
		{

		}

		public function collectEncryptName() : void
		{
			
		}
	}
}