<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JTools - Json转换MarkDown</title>
    <meta name="keywords" content="Json转MarkDown">
    <#import "common/common-import.ftl" as netCommon>
    <@netCommon.commonStyle />
    <@netCommon.commonScript />
</head>
<body style="background-color: #e9ecef">

<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron" id="app">
    <div class="container">
        <h2>Signature authentication!</h2>
        <p class="lead">
            This tool is designed to help developers detect whether the signature generated in the request parameters
            sent when calling [Nanopay API] is correct, and the signature verification result can be obtained after
            submitting relevant information！
        </p>
        <textarea id="area" placeholder="Please enter Json parameters..." class="form-control btn-lg"
                  style="height: 250px;">
{
    "bool":true,
    "int":1,
    "decimal":0.1,
    "string":"hehe",
    "array":[
        1,
        2
    ],
    "list":[
        {
            "merchantId":"2020000808",
            "appId":"2019100107",
            "sign":"3955A91B2CF9BE9EA68710B9B9EEF7A2",
            "thirdOrderId":"SOR15941146945479872",
            "version":"1.0",
            "timestamp":"1598006897301"
        },
        {
            "merchantId":"2020000808",
            "appId":"2019100107",
            "sign":"3955A91B2CF9BE9EA68710B9B9EEF7A2",
            "thirdOrderId":"SOR15941146945479872",
            "version":"1.0",
            "timestamp":"1598006897301"
        }
    ]
}
        </textarea>
        <br>

        <p>
            <#--<button class="btn btn-primary " id="btnGenCode" role="button" data-toggle="popover" data-content="">-->
                <#--Generate-->
            <#--</button>-->
                <button @click="onConvert">转换</button>
        </p>
        <br>

        <textarea id="genCodeArea" class="form-control btn-lg"></textarea></br>

        <p>
            <button class="btn alert-secondary" id="btnCopy">Copy</button>
        </p>
    </div>
</div>
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
        lineWrapping: false,
        readOnly: false,
        foldGutter: true,
        //keyMap:"sublime",
        gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
    });
    ddlSqlArea.setSize('auto', 'auto');
    // controller_ide
    var genCodeArea = CodeMirror.fromTextArea(document.getElementById("genCodeArea"), {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-java",
        lineWrapping: true,
        readOnly: false,
        foldGutter: true,
        //keyMap:"sublime",
        gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
    });
    genCodeArea.setSize('auto', 'auto');

    var codeData;
    // 使用：var jsonObj = $("#formId").serializeObject();
    $.fn.serializeObject = function () {
        var o = {};
        var a = this.serializeArray();
        $.each(a, function () {
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
    var historyCount = 0;
    //初始化清除session
    if (window.sessionStorage) {
        //修复当F5刷新的时候，session没有清空各个值，但是页面的button没了。
        sessionStorage.clear();
    }
    /**
     * 生成代码
     */
    $('#btnGenCode').click(function () {
        var data = ddlSqlArea.getValue();
        console.log("获取输入框：" + data);
        try {
            data = JSON.parse(data);
        } catch (e) {
            $.toast("× fail : 这不是Json字符串");
            return
        }
        const flatten = this.flatten(data);
        const grouped = this.group(flatten);
        const remarks = this.parseRemarks(this.tableMD);

        this.tableMD = `|参数|类型|必填||\n|:-|:-|:-|:-|\n` + makeTableBody(grouped, remarks);


        this.$nextTick(() => {
            this.$refs.output.select()
            document.execCommand('copy')
            $.toast("√ success");
        })
        return false;
    });


    $('#btnCopy').on('click', function () {
        if (!$.isEmptyObject(genCodeArea.getValue()) && !$.isEmptyObject(navigator) && !$.isEmptyObject(navigator.clipboard)) {
            navigator.clipboard.writeText(genCodeArea.getValue());
            $.toast("√ Copy successfully");
        }
    });

});

const sepChar = '.'
const log = console.log
const INDENT_TYPE_KEY = 'indent'


const vm = new Vue({
    el: '#app',
    computed: {
        compiledMarkdown() {
            return marked(this.tableMD, { sanitize: true })
        },
    },
    created() {
        this.json = JSON.stringify(this.obj, null, 2)
    },
    mounted() {
        this.$refs.input.select()
    },
    methods: {
        //获取文本框
        getArea(){
            return CodeMirror.fromTextArea(document.getElementById("area"), {
                lineNumbers: true,
                matchBrackets: true,
                mode: "text/x-sql",
                lineWrapping: false,
                readOnly: false,
                foldGutter: true,
                //keyMap:"sublime",
                gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"]
            }).getValue();
        },
        //生成按钮
        onConvert() {
            var data = this.getArea();
            console.log("获取输入框：" + data);
            try {
                data = JSON.parse(data);
            } catch (e) {
                $.toast("× fail : 这不是Json字符串");
                return
            }
            const flatten = this.flatten(data);
            const grouped = this.group(flatten);
            const remarks = this.parseRemarks(this.tableMD);
            this.tableMD = `|参数|类型|必填||\n|:-|:-|:-|:-|\n` + this.makeTableBody(grouped, remarks);
            this.$nextTick(() => {
                this.$refs.output.select()
                document.execCommand('copy')
                $.toast("√ success");
            })
            return false;
        },
        makeIndent(level) {
            switch (this.indentType) {
                case 'table':
                    return level ? '&nbsp;'.repeat((level - 1) * 5) + '└─ ' : ''
                case 'dash':
                    return '—'.repeat(level) + ' '
                case 'space':
                default:
                    return level ? '　'.repeat(level - 1) + '└' : ''
            }
        },
        makeTableBody(data, remarks) {
            const keys = Object.keys(data)

            let md = ''

            let index = 0
            let prefix = ''

            while (index < keys.length) {
                const key = keys[index]

                if (!key.startsWith(prefix)) {
                    prefix = prefix.split(sepChar).slice(0, -2).join(sepChar)
                    prefix && (prefix += sepChar)
                    continue
                }

                const valType = this.getType(data[key])
                const keyPieces = key.slice(prefix.length).split(sepChar)

                if (keyPieces.length > 1) {
                    prefix += keyPieces[0] + sepChar
                } else {
                    const arg = this.makeIndent(key.split(sepChar).length - 1) + keyPieces[0]
                    const remark = remarks[arg] || '无'
                    <#--md += `|${arg}|${valType}|${this.hasNeedCol ? '是|' : ''}${remark}|\n`-->
                    md += `|` + arg + `|` + valType + `|是|` + remark + `|\n`;
                    index++
                }
            }

            return md
        },
        getType(data) {
            if (Number.isInteger(data)) {
                return 'int'
            }

            const p = Object.prototype.toString.call(data).slice(8, -1)
            if (p === 'Number') {
                return 'decimal'
            } else {
                return p.toLowerCase()
            }
        },
        makeKey(keyChain, key) {
            return keyChain ? ``+keyChain+`.`+keyChain+`` : key
        },
        flatten(data, keyChain = '') {
            let f = {}

            const type = this.getType(data)

            if (type === 'array') {
                keyChain && (f[keyChain] = [])
                // 假设数组中的元素都是一样的类型
                for (let i of data) {
                    const valType = this.getType(i)
                    if (valType === 'object' || valType === 'array') {
                        this.assign(f, this.flatten(i, keyChain))
                    }
                    // 如果是简单类型，则直接中断，不需要再遍历后面的了。数组中有为 null 的元素，则跳过，去看看其他元素的情况
                    else if (valType !== 'null') {
                        f = { [keyChain]: [] }
                        break
                    }
                }
            } else if (type === 'object') {
                keyChain && (f[keyChain] = {})
                Object.keys(data).forEach(key => {
                    this.assign(f, this.flatten(data[key], this.makeKey(keyChain, key)))
                })
            } else {
                f = { [keyChain]: data }
            }

            return f
        },
        assign(tar, source) {
            Object.keys(source).forEach(key => {
                if (tar[key] === undefined || tar[key] === null) {
                    tar[key] = source[key]
                }
            })
        },
        group(data) {
            const keys = Object.keys(data)
            const grouped = {}

            const walk = (index, prefix = '') => {
                if (index >= keys.length) {
                    return
                }

                const key = keys[index]

                if (!prefix || key.startsWith(prefix + sepChar)) {
                    grouped[key] = data[key]
                    walk(index + 1, key)
                }
                walk(index + 1, prefix)
            }

            walk(0)

            return grouped
        },
        parseRemarks(md) {
            const remarks = {}
            md.split('\n')
                    .slice(2)
                    .forEach(line => {
                        const p = line.split('|').slice(1, -1)
                        remarks[p[0]] = p[p.length - 1]
                    })

            return remarks
        },
    },
    watch: {
        indentType(newVal) {
            localStorage.setItem(INDENT_TYPE_KEY, newVal)
        },
    },
})


    // const vm = new Vue({
    //
    //     el: '#app',
    //
    //     computed: {
    //         compiledMarkdown() {
    //             return marked(this.tableMD, { sanitize: true })
    //         },
    //     },
    //
    //     created() {
    //         this.json = JSON.stringify(this.obj, null, 2)
    //     },
    //     mounted() {
    //         this.$refs.input.select()
    //     },
    //     methods: {
    //         makeTableBody(data, remarks) {
    //             const keys = Object.keys(data)
    //
    //             var md = ''
    //
    //             var index = 0
    //             var prefix = ''
    //
    //             while (index < keys.length) {
    //                 const key = keys[index]
    //
    //                 if (!key.startsWith(prefix)) {
    //                     prefix = prefix.split(sepChar).slice(0, -2).join(sepChar)
    //                     prefix && (prefix += sepChar)
    //                     continue
    //                 }
    //
    //                 const valType = this.getType(data[key])
    //                 const keyPieces = key.slice(prefix.length).split(sepChar)
    //                 if (keyPieces.length > 1) {
    //                     prefix += keyPieces[0] + sepChar
    //                 } else {
    //                     const arg = this.makeIndent(key.split(sepChar).length - 1) + keyPieces[0];
    //                     const remark = remarks[arg] || '无';
    //                     md += `|` + arg + `|` + valType + `|是|` + remark + `|\n`;
    //                     index++
    //                 }
    //             }
    //             return md
    //         },
    //
    //         flatten(data, keyChain = '') {
    //             var f = {}
    //
    //             const type = this.getType(data)
    //
    //             if (type === 'array') {
    //                 keyChain && (f[keyChain] = [])
    //                 // 假设数组中的元素都是一样的类型
    //                 for (var i of data) {
    //                     const valType = this.getType(i)
    //                     if (valType === 'object' || valType === 'array') {
    //                         this.assign(f, this.flatten(i, keyChain))
    //                     }
    //                     // 如果是简单类型，则直接中断，不需要再遍历后面的了。数组中有为 null 的元素，则跳过，去看看其他元素的情况
    //                     else if (valType !== 'null') {
    //                         f = {[keyChain]: []}
    //                         break
    //                     }
    //                 }
    //             } else if (type === 'object') {
    //                 keyChain && (f[keyChain] = {})
    //                 Object.keys(data).forEach(key => {
    //                     this.assign(f, this.flatten(data[key], this.makeKey(keyChain, key)))
    //                 })
    //             } else {
    //                 f = {[keyChain]: data}
    //             }
    //             return f
    //         },
    //     },
    // })

</script>
</body>
</html>
