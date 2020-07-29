<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JTools - Signature verification</title>
    <meta name="keywords" content="Signature algorithm test 微信签名验证">

    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />
    <@netCommon.commonScript />
<script>

    <@netCommon.viewerCounter />

    $(function () {
        /**
         * 初始化 table sql 3
         */
        var ddlSqlArea = CodeMirror.fromTextArea(document.getElementById("area"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-sql",
            lineWrapping:false,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        ddlSqlArea.setSize('auto','auto');
        // controller_ide
        var genCodeArea = CodeMirror.fromTextArea(document.getElementById("genCodeArea"), {
            lineNumbers: true,
            matchBrackets: true,
            mode: "text/x-java",
            lineWrapping:true,
            readOnly:false,
            foldGutter: true,
            //keyMap:"sublime",
            gutters:["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
        });
        genCodeArea.setSize('auto','auto');

        var codeData;
        // 使用：var jsonObj = $("#formId").serializeObject();
        $.fn.serializeObject = function()
        {
            var o = {};
            var a = this.serializeArray();
            $.each(a, function() {
                if (o[this.name]) {
                    if (!o[this.name].push) {
                        o[this.name] = [o[this.name]];
                    }
                    o[this.name].push(this.value || '');
                } else {
                    o[this.name] = this.value || '';
                }
            });
            return o;
        };
        var historyCount=0;
        //初始化清除session
        if (window.sessionStorage){
            //修复当F5刷新的时候，session没有清空各个值，但是页面的button没了。
            sessionStorage.clear();
        }
        /**
         * 生成代码
         */
        $('#btnGenCode').click(function ()  {
            var jsonData = {
                "appKey": $("#appKey").val(),
                "area":ddlSqlArea.getValue()
            };
            $.ajax({
                type: 'POST',
                url: base_url + "/sign/gensign",
                data:(JSON.stringify(jsonData)),
                dataType: "json",
                contentType: "application/json",
                success: function (data) {
                    if (data.code === 200) {
                        codeData = data.data;
                        genCodeArea.setValue(codeData.sign);
                        genCodeArea.setSize('auto', 'auto');
                        $.toast("√ success");
                    } else {
                        $.toast("× fail :" + data.msg);
                    }
                }
            });
            return false;
        });

        /**
         * 按钮事件组
         */
        $('.generator').bind('click', function () {
            if (!$.isEmptyObject(codeData)) {
                var id = this.id;
                genCodeArea.setValue(codeData[id]);
                genCodeArea.setSize('auto', 'auto');
            }
        });

        $('#btnCopy').on('click', function(){
            if(!$.isEmptyObject(genCodeArea.getValue())&&!$.isEmptyObject(navigator)&&!$.isEmptyObject(navigator.clipboard)){
                navigator.clipboard.writeText(genCodeArea.getValue());
                $.toast("√ Copy successfully");
            }
        });

        function getVersion(){
            $.toast("#current version: 20200729");
        }
        $('#version').on('click', function(){
            getVersion();
        });
    });
</script>
</head>
<body style="background-color: #e9ecef">

    <#--<div class="container">-->
        <#--<nav class="navbar navbar-dark bg-primary btn-lg">-->
            <#--<a class="navbar-brand" href="https://wanglei0530.github.io/" target="_blank">站长主页</a>-->
            <#--<ul class="nav navbar-nav">-->
                <#--<li class="nav-item active">-->
                    <#--<a class="nav-link" href="https://github.com/wanglei0530/jtools" target="_blank">JTools</a>-->
                <#--</li>-->
            <#--</ul>-->
        <#--</nav>-->
    <#--</div>-->

<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron">
    <div class="container">
        <h2>Signature authentication!</h2>
        <p class="lead">
            This tool is designed to help developers detect whether the signature generated in the request parameters sent when calling [Nanopay API] is correct, and the signature verification result can be obtained after submitting relevant information！
        </p>
        <textarea id="area" placeholder="Please enter Json parameters..." class="form-control btn-lg" style="height: 250px;">
{
    "merchantId":12345678,
    "appId":87654321,
    "timestamp":1577242762482,
    "version":"1.0",
    "expireTime":3600
}
        </textarea>
        <br>
        <div class="input-group mb-3">
            <div class="input-group-prepend">
                <span class="input-group-text">APP KEY</span>
            </div>
            <input type="text" class="form-control" id="appKey" name="appKey" value="">
        </div>
        <p>
            <button class="btn btn-primary " id="btnGenCode" role="button" data-toggle="popover" data-content="">Generate</button>
        </p>
        <br>
    <#--<hr>-->
        <#--<!-- Example row of columns &ndash;&gt;-->
        <#--<div class="row" style="margin-top: 10px;">-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">通用实体</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="model">entity(set/get)</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="beetlentity">entity(lombok)</button>-->
                <#--</div>-->
            <#--</div>-->
            <#--<div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Mybatis</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="mybatis">mybatis</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="mapper">mapper</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="service">service</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="service_impl">service_impl</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="controller">controller</button>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->
        <#--<!-- Example row of columns &ndash;&gt;-->
        <#--<div class="row" style="margin-top: 10px;">-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">MybatisPlus</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="plusmapper">mapper</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="pluscontroller">controller</button>-->
                <#--</div>-->
            <#--</div>-->

            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">UI</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="swagger-ui">swagger-ui</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="element-ui">element-ui</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="bootstrap-ui">bootstrap-ui</button>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->

        <#--<div class="row" style="margin-top: 10px;">-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">BeetlSQL</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="beetlmd">beetlmd</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="beetlcontroller">beetlcontroller</button>-->
                <#--</div>-->
            <#--</div>-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JPA</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="entity">jpa-entity</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="repository">repository</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="jpacontroller">controller</button>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->
        <#--<div class="row" style="margin-top: 10px;">-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JdbcTemplate</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="jtdaoimpl">daoimpl</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="jtdao">dao</button>-->
                <#--</div>-->
            <#--</div>-->
            <#--<div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">SQL</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="select">select</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="insert">insert</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="update">update</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="delete">delete</button>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->
        <#--<div class="row" style="margin-top: 10px;">-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">DTO</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="beetlentitydto">entitydto(lombok+swagger)</button>-->
                <#--</div>-->
            <#--</div>-->
            <#--<div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">-->
                <#--<div class="input-group">-->
                    <#--<div class="input-group-prepend">-->
                        <#--<div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Util</div>-->
                    <#--</div>-->
                <#--</div>-->
                <#--<div class="btn-group" role="group" aria-label="First group">-->
                    <#--<button type="button" class="btn btn-default generator" id="util">bean get set</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="json">json</button>-->
                    <#--<button type="button" class="btn btn-default generator" id="xml">xml</button>-->
                <#--</div>-->
            <#--</div>-->
        <#--</div>-->
        <#--<hr>-->
        <textarea id="genCodeArea" class="form-control btn-lg" ></textarea>
        </br>
        <p>
            <button class="btn alert-secondary" id="btnCopy">Copy</button>
        </p>
    </div>
</div>
    <#--<@netCommon.commonFooter />-->
</body>
</html>
