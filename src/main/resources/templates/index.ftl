<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JTools代码生成</title>
    <meta name="keywords" content="JTools代码生成,Mybaits在线生成JTools,java王蕾,Json转Bean,Java JPA">

    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />
    <@netCommon.commonScript />
<script>

    <@netCommon.viewerCounter />

    $(function () {
        /**
         * 初始化 table sql 3
         */
        var ddlSqlArea = CodeMirror.fromTextArea(document.getElementById("ddlSqlArea"), {
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
                "tableSql": ddlSqlArea.getValue(),
                "packageName":$("#packageName").val(),
                "returnUtil":$("#returnUtil").val(),
                "authorName":$("#authorName").val(),
                "dataType":$("#dataType").val(),
                "tinyintTransType":$("#tinyintTransType").val(),
                "nameCaseType":$("#nameCaseType").val(),
                "swagger":$("#isSwagger").val()
            };
            $.ajax({
                type: 'POST',
                url: base_url + "/genCode",
                data:(JSON.stringify(jsonData)),
                dataType: "json",
                contentType: "application/json",
                success: function (data) {
                    if (data.code === 200) {
                        codeData = data.data;
                        genCodeArea.setValue(codeData.entity);
                        genCodeArea.setSize('auto', 'auto');
                        $.toast("√ 生成成功");
                        //添加历史记录
                        addHistory(codeData);
                    } else {
                        $.toast("× 生成失败 :"+data.msg);
                    }
                }
            });
            return false;
        });
        /**
         * 切换历史记录
         */
        function getHistory(tableName){
            if (window.sessionStorage){
                var valueSession = sessionStorage.getItem(tableName);
                codeData = JSON.parse(valueSession);
                $.toast("$ 切换历史记录成功:"+tableName);
                genCodeArea.setValue(codeData.entity);
            }else{
                console.log("浏览器不支持sessionStorage");
            }
        }
        /**
         * 添加历史记录
         */
        function addHistory(data){
            if (window.sessionStorage){
                //console.log(historyCount);
                if(historyCount>=9){
                    $("#history").find(".btn:last").remove();
                    historyCount--;
                }
                var tableName=data.tableName;
                var valueSession = sessionStorage.getItem(tableName);
                if(valueSession!==undefined && valueSession!=null){
                    sessionStorage.removeItem(tableName);
                }else{
                    $("#history").prepend('<button id="his-'+tableName+'" type="button" class="btn">'+tableName+'</button>');
                    //$("#history").prepend('<button id="his-'+tableName+'" onclick="getHistory(\''+tableName+'\');" type="button" class="btn">'+tableName+'</button>');
                    $("#his-"+tableName).bind('click', function () {getHistory(tableName)});
                }
                sessionStorage.setItem(tableName,JSON.stringify(data));
                historyCount++;
            }else{
                console.log("浏览器不支持sessionStorage");
            }
        }

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
        /**
         * 捐赠
         */
        function donate(){
            if($("#donate").attr("show")=="no"){
                $("#donate").html('<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ggxahvpj2tj3058054glq.jpg"></img>');
                $("#donate").attr("show","yes");
            }else{
                $("#donate").html('<p>谢谢赞赏！</p>');
                $("#donate").attr("show","no");
            }
        }
        /**
        * 捐赠
        */
        function jiaqun(){
            if($("#donate").attr("show")=="no"){
                $("#donate").html('<img src="https://tva1.sinaimg.cn/large/007S8ZIlly1ggxafjrveaj307j09375l.jpg"></img>');
                $("#donate").attr("show","yes");
            }else{
                $("#donate").html('<p>欢迎加入！</p>');
                $("#donate").attr("show","no");
            }
        }

        $('#jiaqun1').on('click', function(){
            jiaqun();
        });
        $('#jiaqun2').on('click', function(){
            jiaqun();
        });
        $('#donate1').on('click', function(){
            donate();
        });
        $('#donate2').on('click', function(){
            donate();
        });
        $('#btnCopy').on('click', function(){
            if(!$.isEmptyObject(genCodeArea.getValue())&&!$.isEmptyObject(navigator)&&!$.isEmptyObject(navigator.clipboard)){
                navigator.clipboard.writeText(genCodeArea.getValue());
                $.toast("√ 复制成功");
            }
        });

        function getVersion(){
            var gitVersion ;
            $.ajax({
                type: 'GET',
                url: base_url + "/static/version.json",
                dataType: "json",
                success: function (data) {
                    $.toast("#当前版本:" + data.version);
                }
            });
            // $.ajax({
            //     type: 'GET',
            //     url: "https://raw.githubusercontent.com/moshowgame/SpringBootCodeGenerator/master/generator-web/src/main/resources/static/version.json",
            //     dataType: "json",
            //     success: function (data) {
            //         gitVersion = data.version;
            //         $.ajax({
            //             type: 'GET',
            //             url: base_url + "/static/version.json",
            //             dataType: "json",
            //             success: function (data) {
            //                 $.toast("#当前版本:"+data.version+" | github:"+gitVersion);
            //             }
            //         });
            //     }
            // });
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
        <h2>在线Code生成工具</h2>
        <p class="lead">
            <#--√基于SpringBoot2+Freemarker的<a class="lead" href="https://github.com/wanglei0530/jtools" target="_blank" >代码生成器</a>，√以释放双手为目的，√支持mysql/oracle/pgsql三大数据库，<br>-->
                √信念和目标，必须永远洋溢在程序员内心！<br>
                √将SQL或JSON复制到文本框即可，生成JPA/JdbcTemplate/Mybatis/MybatisPlus/BeetlSQL相关代码。<br>
                如果使用中发现问题，请反馈给我<a href="https://wanglei0530.github.io/message/" target="_blank" >留言</a>，同时欢迎大家<a href="#" id="jiaqun1" >加群</a>讨论和<a href="#" id="donate1">赞赏</a>，谢谢！<a id="version" href="#">查看版本</a>。
        </p>
        <div id="donate" class="container" show="no"></div>
        <hr>
        <div class="input-group mb-3">
            <div class="input-group-prepend">
                <span class="input-group-text">作者名称</span>
            </div>
            <input type="text" class="form-control" id="authorName" name="authorName" value="jtools.top">
            <div class="input-group-prepend">
                <span class="input-group-text">返回封装</span>
            </div>
            <input type="text" class="form-control" id="returnUtil" name="returnUtil" value="ApiReturnObject">
            <div class="input-group-prepend">
                <span class="input-group-text">包名路径</span>
            </div>
            <input type="text" class="form-control" id="packageName" name="packageName" value="top.jtools.system">
        </div>
        <div class="input-group mb-3">
            <div class="input-group-prepend">
                <span class="input-group-text">数据类型</span>
            </div>
            <select type="text" class="form-control" id="dataType"
                    name="dataType">
                <option value="sql">sql</option>
                <option value="json">json</option>
                <option value="sql-regex">sql-regex</option>
            </select>
            <div class="input-group-prepend">
                <span class="input-group-text">tinyint转换类型</span>
            </div>
            <select type="text" class="form-control" id="tinyintTransType"
                    name="tinyintTransType">
                <option value="Boolean">Boolean</option>
                <option value="boolean">boolean</option>
                <option value="Integer">Integer</option>
                <option value="int">int</option>
                <option value="String">String</option>
            </select>
            <div class="input-group-prepend">
                <span class="input-group-text">命名转换规则</span>
            </div>
            <select type="text" class="form-control" id="nameCaseType"
                    name="nameCaseType">
                <option value="CamelCase">驼峰</option>
                <option value="UnderScoreCase">下划线</option>
                <#--<option value="UpperUnderScoreCase">大写下划线</option>-->
            </select>
            <div class="input-group-prepend">
                <span class="input-group-text">swagger-ui</span>
            </div>
            <select type="text" class="form-control" id="isSwagger"
                    name="isSwagger">
                <option value="false">关闭</option>
                <option value="true">开启</option>
            </select>
        </div>
        <textarea id="ddlSqlArea" placeholder="请输入表结构信息..." class="form-control btn-lg" style="height: 250px;">
CREATE TABLE 'userinfo' (
  'user_id' int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  'username' varchar(255) NOT NULL COMMENT '用户名',
  'addtime' datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY ('user_id')
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息'
        </textarea>
        <br>
        <p><button class="btn btn-primary btn-lg disabled" id="btnGenCode" role="button" data-toggle="popover" data-content="">开始生成 »</button> <button class="btn alert-secondary" id="btnCopy">一键复制</button></p>
        <div id="history" class="btn-group" role="group" aria-label="Basic example"></div>
        <hr>
        <!-- Example row of columns -->
        <div class="row" style="margin-top: 10px;">
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">通用实体</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="model">entity(set/get)</button>
                    <button type="button" class="btn btn-default generator" id="beetlentity">entity(lombok)</button>
                </div>
            </div>
            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Mybatis</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="mybatis">mybatis</button>
                    <button type="button" class="btn btn-default generator" id="mapper">mapper</button>
                    <button type="button" class="btn btn-default generator" id="service">service</button>
                    <button type="button" class="btn btn-default generator" id="service_impl">service_impl</button>
                    <button type="button" class="btn btn-default generator" id="controller">controller</button>
                </div>
            </div>
        </div>
        <!-- Example row of columns -->
        <div class="row" style="margin-top: 10px;">
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">MybatisPlus</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="plusmapper">mapper</button>
                    <button type="button" class="btn btn-default generator" id="pluscontroller">controller</button>
                </div>
            </div>

            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">UI</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="swagger-ui">swagger-ui</button>
                    <button type="button" class="btn btn-default generator" id="element-ui">element-ui</button>
                    <button type="button" class="btn btn-default generator" id="bootstrap-ui">bootstrap-ui</button>
                </div>
            </div>
        </div>

        <div class="row" style="margin-top: 10px;">
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">BeetlSQL</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="beetlmd">beetlmd</button>
                    <button type="button" class="btn btn-default generator" id="beetlcontroller">beetlcontroller</button>
                </div>
            </div>
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JPA</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="entity">jpa-entity</button>
                    <button type="button" class="btn btn-default generator" id="repository">repository</button>
                    <button type="button" class="btn btn-default generator" id="jpacontroller">controller</button>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top: 10px;">
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">JdbcTemplate</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="jtdaoimpl">daoimpl</button>
                    <button type="button" class="btn btn-default generator" id="jtdao">dao</button>
                </div>
            </div>
            <div class="btn-toolbar col-md-7" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">SQL</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="select">select</button>
                    <button type="button" class="btn btn-default generator" id="insert">insert</button>
                    <button type="button" class="btn btn-default generator" id="update">update</button>
                    <button type="button" class="btn btn-default generator" id="delete">delete</button>
                </div>
            </div>
        </div>
        <div class="row" style="margin-top: 10px;">
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">DTO</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="beetlentitydto">entitydto(lombok+swagger)</button>
                </div>
            </div>
            <div class="btn-toolbar col-md-5" role="toolbar" aria-label="Toolbar with button groups">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <div class="btn btn-secondary disabled setWidth" id="btnGroupAddon">Util</div>
                    </div>
                </div>
                <div class="btn-group" role="group" aria-label="First group">
                    <button type="button" class="btn btn-default generator" id="util">bean get set</button>
                    <button type="button" class="btn btn-default generator" id="json">json</button>
                    <button type="button" class="btn btn-default generator" id="xml">xml</button>
                </div>
            </div>
        </div>
        <hr>
        <textarea id="genCodeArea" class="form-control btn-lg" ></textarea>
    </div>
</div>
    <@netCommon.commonFooter />
</body>
</html>
