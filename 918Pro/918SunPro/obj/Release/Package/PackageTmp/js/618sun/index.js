﻿//var customURL = "http://f88.live800.com/live800/chatClient/chatbox.jsp?companyID=504420&configID=127905&jid=3308311799&operatorId=56512"; /*客服链接*/

//function openwin() {
//    window.open(customURL, '申博客服', 'height=570, width=750, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no')
//}

//按钮容器aa，滚动容器bb，滚动内容cc，滚动宽度dd，滚动数量ee，滚动方向ff，延时gg，滚动速度hh，自动滚动ii，
			/**
			 * parallelRoll 左右无缝滚动
			 * boxName : 最外层盒子类名
			 * tagName : 滚动标签元素
			 * time : 滚动间隔时间
			 * direction : 滚动方向  right-->向右    left-->向左
			 * visual : 可视数
			 * prev : 上一张
			 * next : 下一张
			 * author : MR chen 
			 * Date: 15-03-19
			 * */
			(function($){
				$.fn.parallelRoll = function(options){
					var opts = $.extend({}, $.fn.parallelRoll.defaults, options);
					var _this = this;					
					var l = _this.find(opts.tagName).length;
					var autoRollTimer;
					var flag = true; // 防止用户快速多次点击上下按钮
					var arr = new Array();
					/**
					 * 如果当  (可视个数+滚动个数 >滚动元素个数)  时  为不出现空白停顿   将滚动元素再赋值一次
					 * 同时赋值以后的滚动元素个数是之前的两倍  2 * l.
					 * */
					if(opts.amount + opts.visual > l){
						_this.innerHTML += _this.innerHTML;
						l = 2 * l;
					}else{
						l = l;
					}					
					var w = $(opts.tagName).outerWidth(true); //计算元素的宽度  包括补白+边框
					_this.css({width: (l * w) + 'px'}); // 设置滚动层盒子的宽度
					return this.each(function(){
						_this.closest('.'+opts.boxName).hover(function(){							
							clearInterval(autoRollTimer);
						},function(){							
							switch (opts.direction){
								case 'left':
									autoRollTimer = setInterval(function(){
										left();
									},opts.time);
								break;
								case 'right':
									autoRollTimer = setInterval(function(){
										right();
									},opts.time);
								break;
								default : 
									alert('参数错误！');
								break;
							}							
						}).trigger('mouseleave');
						$('.'+opts.prev).on('click',function(){
							flag ? left() : "";
						});
						$('.'+opts.next).on('click',function(){
							flag ? right() : "";
						});
					});					
					function left(){
						flag = false;
						_this.animate({marginLeft : -(w*opts.amount)},1000,function(){
							_this.find(opts.tagName).slice(0,opts.amount).appendTo(_this);
							_this.css({marginLeft:0});
							flag = true;
						});
					};
					function right(){
						flag = false;
						arr = _this.find(opts.tagName).slice(-opts.amount);										
						for(var i = 0; i<opts.amount; i++){
							$(arr[i]).css({marginLeft : -w*(i+1)}).prependTo(_this);
						}										
						_this.animate({marginLeft : w*opts.amount},1000,function(){
							_this.find(opts.tagName).removeAttr('style');
							_this.css({marginLeft:0});
							flag = true;
						});
					};
				};
				//插件默认选项
			    $.fn.parallelRoll.defaults = {
			    	boxName : 'box',
			        tagName : 'dd',
			        time : 3000,  // 
			        direction : 'left', // 滚动方向
			        visual : 7 , //可视数
			        prev : 'prev',
			        next : 'next',
			        amount : 1   // 滚动数  默认是1
			    };
			    
			})(jQuery);
			$(document).ready(function () {
			    $("#roll").parallelRoll({
			        amount: 2
			    });
			});
			$(document).ready(function () {
			 
				$("#roll").parallelRoll({
					amount : 2
				});

				GetNotices();
				GetPro_setup();
				function GetPro_setup() {
				    var noticeHTML = "";
				    var url = "/ServiceFile/UserService.asmx/GetPro_setup";
				    var data = "";
				    $.AjaxCommon({
				        url: url, data: '', toSuccess: function (json) {
				            var result = $.parseJSON(json.d);

				            $('#pro_setup').attr('href', result[0].Oval);
				            $('#pro_setup1').attr('href', result[0].Oval);

				        }
				    });
				}
				function GetNotices() {
				    var noticeHTML = "";
				    var url = "/ServiceFile/UserService.asmx/GetNoticeBylan";
				    var data = "";
				    $.AjaxCommon({
				        url: url, data: data, toSuccess: function (json) {
				            var result = $.parseJSON(json.d);
				            $.each(result, function (i) {
				                noticeHTML += "<span >" + result[i].Msgcn + "</span>　";
				            });
				            $("#demo2").html(noticeHTML);


				        }
				    });
				}
			});