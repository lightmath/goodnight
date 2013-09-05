
/**
 * 腾讯平台相关JS方法
 */

//显示或隐藏flash
function showFlash(show){
	if(show==true)
	{
		mainSwf().style.height = '100%';
		document.getElementById("buttons").style.display='none';
	}
	else
	{
		mainSwf().style.height = "0%";
		document.getElementById("buttons").style.display='';
	}
}


//邀请好友开通
function qq_invite(inviteCallbackName){
	fusion2.dialog.invite({
		msg  : "邀请你来玩~",
		source : "form sourceId="+openid,
		onSuccess :function(opt){
			inviteCallBack(inviteCallbackName, opt);
		}
	});
}

//邀请好友成功回调
function inviteCallBack(inviteCallbackName, opt){
	iceDogCallback(inviteCallbackName, [opt]);
}

//游戏币购买道具
function buyGoldItem(url_params,isDisturb){
    fusion2.dialog.buy({
    	param:url_params, 
    	disturb : isDisturb,
    	sandbox : false,
    	onCancel : function(opt){}
    });
}

//发送feed
function sendStory(dtitle, dimg, dsummary, dmsg){
	fusion2.dialog.sendStory
	({
	  title:"极限格斗",
	  img:dimg,
	  summary:dsummary,
	  msg:dmsg,
	  source :"ref=story&act=default",
	  context:"send-story-12345",
	  onShown : function (opt) 
	  {
	  },
	  onSuccess : function (opt) 
	  {  
	  },
	  onClose : function (opt) 
	  {  
	  }
	});
}


//开通黄钻页面
function openHuangZuan()
{
	openOtherWindow("http://pay.qq.com/qzone/index.shtml?aid=game100679763.op");
}

function preventIndulge()
{
	var url = "http://www.icedoggames.com/anti_addiction.php?accountID="+accountId;
	openOtherWindow(url);
}

function openHuangZuan02()
{
	openOtherWindow("http://app100679763.imgcache.qzoneapp.com/app100679763/qqSvn/diamond.htm");
}

//打开其他页面
function openOtherWindow(url){
	window.open(url,'_blank');
}

/**
 * 获取平台的参数
 */
function getQQPlatformParameter(callbackName){
	iceDogCallback(callbackName, [openid, openkey, pfkey, zoneid, pf]);
}

/**
 * 对AS回调 回调的方法名字，后跟可变长参数
 */
function iceDogCallback(callbackName, objs){
    if (callbackName == undefined || callbackName == "") {
        //nothing
    } else if (typeof(callbackName) == 'function') {
        callbackName(objs);
    } else if (mainSwf()) {
        mainSwf()[callbackName](objs);
    }
}

function mainSwf(){
    return getSWF('flashcontent');
}

function getSWF(movieName){
    if (navigator.appName.indexOf("Microsoft") != -1) {
        return window[movieName];
    } else {
        return document[movieName];
    }
}