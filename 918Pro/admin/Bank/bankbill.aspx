﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="bankbill.aspx.cs" Inherits="admin.Bank.bankbill" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
<meta http-equiv="X-UA-Compatible" content="IE=7" />
    <link href="/css/Default/globle.css" rel="stylesheet" type="text/css" />
    <link href="/css/Default/right_main.css" rel="stylesheet" type="text/css" />
    <link href="/css/Default/tab.css" rel="stylesheet" type="text/css" />
    <link href="/css/Default/style.css" rel="stylesheet" type="text/css" />
    <link href="/css/Default/cupertino/jquery.ui.all.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script src="/js/jquery-ui.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="/js/jQueryCommon.js"></script>
    <script src="/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
    <script src="/js/webBasicInfo/zh-CN.js" type="text/javascript"></script>
    <link href="/css/Default/cupertino/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
    .ui-effects-transfer { border: 2px dotted gray; } 
        #divTip
        {
        	left:45%;top:45%; 
        	
        	font-family:sans-serif; position:absolute; font-size:10px;padding:5px;background:#f3f3f3;color:gray;display:none;-moz-border-radius:5px;-webkit-border-radius:5px;border:1px solid #ccc
        }

    </style>

    <script type="text/javascript">
        var f1;
        var Names;

        jQuery(function () {
            //多语言
            f1 = jQuery("#datarow").clone();
            SetGlobal("");

            jQuery("#selectByWhere").click(function () {
                GetBank();
            });
            $("#time1,#time2").datepicker().click(function () {
                $(this).val("");
            });
            var selectbz = getSelectBz();
            jQuery("#UIDS").html(selectbz);
            jQuery("#bz1").html(selectbz);
            jQuery("#sbank").html(GetBanks());
            jQuery("#sbank").change(function(){
                jQuery("#scardno").html(GetBankListcBynamecn("sbank"));
            });
            jQuery("#bzz").change(function(){
                jQuery("#addbank").html(GetBankListcByCurrency());
            });
            jQuery("#addbank").change(function(){
                jQuery("#addcardno").html(GetBankListcBynamecn("addbank"))
            });
        });
        function GetBank() {
            var url = "/ServicesFile/BankService/BankService.asmx/GetBankhistorybyWhere";
            var data = "typ:'" + jQuery("#styp").val() + "',bank:'" + jQuery("#sbank").val() + "',cardno:'" + jQuery("#scardno").val() + "',time1:'" + jQuery("#time1").val() + "',time2:'" + jQuery("#time2").val() + "'";
            jQuery.AjaxCommon(url, data, true, false, function (json) {
                if (json.d != "") {
                    var result = jQuery.parseJSON(json.d);
                    var html = "";
                    //jQuery("#tab>tr:gt(0)").remove();
                    jQuery("#tab").html("");
                    jQuery.each(result, function (i) {
                        html += "<tr>";
                        html += "<td>" + result[i].isdate + "</td>";
                        html += "<td>" + result[i].Currency + "</td>";
                        html += "<td>" + result[i].bank + "</td>";
                        html += "<td>" + result[i].cardno + "</td>";
                        html += "<td>" + (result[i].Typ == "1" ? "存款" : "取款") + "</td>";
                        html += "<td>" + result[i].amount + "</td>";
                        html += "<td>" + result[i].balance + "</td>";
                        html += "<td>" + result[i].operator + "</td>";
                        html += "<td>" + result[i].operationtime + "</td>";
                        html += "<td>" + result[i].ip + "</td>";
                        <% if (upAc)
                            { %>
                        html += "<td><a id=\"update\" style=\"cursor:hand\" onclick=\"edit(this,'" + result[i].ID + "')\"><img title=\"修改\" src=\"/images/Icon/Icon167.png\" /> 修改</a></td>";
                        <% } %>
                        html += "</tr>";
                    });
                    jQuery("#tab").html(html);
                    $("#tab>tr").mouseover(function () {
                        $(this).siblings().removeClass("trOver").end().addClass("trOver");
                    });
                }
                else {

                }
            });
        }

        //---------多语言处理-----------
        var languages = "";
        var lang;
        function SetGlobal(setLang) {

            setLang = $.SetOrGetLanguage(setLang, function () {
                //debugger
                languages = language;

            });
            lang = setLang;
        }
        //--------多语言处理结束---------


        function SelectName(name) {
            var data = "Name:'" + name + "',Language:'" + $("#language").val() + "'";
            jQuery.AjaxCommon("/ServicesFile/RateService.asmx/CeliName", data, false, false, function (json) {
                Names = json.d;
            });
        }

        function add() {
            jQuery("#add").show();
            $("#Name").blur(function () {
                if ($("#Name").val() == "") {
                    //$("#Namelbl").html("不能为空");
                    $("#Namelbl").html(languages.H1000);
                    return false;
                }
                SelectName($("#Name").val());
                if (Names == "True") {
                    // $("#Namelbl").html("匯率類型已經存在");
                    $("#Namelbl").html(languages.H1181);
                    return false;
                } else {
                    $("#Namelbl").html("");
                }
            });
            $("#Rate").blur(function () {
                if ($("#Rate").val() == "") {
                    //$("#Ratelbl").html("不能为空");
                    $("#Ratelbl").html(languages.H1000);
                    return false;
                } else {
                    var namePattern = /^-?\d+\.?\d{0,4}$/;
                    if (!namePattern.test($("#Rate").val())) {
                        //$("#Ratelbl").html("非0数字,小数位不能超过4位");H1182
                        $("#Ratelbl").html(languages.H1182);
                        return false;
                    }
                    else {
                        $("#Ratelbl").html("");
                    }
                }
            });

            jQuery("#AddButton").unbind("click");
            jQuery("#AddButton").bind("click", function () {

                //jQuery("#code").blur();
                var check = true;
                jQuery.each(jQuery("#addtable :text"), function (i, n) {
                    jQuery(n).blur();
                });


                //                if(jQuery("#codelb").html() != ""){
                //                    return false;
                //                }
                jQuery.each(jQuery("#addtable label"), function (i, n) {
                    if (jQuery(n).html() != "") {
                        check = false;
                    }
                });
                if (!check) {
                    return check;
                }

                var url = "/ServicesFile/BankService/BankService.asmx/AddBankhistory";
                var data = "Currency:'" + jQuery("#addtable select:eq(0)").val() + "',bank:'" + jQuery("#addbank").val() + "',cardno:'" + jQuery("#addcardno").val() + "',Typ:'" + jQuery("#addTyp").val() + "',amount:" + jQuery("#addamount").val() + ",balance:" + jQuery("#addbalance").val();
                jQuery.AjaxCommon(url, data, false, false, function (json) {
                    if (json.d) {
                        jQuery("#add").hide();

                        //jQuery.MsgTip({ objId: "#divTip", msg: "增加汇率成功" });
                        jQuery.MsgTip({ objId: "#divTip", msg: "新增成功！" });
                        jQuery("#updata").hide().appendTo("#form1");
                        //GetBank();
                    }
                    else {
                        //jQuery.MsgTip({ objId: "#divTip", msg: "增加汇率失败" });
                        jQuery.MsgTip({ objId: "#divTip", msg: "新增失败！" });
                    }
                });

                $("#Name").val("");
                $("#Rate").val("");
            });
            jQuery("#AddCancel").unbind("click");
            jQuery("#AddCancel").bind("click", function () {
                jQuery("#add").hide();
                $("#Namelbl").html("");
                $("#Ratelbl").html("");
            });
        }


        function edit(obj, id) {
            jQuery("#updata").hide().appendTo("#form1");
            f1.find("td:gt(0)").remove();
            f1.find("td:eq(0)").text("");
            f1.find("td:eq(0)").attr("colspan", "11");
            jQuery("#updata").show();
            $("#serverId").val(id);
            jQuery("#updatetable select:eq(0)").val(jQuery(obj).parent().parent().find("td:eq(1)").text());
            jQuery("#upbank").val(jQuery(obj).parent().parent().find("td:eq(2)").text());
            jQuery("#upcardno").val(jQuery(obj).parent().parent().find("td:eq(3)").text());
            jQuery("#upTyp").val((jQuery(obj).parent().parent().find("td:eq(4)").text() == "存款" ? "1" : "2"));
            jQuery("#upamount").val(jQuery(obj).parent().parent().find("td:eq(5)").text());
            jQuery("#upbalance").val(jQuery(obj).parent().parent().find("td:eq(6)").text());

            var uName = jQuery(obj).parent().parent().find("#tdname").text();
            f1.find("td:eq(0)").append(jQuery("#updata"));
            jQuery(obj).parent().parent().after(f1.show());
            $("#uName").blur(function () {
                if ($("#uName").val() == "") {
                    //$("#uNamelbl").html("不能为空");
                    $("#uNamelbl").html(languages.H1000);
                    return false;
                } else {
                    $("#uNamelbl").html("");
                }

            });

            $("#uRate").blur(function () {
                if ($("#uRate").val() == "") {
                    //$("#uRatelbl").html("不能为空");
                    $("#uRatelbl").html(languages.H1000);
                    return false;
                } else {
                    var namePattern = /^-?\d+\.?\d{0,4}$/;
                    if (!namePattern.test($("#uRate").val())) {
                        //$("#uRatelbl").html("非0数字,小数位不能超过4位");
                        $("#uRatelbl").html(languages.H1182);
                        return false;
                    }
                    else {
                        $("#uRatelbl").html("");
                    }
                }
            });
            jQuery("#updataButton").unbind("click");
            jQuery("#updataButton").bind("click", function () {
                //var id = $("#serverId").val();

                //jQuery("#mdfcode").blur();
                var check = true;
                jQuery.each(jQuery("#updatetable :text"), function (i, n) {
                    jQuery(n).blur();
                });

                jQuery.each(jQuery("#updatetable label"), function (i, n) {
                    if (jQuery(n).html() != "") {
                        check = false;
                    }
                });
                if (!check) {
                    return check;
                }

                var data = "Currency:'" + jQuery("#updatetable select:eq(0)").val() + "',bank:'" + jQuery("#upbank").val() + "',cardno:'" + jQuery("#upcardno").val() + "',Typ:'" + jQuery("#upTyp").val() + "',amount:" + jQuery("#upamount").val() + ",balance:" + jQuery("#upbalance").val() + ",ID:" + id;
                var url = "/ServicesFile/BankService/BankService.asmx/UpdateBankhistory";
                jQuery.AjaxCommon(url, data, false, false, function (json) {
                    if (json.d) {
                        $("#uNamelbl").html("");
                        if (json.d != "none") {
                            // $.MsgTip({ objId: "#divTip", msg: "修改成功" });
                            $.MsgTip({ objId: "#divTip", msg: "修改成功" });
                            jQuery("#updata").parent().parent().hide();

                            jQuery(obj).parent().parent().find("td:eq(1)").html(jQuery("#updatetable select:eq(0)").val());
                            jQuery(obj).parent().parent().find("td:eq(2)").html(jQuery("#upbank").val());
                            jQuery(obj).parent().parent().find("td:eq(3)").html(jQuery("#upcardno").val());
                            jQuery(obj).parent().parent().find("td:eq(4)").html(jQuery("#upTyp :selected").text());
                            jQuery(obj).parent().parent().find("td:eq(5)").html(jQuery("#upamount").val());
                            jQuery(obj).parent().parent().find("td:eq(6)").html(jQuery("#upbalance").val());
                        }
                        else {
                            // $.MsgTip({ objId: "#divTip", msg: "修改失败" });
                            $.MsgTip({ objId: "#divTip", msg: languages.H1013 });
                        }
                    } else {
                        //$("#uNamelbl").html("匯率類型已經存在");
                        $.MsgTip({ objId: "#divTip", msg: languages.H1013 });
                    }
                });

            });

            jQuery("#escButton").unbind("click");
            jQuery("#escButton").bind("click", function () {
                $("#uNamelbl").html("");
                $("#uRatelbl").html("");
                jQuery("#updata").parent().parent().hide();
            });
        }

        function delet(obj, id) {
            jQuery("#delet").dialog({ modal: false });

            jQuery("#deleteEsc").unbind("click");
            jQuery("#deleteEsc").bind("click", function () {
                jQuery("#delet").dialog("close");
            });

            jQuery("#deletebtn").unbind("click");
            jQuery("#deletebtn").bind("click", function () {
                jQuery("#delet").dialog("close");
                var typename = jQuery(obj).parent().parent().find("#tdname").text();
                var url = "/ServicesFile/BankService/BankService.asmx/DeleteRefused";
                var data = "ID:" + id;
                jQuery.AjaxCommon(url, data, false, false, function (json) {
                    if (json.d) {
                        $(obj).parent().parent().remove();
                        //$.MsgTip({ objId: "#divTip", msg: "删除成功" });
                        $.MsgTip({ objId: "#divTip", msg: languages.H1073 });
                    }
                    else {
                        //$.MsgTip({ objId: "#divTip", msg: "删除失败" });
                        $.MsgTip({ objId: "#divTip", msg: languages.H1186 });
                    }
                });
            });
        }
        function getSelectBz() {
            var html = "<select id='bzz'><option value=''>请选择</option>";
            var url = "/ServicesFile/RateService.asmx/GetRateByLan";
            var data = "language:'" + lang + "'";
            jQuery.AjaxCommon(url, data, false, false, function (json) {
                if (json.d != "none") {
                    var result = jQuery.parseJSON(json.d);
                    jQuery.each(result, function (i) {

                        html += "<option value=" + result[i].code + ">" + result[i].name + "</option>";

                    });
                    html += "</select>";
                }
                else {

                }
            });
            return html;
        }

        function GetBanks() {
            var html = "<option value=''>请选择</option>";
            var url = "/ServicesFile/BankService/BankService.asmx/GetBanklistc";
            var data = "";
            jQuery.AjaxCommon(url, data, false, false, function (json) {
                if (json.d != "none") {
                    var result = jQuery.parseJSON(json.d);
                    jQuery.each(result, function (i) {

                        html += "<option value=" + result[i].Namecn + ">" + result[i].Namecn + "</option>";

                    });
                }
                else {

                }
            });
            return html;

        }

        function GetBankListcBynamecn(objid){
            var html = "<option value=''>请选择</option>";
            var url = "/ServicesFile/BankService/BankService.asmx/GetBankListcBynamecn";
            var data = "namecn:'" + jQuery("#" + objid).val() + "'";
            jQuery.AjaxCommon(url, data, false, false, function (json) {
                if (json.d != "none") {
                    var result = jQuery.parseJSON(json.d);
                    jQuery.each(result, function (i) {

                        html += "<option value=" + result[i].cardno + ">" + result[i].cardno + "</option>";

                    });
                }
                else {

                }
            });
            return html;
        }

        function GetBankListcByCurrency() {
            var html = "<option value=''>请选择</option>";
            var url = "/ServicesFile/BankService/BankService.asmx/GetBankListcByCurrency";
            var data = "currency:'" + jQuery("#bzz").val() + "'";
            jQuery.AjaxCommon(url, data, false, false, function (json) {
                if (json.d != "none") {
                    var result = jQuery.parseJSON(json.d);
                    jQuery.each(result, function (i) {

                        html += "<option value=" + result[i].namecn + ">" + result[i].namecn + "</option>";

                    });
                }
                else {

                }
            });
            return html;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
<table  id="right_main" border="0" width="100%" cellpadding="0" cellspacing="0">
<thead>
<tr class="h30">
<th width="12" class="tab_top_l"></th>
<th width="*" class="tab_top_m"><p id="hlgl">银行日记账</p></th>
<th width="16" class="tab_top_r"></th>
</tr>
</thead>

<tbody>
<tr>
<td class="tab_middle_l"></td>
<td >
<div id="main">
<!--主题部分开始=========================================================================================-->
<input type="hidden" id="langue" value="tw" />
<div class="top_banner h30">


<div class="f1">
<% if (addAc)
   { %>
<input type="button" id="addBtn" onclick="add()" class="top_add" onmouseover="this.className='top_add_h'" onmouseout="this.className='top_add'"  value="新增记账" />
<%} %>
    <a id="zt">类型</a>&nbsp;&nbsp;<select id="styp"><option value="">请选择</option>
        <option value="1">存款</option><option value="2">取款</option>
    </select>&nbsp;&nbsp;&nbsp;&nbsp;
    <a id="hy">银行</a>&nbsp;&nbsp;
    <select id="sbank">
        <option value="">请选择</option>
    </select>
    <%--<input type="text" id="sbank" class="inputWhere text_01 w_100" onmouseover="this.className='text_01_h w_100'" onmouseout="this.className='text_01 w_100'" />--%>&nbsp;&nbsp;&nbsp;&nbsp;
    <a id="A1">银行帐号</a>&nbsp;&nbsp;
    <select id="scardno">
        <option value="">请选择</option>
    </select>
    <%--<input type="text" id="scardno" class="inputWhere text_01 w_100" onmouseover="this.className='text_01_h w_100'" onmouseout="this.className='text_01 w_100'" />--%>&nbsp;&nbsp;&nbsp;&nbsp;
    <a id="jysj">时间</a>&nbsp;&nbsp;<input type="text" id="time1" class="inputWhere text_01 w_100" onmouseover="this.className='text_01_h w_100'" onmouseout="this.className='text_01 w_100'" readonly="readonly"  />－<input type="text" id="time2" class="inputWhere text_01 w_100" onmouseover="this.className='text_01_h w_100'" onmouseout="this.className='text_01 w_100'" readonly="readonly"  />&nbsp;&nbsp;&nbsp;&nbsp;
    
    <a id="selectByWhere" class="fa_saurch"><span class="fa_saurch_in">搜索</span></a>

</div>

</div>
<div class="cl"></div>
<div id="add" class="new_tr undis">

<div  title="新增记账" >
<div align="center">
<table width="85%"  border="0" cellpadding="1" cellspacing="1" id="addtable">
  <tr align="center" style="background-color:#CDEAFC">
    <td id="addhlsz" colspan="6">新增记账</td>
  </tr>
  <tr>
    <td align="right"><span id="hllx1">币种</span>：</td>
    <td align="left" id="UIDS">
        <input type="text" name="cn" id="cn" onblur="IsNullByInfo(this,'Namelbl','不能为空');" class="text_01 h20"  onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
        <label id="Namelbl" style="color:Red"></label>
    </td>

    <td align="right"><span id="hlz1">银行</span>：</td>
    <td align="left">
            <select id="addbank">
        <option value="">请选择</option>
    </select>

<%--         <input type="text" name="addbank" id="addbank" onblur="IsNullByInfo(this,'twlb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="twlb" style="color:Red"></label>
--%>    </td>

    <td align="right"><span id="Span1">银行帐号</span>：</td>
    <td align="left">
                    <select id="addcardno">
        <option value="">请选择</option>
    </select>

<%--         <input type="text" name="addcardno" id="addcardno" onblur="IsNullByInfo(this,'enlb','不能为空');" onblur="IsNullByInfo(this,'codelb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="enlb" style="color:Red"></label>
--%>    </td>

  </tr>

    <tr>
    <td align="right"><span id="Span3">类型</span>：</td>
    <td align="left" id="Td1">
        <select id="addTyp">
            <option value="1">存款</option>
            <option value="2">取款</option>
        </select>
    </td>

    <td align="right"><span id="Span4">金额</span>：</td>
    <td align="left">
         <input type="text" name="addamount" id="addamount" onblur="IsNullByInfo(this,'vnlb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="vnlb" style="color:Red"></label>
    </td>

    <td align="right"><span id="Span5">期初余额</span>：</td>
    <td align="left">
         <input type="text" name="addbalance" id="addbalance" onblur="IsNullByInfo(this,'Label1','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="Label1" style="color:Red"></label>
    </td>

  </tr>

  <tr>
    <td align="right" colspan="6" style="height:20px;"><input type="hidden" id="language" value="tw"/></td>
  </tr>
  <tr>
    <td colspan="6" align="center">
<input type="button" id="AddButton"  class="btn_02" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'"  value="增加" />
<input type="button" id="AddCancel"  class="btn_02" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'" value="取消" />
	
	</td>
  </tr>
</table>
</div>
<div class="new_trfoot"></div>
</div>

</div>

<div id="updata" class="new_tr undis">
<div  title="修改记账" >
<div align="center">
<table width="85%"  border="0" cellpadding="1" cellspacing="1" id="updatetable">
  <tr align="center" style="background-color:#CDEAFC">
    <td colspan="6" id="uphlsz">修改记账</td>
  </tr>
  <tr>
    <td align="right"><span id="uphllx1">币种</span>：</td>
    <td align="left" id="bz1">
        <input type="text" name="upcn" id="upcn" class="text_01 h20" onblur="IsNullByInfo(this,'upcnlb','不能为空');"  onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
        <label id="upcnlb" style="color:Red"></label>
    </td>

    <td align="right"><span id="uphlz1">银行</span>：</td>
    <td align="left">
         <input type="text" name="upbank" id="upbank" onblur="IsNullByInfo(this,'uptwlb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="uptwlb" style="color:Red"></label>
    </td>

    <td align="right"><span id="Span2">帐号</span>：</td>
    <td align="left">
         <input type="text" name="upcardno" id="upcardno" onblur="IsNullByInfo(this,'upenlb','不能为空');" onblur="IsNullByInfo(this,'mdfcodelb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="upenlb" style="color:Red"></label>
    </td>

  </tr>

    <tr>
    <td align="right"><span id="Span9">类型</span>：</td>
    <td align="left">
        <select id="upTyp">
            <option value="1">存款</option>
            <option value="2">取款</option>
        </select>
    </td>

    <td align="right"><span id="Span10">金额</span>：</td>
    <td align="left">
         <input type="text" name="upamount" id="upamount" onblur="IsNullByInfo(this,'upvnlb','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="upvnlb" style="color:Red"></label>
    </td>

    <td align="right"><span id="Span6">余额</span>：</td>
    <td align="left">
         <input type="text" name="upbalance" id="upbalance" onblur="IsNullByInfo(this,'Label2','不能为空');" class="text_01 h20" onmouseover="this.className='text_01_h h20'"  onmouseout="this.className='text_01 h20'" />
         <label id="Label2" style="color:Red"></label>
    </td>

  </tr>

  <tr style="height:20px">
  <td align="right" colspan="6" style="height:20px;"></td>
  </tr>
  <tr>
    <td colspan="6" align="center" >
<input type="button" id="updataButton"  class="btn_02" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'"  value="确定" />
<input type="button" id="escButton"  class="btn_02" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'" value="取消" />
	</td>
  </tr>
</table>
</div>
<div class="new_trfoot"></div>
</div>
</div>
    <table id="tab3" width=100% cellpadding=0 cellspacing="0" border=0 >
        <thead> 
        <tr>
        <th id="RetaType">日期</th>
        <th id="tdtw1">币种</th>
        <th id="tden1">银行</th>
        <th id="tdth1">帐号</th>
        <th id="tdvn1">类型</th>
        <th id="Th2">金额</th>
        <th id="Th3">余额</th>
        <th id="Th1">操作人</th>
        <th id="ExchangeValue">操作时间</th>
        <th id="Operator">IP</th>
        <% if (upAc)
           { %>
        <th id="up">修改</th>
        <%} %>
        </tr>
        </thead> 
        <tbody id="tab">
        <tr id="datarow">
        <td id="tdname"></td>
        <td id="tdtw"></td>
        <td id="tden"></td>
        <td id="tdth"></td>
        <td id="tdvn"></td>
        <td id="tdcode"></td>
        <td id="tdrate"></td>
        <td id="tdoperator" style="width:80px"></td>
        <td id="tdupdate" style="width:70px"></td>
        <td id="tddelete" style="width:70px"></td>
        <% if (upAc)
           { %>
        <td id="td2" style="width:70px"></td>
        <% } %>
        </tr>
        </tbody> 
        <tfoot>
        <tr>
        <td colspan="11">

            &nbsp;</td>
        </tr>
        </tfoot>
        </table>

<div class="undis">

<div id="delet" title="删除提示" >
<div class="showdiv">
<p class="wrnning">确定要删除此项吗？</p>
<div align="center" class="mtop_50">
    <input type="button" id="deletebtn" class="btn_02" value="确定" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'" />
    <input type="button" id="deleteEsc" class="btn_02" onmouseover="this.className='btn_02_h'" onmouseout="this.className='btn_02'" value="取消" />
</div>

</div>
</div>
</div>

<!--主题部分结束=========================================================================================-->
</div>
</td>
<td class="tab_middle_r"></td>
</tr>
</tbody>

<tfoot>
<tr class="h35">
<td width="12" class="tab_foot_l"></td>
<td width="*" class="tab_foot_m">

</td>
<td width="16" class="tab_foot_r"></td>
</tr>
</tfoot>
</table>
<div id="loading"></div>
<div id="divTip" ></div>

    </form>
</body>
</html>