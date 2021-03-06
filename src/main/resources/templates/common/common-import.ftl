<#macro commonStyle>

<#-- favicon -->
<link rel="icon" href="http://www.tuyitu.com/_temp/61704630718697.jpg" />

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 4 -->
    <link href="//cdn.staticfile.org/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="//cdn.staticfile.org/font-awesome/5.11.2/css/fontawesome.min.css" rel="stylesheet">
    <!-- Ionicons -->
    <link href="//cdn.staticfile.org/ionicons/4.5.6/css/ionicons.min.css" rel="stylesheet">

    <link href="//cdn.staticfile.org/codemirror/5.48.4/codemirror.min.css" rel="stylesheet">

    <link href="//cdn.bootcss.com/jquery-toast-plugin/1.3.2/jquery.toast.min.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="//cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
    <script src="//cdn.staticfile.org/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

<script>var base_url = '${request.contextPath}';</script>

</#macro>

<#macro commonScript>
    <!-- jQuery -->
    <script src="//cdn.staticfile.org/jquery/3.4.1/jquery.min.js"></script>
    <!-- Bootstrap -->
    <script src="//cdn.staticfile.org/twitter-bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="//cdn.bootcss.com/jquery-toast-plugin/1.3.2/jquery.toast.min.js"></script>
    <!-- FastClick -->
    <script src="//cdn.staticfile.org/fastclick/1.0.6/fastclick.min.js"></script>
    <script src="//cdn.staticfile.org/jQuery-slimScroll/1.3.8/jquery.slimscroll.min.js"></script>
    <script src="//cdn.staticfile.org/codemirror/5.48.4/codemirror.min.js"></script>
    <script src="//cdn.staticfile.org/codemirror/5.48.4/addon/display/placeholder.min.js"></script>
    <script src="//cdn.staticfile.org/codemirror/5.48.4/mode/clike/clike.min.js"></script>
    <script src="//cdn.staticfile.org/codemirror/5.48.4/mode/sql/sql.min.js"></script>
    <script src="//cdn.staticfile.org/codemirror/5.48.4/mode/xml/xml.min.js"></script>
    <!-- json markdown -->
    <script src="//cdn.jsdelivr.net/npm/vue/dist/vue.min.js"></script>
    <script src="//cdn.jsdelivr.net/npm/marked@0.3.6/marked.min.js"></script>
</#macro>

<#macro commonFooter >
    <div class="container">
        <hr>
        <footer>
            <footer class="bd-footer text-muted" role="contentinfo">
                <div class="container">
                    <#assign create_date = "2019-10-01"/>
                    <strong>Copyright &copy; ${.now?string('yyyy')}-2024 &nbsp;
                        <a href="http://beian.miit.gov.cn/publish/query/indexFirst.action" target="_blank"> 京ICP备 20026733号</a>
                    <#--<strong>贡献天数: &nbsp; ${dateDiff(.now,.now)} 天-->
                    <#--<strong>贡献天数: &nbsp; ${.now - (create_date?date("yyyyMMdd"))} 天-->
                    <#--<strong>贡献天数: &nbsp; ${((create_date?date("yyyyMMdd")?string("yyyyMMdd"))!)} 天-->
                        <p>
                            <#--<a href="https://github.com/wanglei0530/jtools" target="_blank">JTools</a>-->
                            <#--由<a href="https://github.com/wanglei0530/jtools" target="_blank">王蕾</a> 开发维护; BeJson/三叔 提供源码分享。点击-->
                            JTools由<a href="https://wanglei0530.github.io/about" target="_blank">王蕾</a>开发维护; 三叔 提供源码分享;
                                <a href="#" id="jiaqun2">联系我</a>
                        </p>
                </div>
            </footer>
        </footer>
    </div> <!-- /container -->
</#macro>

<#macro viewerCounter>
var _hmt = _hmt || [];
(function() {
  //百度统计一下
  var hm = document.createElement("script");
  hm.src = "https://hm.baidu.com/hm.js?97fd5ca1a4298ac8349c7e0de9029a0f";
  var s = document.getElementsByTagName("script")[0];
  s.parentNode.insertBefore(hm, s);
})();
</#macro>